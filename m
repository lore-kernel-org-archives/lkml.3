Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3AJUWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:22:50 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.30]:40620
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab3AJUWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:22:46 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hashir Abdi <habdi@microsoft.com>
Subject: RE: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
Thread-Topic: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
Thread-Index: AQHN7ZMwzpyOz2dVkEGMyy/58+nQF5hDBEZQ
Date: Thu, 10 Jan 2013 20:19:55 +0000
Message-ID: <d9ba1dfaa89f4605bdfa6fa3c71dbe68@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1357644403-11140-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1357644403-11140-1-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.156.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BL2PRD0310HT003.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(16676001)(77982001)(49866001)(79102001)(74502001)(47976001)(5343655001)(59766001)(6806001)(5343635001)(33646001)(54316002)(23726001)(4396001)(47776002)(44976002)(31966008)(47446002)(46406002)(74662001)(46102001)(50466001)(50986001)(56776001)(76482001)(54356001)(53806001)(56816002)(47736001)(51856001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB010;H:TK5EX14HUBC102.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0722981D2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Tuesday, January 08, 2013 6:27 AM
> To: gregkh@linuxfoundation.org
> Cc: KY Srinivasan; jasowang@redhat.com; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Hashir Abdi; Tomas Hozza
> Subject: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
> 
> Fix for the daemon code and for hv_set_ifconfig.sh script, so
> that the created ifcfg-* file is consistent with initscripts
> documentation.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c    | 73 ++++++++++++++++++++++---------------------
> --
>  tools/hv/hv_set_ifconfig.sh | 22 ++++++--------
>  2 files changed, 44 insertions(+), 51 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index d25a469..6b56b75 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1162,16 +1162,13 @@ static int process_ip_string(FILE *f, char *ip_string, int
> type)
>  				snprintf(str, sizeof(str), "%s", "DNS");
>  				break;
>  			}
> -			if (i != 0) {
> -				if (type != DNS) {
> -					snprintf(sub_str, sizeof(sub_str),
> -						"_%d", i++);
> -				} else {
> -					snprintf(sub_str, sizeof(sub_str),
> -						"%d", ++i);
> -				}
> -			} else if (type == DNS) {
> +
> +			if (type == DNS) {
>  				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
> +			} else if (type == GATEWAY && i == 0) {
> +				++i;
> +			} else {
> +				snprintf(sub_str, sizeof(sub_str), "%d", i++);
>  			}
> 
> 
> @@ -1191,17 +1188,13 @@ static int process_ip_string(FILE *f, char *ip_string, int
> type)
>  				snprintf(str, sizeof(str), "%s",  "DNS");
>  				break;
>  			}
> -			if ((j != 0) || (type == DNS)) {
> -				if (type != DNS) {
> -					snprintf(sub_str, sizeof(sub_str),
> -						"_%d", j++);
> -				} else {
> -					snprintf(sub_str, sizeof(sub_str),
> -						"%d", ++i);
> -				}
> -			} else if (type == DNS) {
> -				snprintf(sub_str, sizeof(sub_str),
> -					"%d", ++i);
> +
> +			if (type == DNS) {
> +				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
> +			} else if (j == 0) {
> +				++j;
> +			} else {
> +				snprintf(sub_str, sizeof(sub_str), "_%d", j++);
>  			}
>  		} else {
>  			return  HV_INVALIDARG;
> @@ -1244,18 +1237,19 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	 * Here is the format of the ip configuration file:
>  	 *
>  	 * HWADDR=macaddr
> -	 * IF_NAME=interface name
> -	 * DHCP=yes (This is optional; if yes, DHCP is configured)
> +	 * DEVICE=interface name
> +	 * BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is
> configured
> +	 *                       or "none" if no boot-time protocol should be used)
>  	 *
> -	 * IPADDR=ipaddr1
> -	 * IPADDR_1=ipaddr2
> -	 * IPADDR_x=ipaddry (where y = x + 1)
> +	 * IPADDR0=ipaddr1
> +	 * IPADDR1=ipaddr2
> +	 * IPADDRx=ipaddry (where y = x + 1)
>  	 *
> -	 * NETMASK=netmask1
> -	 * NETMASK_x=netmasky (where y = x + 1)
> +	 * NETMASK0=netmask1
> +	 * NETMASKx=netmasky (where y = x + 1)
>  	 *
>  	 * GATEWAY=ipaddr1
> -	 * GATEWAY_x=ipaddry (where y = x + 1)
> +	 * GATEWAYx=ipaddry (where y = x + 1)
>  	 *
>  	 * DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
>  	 *
> @@ -1294,20 +1288,23 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	if (error)
>  		goto setval_error;
> 
> -	error = kvp_write_file(file, "IF_NAME", "", if_name);
> +	error = kvp_write_file(file, "DEVICE", "", if_name);
>  	if (error)
>  		goto setval_error;
> 
> -	if (new_val->dhcp_enabled) {
> -		error = kvp_write_file(file, "DHCP", "", "yes");
> -		if (error)
> -			goto setval_error;
> +	if (new_val->dhcp_enabled)
> +		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> +	else
> +		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> +
> +	if (error)
> +		goto setval_error;
> +
> +	/*
> +	 * We are done!.
> +	 */
> +	goto setval_done;
> 
> -		/*
> -		 * We are done!.
> -		 */
> -		goto setval_done;
> -	}
> 
>  	/*
>  	 * Write the configuration for ipaddress, netmask, gateway and
> diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
> index 3e9427e..00b66be 100755
> --- a/tools/hv/hv_set_ifconfig.sh
> +++ b/tools/hv/hv_set_ifconfig.sh
> @@ -20,18 +20,19 @@
>  # Here is the format of the ip configuration file:
>  #
>  # HWADDR=macaddr
> -# IF_NAME=interface name
> -# DHCP=yes (This is optional; if yes, DHCP is configured)
> +# DEVICE=interface name
> +# BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is configured
> +#                       or "none" if no boot-time protocol should be used)
>  #
> -# IPADDR=ipaddr1
> -# IPADDR_1=ipaddr2
> -# IPADDR_x=ipaddry (where y = x + 1)
> +# IPADDR0=ipaddr1
> +# IPADDR1=ipaddr2
> +# IPADDRx=ipaddry (where y = x + 1)
>  #
> -# NETMASK=netmask1
> -# NETMASK_x=netmasky (where y = x + 1)
> +# NETMASK0=netmask1
> +# NETMASKx=netmasky (where y = x + 1)
>  #
>  # GATEWAY=ipaddr1
> -# GATEWAY_x=ipaddry (where y = x + 1)
> +# GATEWAYx=ipaddry (where y = x + 1)
>  #
>  # DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
>  #
> @@ -53,11 +54,6 @@ echo "NM_CONTROLLED=no" >> $1
>  echo "PEERDNS=yes" >> $1
>  echo "ONBOOT=yes" >> $1
> 
> -dhcp=$(grep "DHCP" $1 2>/dev/null)
> -if [ "$dhcp" != "" ];
> -then
> -echo "BOOTPROTO=dhcp" >> $1;
> -fi
> 
>  cp $1 /etc/sysconfig/network-scripts/
> 
> --
> 1.7.11.7
> 
> 


