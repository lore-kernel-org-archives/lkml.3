Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945932AbaGRNwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:52:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47900 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161038AbaGRNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:52:51 -0400
Date: Fri, 18 Jul 2014 08:52:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 6/9] usb: musb: core: properly setup the HW before
 registering it to the USB core
Message-ID: <20140718135205.GF24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:27AM +0200, Lothar Wa=DFmann wrote:
> Without this patch overriding the USBOTG_ID pin by setting the iddig
> bit in the USB_MODE register doesn't work because it happens too late
> to be recognized correctly.

and how did you test this ? Why is it too late ? What was your setup
when testing this ?

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/musb/musb_core.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index f867b44..bbf2aefb 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1988,18 +1988,21 @@ musb_init_controller(struct device *dev, int nIrq=
, void __iomem *ctrl)
> =20
>  	switch (musb->port_mode) {
>  	case MUSB_PORT_MODE_HOST:
> -		status =3D musb_host_setup(musb, plat->power);
> +		status =3D musb_platform_set_mode(musb, MUSB_HOST);
>  		if (status < 0)
>  			goto fail3;
> -		status =3D musb_platform_set_mode(musb, MUSB_HOST);
> +		status =3D musb_host_setup(musb, plat->power);
>  		break;
>  	case MUSB_PORT_MODE_GADGET:
> -		status =3D musb_gadget_setup(musb);
> +		status =3D musb_platform_set_mode(musb, MUSB_PERIPHERAL);
>  		if (status < 0)
>  			goto fail3;
> -		status =3D musb_platform_set_mode(musb, MUSB_PERIPHERAL);
> +		status =3D musb_gadget_setup(musb);
>  		break;
>  	case MUSB_PORT_MODE_DUAL_ROLE:
> +		status =3D musb_platform_set_mode(musb, MUSB_OTG);
> +		if (status < 0)
> +			goto fail3;
>  		status =3D musb_host_setup(musb, plat->power);
>  		if (status < 0)
>  			goto fail3;
> @@ -2008,7 +2011,6 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
>  			musb_host_cleanup(musb);
>  			goto fail3;
>  		}
> -		status =3D musb_platform_set_mode(musb, MUSB_OTG);
>  		break;
>  	default:
>  		dev_err(dev, "unsupported port mode %d\n", musb->port_mode);
> --=20
> 1.7.10.4
>=20

--=20
balbi

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySaFAAoJEIaOsuA1yqREoQgP/2Wv8Md0jKpcGn0baL0eK0oU
cQrtk3rJP96FcyxLD57A0uiFkw6pmtzCUql7WoRZCdOd+a5/JdfpniS2dZx942mE
Bqff34AKqv8gFBWl010c97a6fdx5zbj+qIsS+q0NBJ3sI8JHB0pHIdHvvqAqDZE4
819NMHHiiY6TpD3iNhl+NhTm/YSZS5sWApwpXDrMHnDta53ONlqK3G7Pi2fXKU7D
OPVdlx8eeMM4+EhjO5gcKz/WhAP+JfRVsmCiFkXxwRbuq4gWQJ3pOQBKQHtiJXJz
K5BfWX2PfOLny8fjSB60B5IUBMFXT+ALGm9X/HWvAWOd8cfDejGn/bh5c7gCv5Bq
dftsE3AXDBoM+OmNNAubNyAq1BMI2J+s88L0RTTg2MkYmmEKwWKvl8vRMKlGpQIe
aFbHKkpkT3ZyT31iS3oLa9pc9dkuZ0y0tYz0MiBWz8ws/N4M7IVjZTPIdI/PBOfv
z2Gw6mSfCvo9m/hL9mvkpayYEhfZH8HpfBQypzmLP5HRmb0stgcZUYHhqSbrjSQm
eYLB/01uciOuetRbJKwsB3c4mYrIxI1e9Fp7EA5oHnvnfyC4rKI0LKzU75l1Gh0z
w5/KJv5Qj+ZpA6wr05vO0CcWXVTS2bpkS8CE6EvaxIxxmcqBc9TB3B91Tti8YoCN
lTFEdhb1G10le+VrONoz
=RXcA
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
