Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422890AbaGRNu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:50:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52062 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030501AbaGRNux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:50:53 -0400
Date: Fri, 18 Jul 2014 08:50:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 4/9] usb: phy: am335x-control: prevent module from being
 unloaded when in use
Message-ID: <20140718135012.GD24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:25AM +0200, Lothar Wa=DFmann wrote:
> This patch fixes the real cause of the crash that was "fixed" by
> commit 7adb5c876e9c usb: musb: Fix panic upon musb_am335x module removal
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

what is the "real cause of the crash" ? You don't explain that here.

> ---
>  drivers/usb/phy/phy-am335x-control.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-a=
m335x-control.c
> index 35b6083..df3e1ba 100644
> --- a/drivers/usb/phy/phy-am335x-control.c
> +++ b/drivers/usb/phy/phy-am335x-control.c
> @@ -140,6 +140,9 @@ static int am335x_control_usb_probe(struct platform_d=
evice *pdev)
>  	const struct of_device_id *of_id;
>  	const struct phy_control *phy_ctrl;
> =20
> +	if (!try_module_get(pdev->dev.parent->driver->owner))
> +		return -EPROBE_DEFER;
> +
>  	of_id =3D of_match_node(omap_control_usb_id_table, pdev->dev.of_node);
>  	if (!of_id)
>  		return -EINVAL;
> @@ -171,8 +174,15 @@ static int am335x_control_usb_probe(struct platform_=
device *pdev)
>  	return 0;
>  }
> =20
> +static int am335x_control_usb_remove(struct platform_device *pdev)
> +{
> +	module_put(pdev->dev.parent->driver->owner);
> +	return 0;
> +}

I can't see how this can make any difference. Care to explain ?

--=20
balbi

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySYUAAoJEIaOsuA1yqREM1IP/2+Ws5mZCF3XmetoEttCHJZ6
bG61FEOX4nzVwFSu7mGz/be6UMzY6nhwYN2QhHlytY4iEjEMKvZVbmoN+h25lzuB
i+nEAjb+aJTefRQADxGdsm4Ca7HfS2bHOIZ9hAXDpo7F6BP3JOMsSqDULe11k4fh
yAQh8yg/0e91JRoWvc7+4NUjwt3kxFCLNWXgmYobTzMlv652+11WPS1WfnZ6O1bU
9ZMieOTfKbabDAIdWtlrykZh0AnBlCv9FiS47kUGq9SEZjlrrdrdwDH5cQlAS3ed
3uWgH3gOdqGy/LBCjnMh3OHv8PT4K/40g5dQns4Q3rzPQHIvUac/uv2S5KOgiUUr
fErZwd/GlJBpvilNPW+P5b5lRJf/3rVTkhuIymoOAxpMSMgfXRoBqc8RIgzUOTs4
LX5XzB9JCHhJZlC/XXhTBA2lWNjvwc3d+OY7CjU70KMXqB4IDGtUeQ4CkRS9VQps
KikTEdeIfW1gwbH09v4cD9AXl+CLIzkPH6z6AgEo+BVAX/mj5G/yv9CjatlRF/mO
OwetAxE+KUYvf51bkoVTMvUNl5PYULevpP6ayGioER3Pd4oTV1MY//+zzJHguxmK
uP0X4bcvdOqhD1+b+UI9Q7zREqPBvW7LEmhLbrO0BO9unLhDXMADRiUoEkLa3GSW
yVpa8b4inXVgvBajzVUQ
=5sWk
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
