Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaLQB6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:58:10 -0500
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:11401
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbaLQB6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:58:08 -0500
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Topic: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Index: AQHQFGNS+IpG09/9RECk87YcKKuc25yTEC4A
Date: Wed, 17 Dec 2014 01:57:06 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613EA4E5F@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418211200-1166-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1418211200-1166-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 206.191.249.100)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:206.191.249.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(13464003)(164054003)(377454003)(46102003)(4396001)(85426001)(87936001)(21056001)(86146001)(47776003)(2421001)(1511001)(20776003)(97756001)(97736003)(66066001)(64706001)(68736005)(62966003)(2900100001)(102836002)(77156002)(16796002)(2950100001)(33656002)(31966008)(2920100001)(50466002)(92566001)(86362001)(230783001)(69596002)(86612001)(84676001)(81156004)(106466001)(6806004)(107046002)(19580395003)(19580405001)(23726002)(120916001)(55846006)(2501002)(106116001)(76176999)(50986999)(99396003)(105606002)(2656002)(54356999)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1208;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1208;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1208;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2014 01:58:04.5150
 (UTC)
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=72f988bf-86f1-41af-91ab-2d7cd011db47;Ip=[206.191.249.100]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of Dexuan Cui
> Sent: Wednesday, December 10, 2014 19:33 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; vkuznets@redhat.com; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Cc: Haiyang Zhang
> Subject: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
> 
> In the case the host only injects an IPv6 address, the dhcp_enabled flag is
> true (it's only for IPv4 according to Hyper-V host team), but we still need to
> proceed to parse the IPv6 information.
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
> 
> v2: removed the distro-specific logic as Vitaly suggested.
> 
>  tools/hv/hv_kvp_daemon.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 6a6432a..4b3ee35 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1308,16 +1308,17 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	if (error)
>  		goto setval_error;
> 
> +	/*
> +	 * The dhcp_enabled flag is only for IPv4. In the case the host only
> +	 * injects an IPv6 address, the flag is true, but we still need to
> +	 * proceed to parse and pass the IPv6 information to the
> +	 * disto-specific script hv_set_ifconfig.
> +	 */
>  	if (new_val->dhcp_enabled) {
>  		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
>  		if (error)
>  			goto setval_error;
> 
> -		/*
> -		 * We are done!.
> -		 */
> -		goto setval_done;
> -
>  	} else {
>  		error = kvp_write_file(file, "BOOTPROTO", "", "none");
>  		if (error)
> @@ -1345,7 +1346,6 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
>  	if (error)
>  		goto setval_error;
> 
> -setval_done:
>  	fclose(file);
> 
>  	/*
> --
> 1.9.1

Hi Vitaly,
Can you please ACK the v2 patch?
Or, please let me know if you have new comments.

Thanks,
-- Dexuan
