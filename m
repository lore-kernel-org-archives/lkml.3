Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaKRFya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:54:30 -0500
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:43664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbaKRFy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:54:28 -0500
X-Greylist: delayed 83231 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2014 00:54:28 EST
Date: Tue, 18 Nov 2014 12:47:28 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 07/13] usb: chipidea: fix phy handling
Message-ID: <20141118044727.GB15650@shlinux2>
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
 <1416231347-27193-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416231347-27193-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(51704005)(64706001)(99396003)(76176999)(97736003)(21056001)(107046002)(54356999)(87936001)(77156002)(104016003)(62966003)(110136001)(33656002)(47776003)(84676001)(20776003)(68736004)(50986999)(19580395003)(83506001)(6806004)(50466002)(120916001)(105606002)(102836001)(33716001)(4396001)(85426001)(575784001)(31966008)(92726001)(23726002)(44976005)(19580405001)(92566001)(86362001)(46102003)(106466001)(95666004)(46406003)(97756001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 039975700A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0861;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:35:41PM +0100, Antoine Tenart wrote:
> The generic plaftorm device for ChipIdea drivers is probed by calling
> ci_hdrc_probe. The device structure used is not the one of the specific
> ChipIdea driver but the one of the generic ChipIdea platform device.
> 
> This results in not being able to probe the PHYs as we're not using the
> right device structure. Since all ChipIdea drivers are retrieving their
> PHYs in their specific driver code, this didn't impact any of them yet.
> 
> Fixes it using the right device structure (dev->parent).
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index de1e4a84aa93..068e0c6acc3f 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -686,8 +686,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  	} else if (ci->platdata->usb_phy) {
>  		ci->usb_phy = ci->platdata->usb_phy;
>  	} else {
> -		ci->phy = devm_phy_get(dev, "usb-phy");
> -		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +		ci->phy = devm_phy_get(dev->parent, "usb-phy");
> +		ci->usb_phy = devm_usb_get_phy(dev->parent, USB_PHY_TYPE_USB2);
>  
>  		/* if both generic PHY and USB PHY layers aren't enabled */
>  		if (PTR_ERR(ci->phy) == -ENOSYS &&
> -- 
> 2.1.0
> 

Acked-by: Peter Chen <peter.chen@freescale.com>

-- 

Best Regards,
Peter Chen
