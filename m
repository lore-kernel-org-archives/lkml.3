Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaKQHAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 02:00:34 -0500
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:25645
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaKQHAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 02:00:33 -0500
Date: Mon, 17 Nov 2014 13:53:39 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 07/13] usb: chipidea: fix phy handling
Message-ID: <20141117055338.GC30017@shlinux2>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1415978763-27345-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(51704005)(107046002)(104016003)(87936001)(77156002)(76176999)(64706001)(54356999)(97736003)(92566001)(21056001)(62966003)(110136001)(50986999)(47776003)(20776003)(33656002)(84676001)(68736004)(99396003)(83506001)(44976005)(19580395003)(19580405001)(6806004)(120916001)(105606002)(50466002)(102836001)(33716001)(4396001)(92726001)(23726002)(31966008)(86362001)(575784001)(95666004)(46102003)(106466001)(97756001)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 03982FDC1D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0879;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 04:25:57PM +0100, Antoine Tenart wrote:
> The generic platform device for CI drivers is probed by calling
> ci_hdrc_probe. This is not the same device as the one for the specific
> driver, so the of_node isn't the one we're looking into.
> 
> This result in not being able to probe the phys. Since all CI driver are
> retrieving their phys in the specific code, this didn't impact any of
> them yet.
> 
> Fixes it using the right of node pointer, by using dev->parent instead
> of dev in phy get functions.

It is a correct fix, but the description need to be refined, it is
not related to "of_node" or "node", it is related child/parent device.

> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index ba0ac2723098..36318c85ad65 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -654,8 +654,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
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

-- 

Best Regards,
Peter Chen
