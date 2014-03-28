Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaC1Ovg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:51:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35639 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaC1Ovf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:51:35 -0400
Date: Fri, 28 Mar 2014 09:49:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>
Subject: Re: [PATCH] extcon: palmas: explicitly set edev name as node name
Message-ID: <20140328144936.GF17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395989462-14613-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1395989462-14613-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 12:21:02PM +0530, Kishon Vijay Abraham I wrote:
> commit ca488 (extcon: of: Remove unnecessary function call by using the
> name of device_node) started using node name instead of device name
> to get the extcon device. This breaks dwc3-omap since it's not able to
> get the extcon device anymore. Fixed it by setting edev name of
> palmas to be the same as its node name.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reported-by: Felipe Balbi <balbi@ti.com>

Thanks Kishon, I tested something similar yesterday and I saw that it
helped a lot. I'm still missing something (maybe DTS) because dwc3 still
didn't probe even after fixing this.

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-palmas.c |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palma=
s.c
> index 2aea4bc..51dee21 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -23,6 +23,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> +#include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/mfd/palmas.h>
>  #include <linux/of.h>
> @@ -188,11 +189,13 @@ static int palmas_usb_probe(struct platform_device =
*pdev)
> =20
>  	palmas_usb->edev.supported_cable =3D palmas_extcon_cable;
>  	palmas_usb->edev.dev.parent =3D palmas_usb->dev;
> +	palmas_usb->edev.name =3D kstrdup(node->name, GFP_KERNEL);
>  	palmas_usb->edev.mutually_exclusive =3D mutually_exclusive;
> =20
>  	status =3D extcon_dev_register(&palmas_usb->edev);
>  	if (status) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
> +		kfree(palmas_usb->edev.name);
>  		return status;
>  	}
> =20
> @@ -230,6 +233,7 @@ static int palmas_usb_probe(struct platform_device *p=
dev)
> =20
>  fail_extcon:
>  	extcon_dev_unregister(&palmas_usb->edev);
> +	kfree(palmas_usb->edev.name);
> =20
>  	return status;
>  }
> @@ -239,6 +243,7 @@ static int palmas_usb_remove(struct platform_device *=
pdev)
>  	struct palmas_usb *palmas_usb =3D platform_get_drvdata(pdev);
> =20
>  	extcon_dev_unregister(&palmas_usb->edev);
> +	kfree(palmas_usb->edev.name);
> =20
>  	return 0;
>  }
> --=20
> 1.7.9.5
>=20

--=20
balbi

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNYwAAAoJEIaOsuA1yqRExLcP/1K4PhSFmwoQM2XV+YC+B1LM
NAOhRUx+d8okwlXDGZFamlSa6uYrsY9msaB9jISvr9FUOOw79fTBR5LYqkolH60A
6JMe0M0OkiXi+OW2pEfVBKQg/ai79gW6FYCbTt3KOc4HIczHRji01TkZdCy1DLaV
nus9FDLTQYDinfW/2xElzN2yPkbsLy6lA6OzhBu7MgIlciKyM/qVE8heZrPqI4fb
9LBVtqL1DB1X/9fg154fin/WNNnTAjvfdlKCD6JofX67ADBF2tKf9UNHBucxT4wx
2Zd6McVvn0s4gWzLpS2/H/H/eslaeSgwTas4GmcI6kGuwfSjGGkJMByKIDR1F4/L
aaPM/i/kXMdP3hJ1F/18hew3KlWmGC/bh/7GAoEX3j6XG5cWHu2H9Exa+2git14n
hIfgBELJnXuGk57WM23lw3ImJg59LMzea/KswMLXx9s2mnhlQ6Q+1u45hGXPo9Ah
OIMWO7sreIwErru10ydoRy788v7ZsNd6PpvWxZgq1WadN19sTF6B5tNhs06karuD
jTJeC4MJy6vYR+qb9wLJEKHemhbFfiBiQRLQdd78L6dKcS8NTVKiPUrtfaE6fGya
8UPw7pbKgpRcRYVXxsABlZHc6CfwwXay5uriPSsSY9fpBMdRG6RDej4rjXsxSxXA
WWJm/KH73DIefF9Md935
=lj7y
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
