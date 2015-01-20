Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbbATTCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:02:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41406 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbATTCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:02:41 -0500
Date: Tue, 20 Jan 2015 13:01:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] usb: extcon: Fix USB-Host cable name
Message-ID: <20150120190147.GD15169@saruman>
Reply-To: <balbi@ti.com>
References: <1421689942-10201-1-git-send-email-rogerq@ti.com>
 <1421689942-10201-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Content-Disposition: inline
In-Reply-To: <1421689942-10201-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:52:19PM +0200, Roger Quadros wrote:
> The recommended name for USB-Host cable state is "USB-Host" and not
> "USB-HOST" as per drivers/extcon/extcon-class.c extcon_cable_name.
>=20
> Change all instances of "USB-HOST" to "USB-Host".
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

I checked that these are not documented and there are no DTS using
USB-HOST, so it's fine to change

Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-palmas.c | 18 +++++++++---------
>  drivers/usb/dwc3/dwc3-omap.c   |  6 +++---
>  drivers/usb/phy/phy-omap-otg.c |  4 ++--
>  drivers/usb/phy/phy-tahvo.c    |  8 ++++----
>  4 files changed, 18 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palma=
s.c
> index 11c6757..6d002c3 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -31,7 +31,7 @@
> =20
>  static const char *palmas_extcon_cable[] =3D {
>  	[0] =3D "USB",
> -	[1] =3D "USB-HOST",
> +	[1] =3D "USB-Host",
>  	NULL,
>  };
> =20
> @@ -93,26 +93,26 @@ static irqreturn_t palmas_id_irq_handler(int irq, voi=
d *_palmas_usb)
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>  		palmas_usb->linkstat =3D PALMAS_USB_STATE_ID;
> -		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
> -		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
> +		extcon_set_cable_state(palmas_usb->edev, "USB-Host", true);
> +		dev_info(palmas_usb->dev, "USB-Host cable is attached\n");
>  	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
>  				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
>  		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>  			PALMAS_USB_ID_INT_LATCH_CLR,
>  			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>  		palmas_usb->linkstat =3D PALMAS_USB_STATE_DISCONNECT;
> -		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
> -		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
> +		extcon_set_cable_state(palmas_usb->edev, "USB-Host", false);
> +		dev_info(palmas_usb->dev, "USB-Host cable is detached\n");
>  	} else if ((palmas_usb->linkstat =3D=3D PALMAS_USB_STATE_ID) &&
>  				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
>  		palmas_usb->linkstat =3D PALMAS_USB_STATE_DISCONNECT;
> -		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
> -		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
> +		extcon_set_cable_state(palmas_usb->edev, "USB-Host", false);
> +		dev_info(palmas_usb->dev, "USB-Host cable is detached\n");
>  	} else if ((palmas_usb->linkstat =3D=3D PALMAS_USB_STATE_DISCONNECT) &&
>  				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
>  		palmas_usb->linkstat =3D PALMAS_USB_STATE_ID;
> -		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
> -		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
> +		extcon_set_cable_state(palmas_usb->edev, "USB-Host", true);
> +		dev_info(palmas_usb->dev, " USB-Host cable is attached\n");
>  	}
> =20
>  	return IRQ_HANDLED;
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 172d64e..6713ad9 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -445,14 +445,14 @@ static int dwc3_omap_extcon_register(struct dwc3_om=
ap *omap)
> =20
>  		omap->id_nb.notifier_call =3D dwc3_omap_id_notifier;
>  		ret =3D extcon_register_interest(&omap->extcon_id_dev,
> -					       edev->name, "USB-HOST",
> +					       edev->name, "USB-Host",
>  					       &omap->id_nb);
>  		if (ret < 0)
> -			dev_vdbg(omap->dev, "failed to register notifier for USB-HOST\n");
> +			dev_vdbg(omap->dev, "failed to register notifier for USB-Host\n");
> =20
>  		if (extcon_get_cable_state(edev, "USB") =3D=3D true)
>  			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
> -		if (extcon_get_cable_state(edev, "USB-HOST") =3D=3D true)
> +		if (extcon_get_cable_state(edev, "USB-Host") =3D=3D true)
>  			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
>  	}
> =20
> diff --git a/drivers/usb/phy/phy-omap-otg.c b/drivers/usb/phy/phy-omap-ot=
g.c
> index 56ee760..53cba3f 100644
> --- a/drivers/usb/phy/phy-omap-otg.c
> +++ b/drivers/usb/phy/phy-omap-otg.c
> @@ -119,7 +119,7 @@ static int omap_otg_probe(struct platform_device *pde=
v)
>  	otg_dev->vbus_nb.notifier_call =3D omap_otg_vbus_notifier;
> =20
>  	ret =3D extcon_register_interest(&otg_dev->id_dev, config->extcon,
> -				       "USB-HOST", &otg_dev->id_nb);
> +				       "USB-Host", &otg_dev->id_nb);
>  	if (ret)
>  		return ret;
> =20
> @@ -130,7 +130,7 @@ static int omap_otg_probe(struct platform_device *pde=
v)
>  		return ret;
>  	}
> =20
> -	otg_dev->id =3D extcon_get_cable_state(extcon, "USB-HOST");
> +	otg_dev->id =3D extcon_get_cable_state(extcon, "USB-Host");
>  	otg_dev->vbus =3D extcon_get_cable_state(extcon, "USB");
>  	omap_otg_set_mode(otg_dev);
> =20
> diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
> index 845f658..56d3704 100644
> --- a/drivers/usb/phy/phy-tahvo.c
> +++ b/drivers/usb/phy/phy-tahvo.c
> @@ -61,7 +61,7 @@ struct tahvo_usb {
>  };
> =20
>  static const char *tahvo_cable[] =3D {
> -	"USB-HOST",
> +	"USB-Host",
>  	"USB",
>  	NULL,
>  };
> @@ -129,7 +129,7 @@ static void tahvo_usb_become_host(struct tahvo_usb *t=
u)
>  {
>  	struct retu_dev *rdev =3D dev_get_drvdata(tu->pt_dev->dev.parent);
> =20
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST", true);
> +	extcon_set_cable_state(&tu->extcon, "USB-Host", true);
> =20
>  	/* Power up the transceiver in USB host mode */
>  	retu_write(rdev, TAHVO_REG_USBR, USBR_REGOUT | USBR_NSUSPEND |
> @@ -148,7 +148,7 @@ static void tahvo_usb_become_peripheral(struct tahvo_=
usb *tu)
>  {
>  	struct retu_dev *rdev =3D dev_get_drvdata(tu->pt_dev->dev.parent);
> =20
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST", false);
> +	extcon_set_cable_state(&tu->extcon, "USB-Host", false);
> =20
>  	/* Power up transceiver and set it in USB peripheral mode */
>  	retu_write(rdev, TAHVO_REG_USBR, USBR_SLAVE_CONTROL | USBR_REGOUT |
> @@ -376,7 +376,7 @@ static int tahvo_usb_probe(struct platform_device *pd=
ev)
>  	}
> =20
>  	/* Set the initial cable state. */
> -	extcon_set_cable_state(&tu->extcon, "USB-HOST",
> +	extcon_set_cable_state(&tu->extcon, "USB-Host",
>  			       tu->tahvo_mode =3D=3D TAHVO_MODE_HOST);
>  	extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
> =20
> --=20
> 2.1.0
>=20

--=20
balbi

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvqYbAAoJEIaOsuA1yqREc1cP/jKr/nUix2Xa+0Urkd5nMmsQ
K1hhnek1OnIDJlyLVsS9szL9nk5ROACArQGl+wovcv7mExYRaI8xD1uJ/MudF7B0
iWu9fPKdyXJSy1ux2xVSzk7SWtuVjVe3rXKWrQ6zzFYBMaYxlE7XQzmJzD+FZwnZ
6TRCb20XJ6ODwVxOP1/hcMGu6VrbFd+G0FV5N/Ou/NI96D1+trEoFp9AT/JLs+Og
qwS3aEIASU9gWEOJHHgLFlExqOJ0xmo8YwKMGFoYLvY1kkIbTbwJfbzD0zGlK2CA
hpXAOTNQF6XDxW8lHnWyckH3M4UwSgmEZDUex4drl7pLtIyUjNDKbeC7TvOHjNiF
CIp9Sx++o5QPfzkBVMnJfN2AuzIZZzb1gZ3pAyrAT9bKiytyul2Et5un6BT5L7rZ
h7CNv4NqTxHg2QGzQjg7CHm0gLpsVFXcoqFGyZ++5xl3QoosmyREwezy27m1Qa74
nP4HBYzLUsZodyD+yNc+neGvwBiP86QZX8ZNDmqjnj0eiR4ebHuTLBbrX2oZsBXB
9oe4dFlcLyykUctzH8+m+wzUYMWisTG+kAbGHGgmv0+tV0haNN3Ca7q61CgRi0DP
FPqcxF/p75KUomMgM9T73frAqThDxVoNMoOh43+kyrhKQtkoX327gYSWO6DXNyxP
Jc4qwDkFJPhJhmcMAUNY
=Was1
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--
