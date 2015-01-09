Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbbAICsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:48:05 -0500
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:25692
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbbAICsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:48:03 -0500
Date: Fri, 9 Jan 2015 09:38:19 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Daniel Tang <dt.tangr@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Chipidea: Set connect-at-fullspeed bit when entering
 host mode if CI_HDRC_FORCE_FULLSPEED is set in the platform data
Message-ID: <20150109013817.GA433@shlinux2>
References: <1420337699-28219-1-git-send-email-dt.tangr@gmail.com>
 <1420337699-28219-2-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420337699-28219-2-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(51704005)(199003)(24454002)(110136001)(104016003)(31966008)(50466002)(19580395003)(19580405001)(54356999)(83506001)(69596002)(33656002)(76176999)(6806004)(50986999)(84676001)(85426001)(33716001)(23726002)(87936001)(97756001)(92566001)(86362001)(21056001)(46406003)(47776003)(20776003)(64706001)(107046002)(2950100001)(46102003)(97736003)(62966003)(77156002)(4396001)(81156004)(77096005)(230783001)(120916001)(106466001)(105606002)(68736005)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0626;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR0301MB0626;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0626;
X-Forefront-PRVS: 04519BA941
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0626;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:47:59.9670
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 01:14:59PM +1100, Daniel Tang wrote:
> PORTSC_PFSC is not set on entering host mode which means the USB OTG
> controller will attempt to enumerate USB devices at high speed even when the
> CI_HDRC_FORCE_FULLSPEED flag is set in the platform data.
> 
> This patch ensures it is set right before host mode operations begin if needed.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  drivers/usb/chipidea/host.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index c1694cf..f106d25 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -132,6 +132,9 @@ static int host_start(struct ci_hdrc *ci)
>  	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
>  		hw_write(ci, OP_USBMODE, USBMODE_CI_SDIS, USBMODE_CI_SDIS);
>  
> +	if (ci->platdata->flags & CI_HDRC_FORCE_FULLSPEED)
> +		hw_write(ci, OP_PORTSC, PORTSC_PFSC, PORTSC_PFSC);
> +
>  	return ret;
>  
>  put_hcd:
> -- 
> 2.1.3
> 

looks ok, will push

-- 

Best Regards,
Peter Chen
