
server = node['hostname'].downcase
lab = server.match(/[^-]*/)
suffix = "ad-#{lab}.local"
value_array = []

node["windows-lab"]["#{lab}"]["#{server}"].each do | attribute, value |
  case 
  when attribute == 'pdc'
    value_array << value
  when attribute == 'bdc'
    value_array << value
  when attribute == 'safe_mode_pass'
    value_array << value
  end
    value_array
end

case
when value_array.at(0) == 'yes'
  windows_ad_domain "#{suffix}" do
    action :create
      type "forest"
      safe_mode_pass "#{value_array.at(2)}"
      options ({  "DomainLevel" => "4",
                  "ForestLevel" => "4",
                  "InstallDNS" => "yes"
        })
  end
when value_array.at(1) == 'yes'
  windows_ad_domain "#{suffix}" do
    action :create
      type "domain"
      safe_mode_pass "#{value_array.at(2)}"
      options ({  "InstallDNS" => "yes" })
  end
end







