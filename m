Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaGVCRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:17:13 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:8733
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751901AbaGVCRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:17:11 -0400
Date: Tue, 22 Jul 2014 10:16:35 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <peter.chen@freescale.com>, <s.hauer@pengutronix.de>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] usb: phy: mxs: Add VF610 USB PHY support
Message-ID: <20140722021634.GQ8537@dragon>
References: <cover.1405702442.git.stefan@agner.ch>
 <af194168fadd80c26f94da740f1e61ce6603225a.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <af194168fadd80c26f94da740f1e61ce6603225a.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(104016003)(21056001)(64706001)(92566001)(19580395003)(87936001)(69596002)(76176999)(33656002)(47776003)(23726002)(31966008)(97756001)(79102001)(110136001)(83072002)(81542001)(85306003)(57986006)(81342001)(92726001)(20776003)(85852003)(86362001)(33716001)(50466002)(99396002)(106466001)(4396001)(76482001)(26826002)(83506001)(102836001)(77982001)(83322001)(50986999)(54356999)(84676001)(44976005)(19580405001)(46406003)(6806004)(95666004)(68736004)(105606002)(46102001)(107046002)(97736001)(74662001)(81156004)(74502001)(80022001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB467;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:01:41PM +0200, Stefan Agner wrote:
> This adds support for the USB PHY in Vybrid VF610. We assume that
> the disconnection without VBUS is also needed for Vybrid. For all
> other flags, the presumption of innocence applies.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/usb/phy/phy-mxs-usb.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
> index c42bdf0..207946b 100644
> --- a/drivers/usb/phy/phy-mxs-usb.c
> +++ b/drivers/usb/phy/phy-mxs-usb.c
> @@ -125,10 +125,15 @@ static const struct mxs_phy_data imx6sl_phy_data = {
>  		MXS_PHY_NEED_IP_FIX,
>  };
>  
> +static const struct mxs_phy_data vf610_phy_data = {
> +	.flags = MXS_PHY_DISCONNECT_LINE_WITHOUT_VBUS,
> +};
> +
>  static const struct of_device_id mxs_phy_dt_ids[] = {
>  	{ .compatible = "fsl,imx6sl-usbphy", .data = &imx6sl_phy_data, },
>  	{ .compatible = "fsl,imx6q-usbphy", .data = &imx6q_phy_data, },
>  	{ .compatible = "fsl,imx23-usbphy", .data = &imx23_phy_data, },
> +	{ .compatible = "fsl,vf610-usbphy", .data = &vf610_phy_data, },

This new compatible string should be documented in
Documentation/devicetree/bindings/usb/mxs-phy.txt.

Shawn

>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, mxs_phy_dt_ids);
> -- 
> 2.0.1
> 
