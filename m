Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaGVBuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:50:44 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:47061
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242AbaGVBuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:50:40 -0400
Date: Tue, 22 Jul 2014 09:43:31 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <b35083@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] usb: phy: mxs: Add VF610 USB PHY support
Message-ID: <20140722014330.GA10650@shlinux1.ap.freescale.net>
References: <cover.1405702442.git.stefan@agner.ch>
 <af194168fadd80c26f94da740f1e61ce6603225a.1405702442.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <af194168fadd80c26f94da740f1e61ce6603225a.1405702442.git.stefan@agner.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199002)(189002)(24454002)(51704005)(95666004)(54356999)(68736004)(74662001)(102836001)(69596002)(31966008)(79102001)(85306003)(83506001)(50466002)(106466001)(23726002)(81156004)(105606002)(46406003)(76482001)(4396001)(99396002)(76176999)(64706001)(50986999)(110136001)(104016003)(107046002)(21056001)(46102001)(85852003)(97756001)(92726001)(92566001)(81342001)(19580405001)(83322001)(74502001)(84676001)(6806004)(97736001)(33656002)(19580395003)(44976005)(86362001)(87936001)(20776003)(47776003)(80022001)(81542001)(77982001)(83072002)(26826002)(217873001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB477;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
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
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, mxs_phy_dt_ids);
> -- 
> 2.0.1
> 
Acked-by: Peter Chen <peter.chen@freescale.com>

-- 

Best Regards,
Peter Chen
