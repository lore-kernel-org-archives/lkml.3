Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbbAHJAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:00:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbbAHJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:00:30 -0500
Message-ID: <54AE46F7.6030106@pengutronix.de>
Date: Thu, 08 Jan 2015 09:59:35 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Aaron Wu <Aaron.wu@analog.com>, wg@grandegger.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
CC: adi-buildroot-devel@lists.sourceforge.net
Subject: Re: [PATCH V2 2/2] bfin_can: rewrite the driver to support the common
References: <1420700254-22529-1-git-send-email-Aaron.wu@analog.com> <1420700254-22529-2-git-send-email-Aaron.wu@analog.com>
In-Reply-To: <1420700254-22529-2-git-send-email-Aaron.wu@analog.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VN13KQ7RAgkXVfmCBoGg1NteHvT1UcxLX"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VN13KQ7RAgkXVfmCBoGg1NteHvT1UcxLX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/08/2015 07:57 AM, Aaron Wu wrote:
> Rewrite the driver to comply to common style with MMU=20
>=20
> Signed-off-by: Aaron Wu <Aaron.wu@analog.com>

Can you please rephrase the subject into a more complete English
sentence. You may use something like "convert driver to use
devm_ioremap_resource()"

> ---
>  drivers/net/can/bfin_can.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/can/bfin_can.c b/drivers/net/can/bfin_can.c
> index 0a5eff4..1d116a7 100644
> --- a/drivers/net/can/bfin_can.c
> +++ b/drivers/net/can/bfin_can.c
> @@ -551,16 +551,10 @@ static int bfin_can_probe(struct platform_device =
*pdev)
>  		goto exit;
>  	}
> =20
> -	if (!request_mem_region(res_mem->start, resource_size(res_mem),
> -				dev_name(&pdev->dev))) {
> -		err =3D -EBUSY;
> -		goto exit;
> -	}
> -
>  	/* request peripheral pins */
>  	err =3D peripheral_request_list(pdata, dev_name(&pdev->dev));
>  	if (err)
> -		goto exit_mem_release;
> +		goto exit;
> =20
>  	dev =3D alloc_bfin_candev();
>  	if (!dev) {
> @@ -569,7 +563,13 @@ static int bfin_can_probe(struct platform_device *=
pdev)
>  	}
> =20
>  	priv =3D netdev_priv(dev);
> -	priv->membase =3D (void __iomem *)res_mem->start;
> +
> +	priv->membase =3D devm_ioremap_resource(&pdev->dev, res_mem);
> +	if (IS_ERR((void *)priv->membase)) {
Is this cast needed?
> +		dev_err(&pdev->dev, "Cannot map IO\n");
> +		return PTR_ERR((void *)priv->membase);
Is this cast needed?
> +	}
> +
>  	priv->rx_irq =3D rx_irq->start;
>  	priv->tx_irq =3D tx_irq->start;
>  	priv->err_irq =3D err_irq->start;
> @@ -601,8 +601,6 @@ exit_candev_free:
>  	free_candev(dev);
>  exit_peri_pin_free:
>  	peripheral_free_list(pdata);
> -exit_mem_release:
> -	release_mem_region(res_mem->start, resource_size(res_mem));
>  exit:
>  	return err;
>  }
> @@ -617,9 +615,6 @@ static int bfin_can_remove(struct platform_device *=
pdev)
> =20
>  	unregister_candev(dev);
> =20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, resource_size(res));
> -
>  	peripheral_free_list(priv->pin_list);
> =20
>  	free_candev(dev);
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--VN13KQ7RAgkXVfmCBoGg1NteHvT1UcxLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUrkb3AAoJECte4hHFiupUAMEP+PHqSsYfbmyTf0ImCOBQcoFn
5s9F4c6J/+zzsg/OY6Tb4jiXSkg+e+1LQUo5pCxn7MhAem+XP5RwSewBPx7sbDbI
yxqOTpyZp2NSn/YGh0qTeMoaWoPN/baUHfajmyC2DjAJbIuyqYoP7pHMBgNFEoBA
XnDJa6Q+bNveFNqUlffRBSlYtq3+SOsmf+yBwe4o0oYQZ6eojV4gzZm7KnWMbdCi
JKi3OMNHuPvnBpVHyyl4qFkHVGX4Fa3hQdQhMa5sUIE9JbLImFr7n5GsTvBiqFO+
3Ix3JsbUJFLlWXqjphFtRM+8Ec6KgnrgSiGZGD6IL8mgXBJP7E2vPWrryF9gZCez
VkNtY+3tMHoHVtCBnXswsmp5pdQ1po/fHkyC7EwI45PDXtbq6iqVVkT4APKRZIvE
mqtBv+R4ZUzVVxUvqjMrke6ZixjJk9i2iEiOzQDYoumN7h1e2XEkNcfI1tj/Ucjc
af6E8KncOyJD8twx5oIG16uOdcz8G5mZYED6VsWGiI0ic5bCl2A6/IhJkyR6RKcM
uQmuH+oyXfhX5cRjPwpR+PODLMW9Lj9QDED/avsIWq9lCDJtTMxbIJqnbm8yrkwu
iAWW5N+mN5DhaedLat6myj6oFqoDv8mySeysgOMoY+iz0gHm/X4+vGMTkQnmhQIZ
Sy0EEtVt1vrCqqXpsY4=
=9vZQ
-----END PGP SIGNATURE-----

--VN13KQ7RAgkXVfmCBoGg1NteHvT1UcxLX--
