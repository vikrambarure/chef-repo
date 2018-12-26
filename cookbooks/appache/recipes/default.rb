#
# Cookbook:: appache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


package 'httpd' do
  action :install
end

service 'httpd' do 
  action [:start, :enable]  
end

#virtual hosts

node["appache"]["sites"].each do |sitename, data|
  document_root = "/var/www/html/#{sitename}"

  directory "document_root" do
    mode "0755"
    recursive true
  end

  directory "/var/www/html/#{sitename}/public_html" do
    action :create
  end

  directory "/var/www/html/#{sitename}/logs" do
    action :create
  end
 
  template "/etc/httpd/conf/httpd.conf do
    source "virtaulhost.erb"
    variables(
     :document_root => document_root,
     :port => data["port"],
     :serveradmin => data["serveradmin"],
     :servername => data["servername"]
  )
  notifies :restart, "service[httpd]"
  end
  
end
