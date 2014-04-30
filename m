Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945923AbaD3QX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:23:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33054 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965086AbaD3QXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:23:46 -0400
Date: Wed, 30 Apr 2014 11:23:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Felipe Balbi <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH v8 17/20] usb: phy: msm: Select secondary PHY via TCSR
Message-ID: <20140430162318.GJ23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
 <1398692063-11372-18-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3bvv0EcKsvvYeex"
Content-Disposition: inline
In-Reply-To: <1398692063-11372-18-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u3bvv0EcKsvvYeex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 04:34:20PM +0300, Ivan T. Ivanov wrote:
> From: Tim Bird <tbird20d@gmail.com>
>=20
> Select the secondary PHY using the TCSR register, if phy-num=3D1
> in the DTS (or phy_number is set in the platform data).  The
> SOC has 2 PHYs which can be used with the OTG port, and this
> code allows configuring the correct one.
>=20
> Note: This resolves the problem I was seeing where I couldn't
> get the USB driver working at all on a dragonboard, from cold
> boot.  This patch depends on patch 5/14 from Ivan's msm USB
> patch set.  It does not use DT for the register address, as
> there's no evidence that this address changes between SoC
> versions.
>=20
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> ---
>  drivers/usb/phy/phy-msm-usb.c    | 14 ++++++++++++++
>  include/linux/usb/msm_hsusb_hw.h |  3 +++
>  2 files changed, 17 insertions(+)
>=20
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index db8d963..9437bcf 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1489,6 +1489,7 @@ static int msm_otg_probe(struct platform_device *pd=
ev)
>  	struct resource *res;
>  	struct msm_otg *motg;
>  	struct usb_phy *phy;
> +	void __iomem *phy_select;
>=20
>  	motg =3D devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
>  	if (!motg) {
> @@ -1553,6 +1554,19 @@ static int msm_otg_probe(struct platform_device *p=
dev)
>  	if (IS_ERR(motg->regs))
>  		return PTR_ERR(motg->regs);
>=20
> +	/*
> +	 * NOTE: The PHYs can be multiplexed between the chipidea controller
> +	 * and the dwc3 controller, using a single bit. It is important that
> +	 * the dwc3 driver does not set this bit in an incompatible way.

why would dwc3 access the PHY's address space ?

--=20
balbi

--u3bvv0EcKsvvYeex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYSN2AAoJEIaOsuA1yqREgHcP/AjE9reuixFBQ51Uwk0zsAdi
SOU1H9AvDEYtF+IAXXSEaDckMO4odRsiiHuwc0oElu8e+kKY1bydgdkHtjHHv0+4
ynxo5cgNjJXR5+heAHiLuytt2aUGe0FChiLVDkAv7KLo/vLiRnLGGHHuduGUb2lW
L371pm2EHEc86A9Ap2kt8e3I8VyuiCsJoogiyXs5PrqWN7GlwifekFefM+Bv+1gL
EDnwTqEzIK17wcKmG6END3Zmv5BJK55psyNFhrIDuvJhV67LedNw6oGLfted6sqp
D/GUNBUQPVt1pzWD4pW33I3F4VHBBUcyIBlwrVJVrLC6+LiKh381L6gFg1tSXEdI
Re8bjXPUhhj1CzNg7v0ct5/V6QIWasz8T9q3Wlw6tLsQ88c4xo46CMo3OaqD5Mvq
r+r7gA5J0fk0RLWxMo9hsaqD/AXrdoRJMwu7/tBSojhj9+6ryEPLeBqJ3ycN67MI
4Yk5h1wAjobZ9xX+r9Yy428g03/7V/3jx7soeFv2CR62e33vtapDhOG7GyGB2kfP
qQh1ipnOZ9S5agDxQe63tCOSqRAUbBAmWnhKp5RODYCblyEb2bvf93jJMH/CRgdD
1NI1Tiv9bD16jkofbi7/LnTB9aC0h+cHyt05nH91rCqy52CJp7BfQYTX2DD6daEk
dbctgFqhDQbuV622ZY7J
=pQBv
-----END PGP SIGNATURE-----

--u3bvv0EcKsvvYeex--
