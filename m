Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbbAYSVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:21:04 -0500
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:1643
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756152AbbAYSKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:41 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hyperv: else branch not necessary
Thread-Topic: [PATCH] hyperv: else branch not necessary
Thread-Index: AQHQOHyOzavHQ6z7yUONYyjG34zuHpzRIz1Q
Date: Sun, 25 Jan 2015 18:10:37 +0000
Message-ID: <BY2PR0301MB07114B03CF5BB30D44267412A0340@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1422175610-1924-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1422175610-1924-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:548:a62e:74ba:769d]
authentication-results: hofr.at; dkim=none (message not signed)
 header.d=none;hofr.at; dmarc=none action=none header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0774;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-forefront-prvs: 046753C63C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(13464003)(87936001)(62966003)(54606007)(50986999)(76176999)(2656002)(92566002)(19580395003)(106116001)(2900100001)(2950100001)(77156002)(86362001)(102836002)(110136001)(122556002)(19580405001)(76576001)(33656002)(99286002)(54356999)(54206007)(46102003)(74316001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0774;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2015 18:10:37.3414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicholas Mc Guire [mailto:der.herr@hofr.at]
> Sent: Sunday, January 25, 2015 12:47 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Nicholas Mc Guire
> Subject: [PATCH] hyperv: else branch not necessary

Make the subject line clear as to  what subsystem this patch is for.

K. Y
> 
> As the if completes with a unconditional goto the else branch is not needed
> here.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> All paths of execution that did not exit through the if branch will go through
> the else branch so no need for an explicit else here
> 
> Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> CONFIG_HYPERV=m, CONFIG_HYPERV_NET=m
> 
> Patch is against 3.19.0-rc5 -next-20150123
> 
>  drivers/net/hyperv/rndis_filter.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/hyperv/rndis_filter.c
> b/drivers/net/hyperv/rndis_filter.c
> index 7bd8387..efb84a9 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -833,10 +833,10 @@ int rndis_filter_set_packet_filter(struct
> rndis_device *dev, u32 new_filter)
>  		 * send completion for it.
>  		 */
>  		goto exit;
> -	} else {
> -		set_complete = &request-
> >response_msg.msg.set_complete;
> -		status = set_complete->status;
> -	}
> +	}
> +
> +	set_complete = &request->response_msg.msg.set_complete;
> +	status = set_complete->status;
> 
>  cleanup:
>  	if (request)
> --
> 1.7.10.4

