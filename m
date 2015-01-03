Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbbACE0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 23:26:15 -0500
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:19136
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbbACE0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 23:26:14 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Topic: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Index: AQHQJpuOME64Xfh0k0y6QRIhFyMov5yty7GA
Date: Sat, 3 Jan 2015 04:25:48 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA6B3B2@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418211200-1166-1-git-send-email-decui@microsoft.com>
	<F792CF86EFE20D4AB8064279AFBA51C613EA4E5F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87lhllqlrn.fsf@vitty.brq.redhat.com>
In-Reply-To: <87lhllqlrn.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 206.191.249.68)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:206.191.249.68;CTRY:US;IPV:CAL;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(164054003)(13464003)(377454003)(189002)(51704005)(199003)(23726002)(2950100001)(2920100001)(2900100001)(77156002)(62966003)(31966008)(16796002)(4396001)(76176999)(46406003)(54356999)(50986999)(85426001)(21056001)(102836002)(92566001)(97736003)(86146001)(66066001)(106116001)(87936001)(107046002)(2656002)(20776003)(47776003)(230783001)(55846006)(105606002)(26826002)(84676001)(19580405001)(120916001)(6806004)(97756001)(19580395003)(99396003)(64706001)(69596002)(68736005)(81156004)(50466002)(106466001)(86362001)(33656002)(46102003)(86612001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1207;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:ovrnspm;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-DmarcStatus: Failed
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003)(3004003);SRVR:BY1PR0301MB1207;
X-Forefront-PRVS: 0445A82F82
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2015 04:26:08.7179
 (UTC)
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=72f988bf-86f1-41af-91ab-2d7cd011db47;Ip=[206.191.249.68]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1207
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, January 2, 2015 22:51 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection
> work
> 
> Dexuan Cui <decui@microsoft.com> writes:
> 
> >> -----Original Message-----
> >> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> >> Behalf Of Dexuan Cui
> >> Sent: Wednesday, December 10, 2014 19:33 PM
> >> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-
> >> devel@linuxdriverproject.org; vkuznets@redhat.com; olaf@aepfle.de;
> >> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> >> Cc: Haiyang Zhang
> >> Subject: [PATCH v2] tools: hv: kvp_daemon: make IPv6-only-injection work
> >>
> >> In the case the host only injects an IPv6 address, the dhcp_enabled flag is
> >> true (it's only for IPv4 according to Hyper-V host team), but we still need
> to
> >> proceed to parse the IPv6 information.
> >>
> >> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> Cc: K. Y. Srinivasan <kys@microsoft.com>
> >> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >> ---
> >>
> >> v2: removed the distro-specific logic as Vitaly suggested.
> >>
> >>  tools/hv/hv_kvp_daemon.c | 12 ++++++------
> >>  1 file changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> >> index 6a6432a..4b3ee35 100644
> >> --- a/tools/hv/hv_kvp_daemon.c
> >> +++ b/tools/hv/hv_kvp_daemon.c
> >> @@ -1308,16 +1308,17 @@ static int kvp_set_ip_info(char *if_name,
> struct
> >> hv_kvp_ipaddr_value *new_val)
> >>  	if (error)
> >>  		goto setval_error;
> >>
> >> +	/*
> >> +	 * The dhcp_enabled flag is only for IPv4. In the case the host only
> >> +	 * injects an IPv6 address, the flag is true, but we still need to
> >> +	 * proceed to parse and pass the IPv6 information to the
> >> +	 * disto-specific script hv_set_ifconfig.
> >> +	 */
> 
> Actually we just relay what was recieved from the host and it's up to
> distro-specific script how to interpret BOOTPROTO=dhcp now. Additional
> IPv4 addresses (in case we receive them from our host) are not skipped
> now as well.
Yes.

> 
> >>  	if (new_val->dhcp_enabled) {
> >>  		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> >>  		if (error)
> >>  			goto setval_error;
> >>
> >> -		/*
> >> -		 * We are done!.
> >> -		 */
> >> -		goto setval_done;
> >> -
> >>  	} else {
> >>  		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> >>  		if (error)
> >> @@ -1345,7 +1346,6 @@ static int kvp_set_ip_info(char *if_name, struct
> >> hv_kvp_ipaddr_value *new_val)
> >>  	if (error)
> >>  		goto setval_error;
> >>
> >> -setval_done:
> >>  	fclose(file);
> >>
> >>  	/*
> >> --
> >> 1.9.1
> >
> > Hi Vitaly,
> > Can you please ACK the v2 patch?
> 
> Sorry it took me so long to reply, last 3 weeks I was on vacation. I'm
> not particulary sure I'm in charge here to give an ACK :-), but
It's OK. :-)

Thanks, Vitaly!

> 
> Reviewed-By: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> > Or, please let me know if you have new comments.
> >

Greg,  may  I have your comment, or do you need me to resend the
patch since it was last sent  3+ weeks ago?

Thanks,
-- Dexuan
