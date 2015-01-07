Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbAGOga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:36:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51924 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbAGOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:36:29 -0500
Message-ID: <54AD4461.1040203@pengutronix.de>
Date: Wed, 07 Jan 2015 15:36:17 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Aaron Wu <Aaron.wu@analog.com>, adi-buildroot-devel@lists.sourceforge.net,
        wg@grandegger.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bfin_can: rewrite the blackfin CAN driver into arch independent
 style
References: <1419391828-21105-1-git-send-email-Aaron.wu@analog.com>
In-Reply-To: <1419391828-21105-1-git-send-email-Aaron.wu@analog.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9m8Dof6fL3lMJ8dNLNPLjuDnxWQAqQhRN"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9m8Dof6fL3lMJ8dNLNPLjuDnxWQAqQhRN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/24/2014 04:30 AM, Aaron Wu wrote:
> Rewrite the blackfin CAN driver into arch independent style
>=20
> Signed-off-by: Aaron Wu <Aaron.wu@analog.com>

[...]

> @@ -547,6 +543,11 @@ static int bfin_can_probe(struct platform_device *=
pdev)
>  	}
> =20
>  	res_mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res_mem =3D=3D NULL) {
> +		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
> +		return -ENOENT;
> +	}
> +
>  	rx_irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	tx_irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 1);
>  	err_irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 2);
> @@ -555,12 +556,6 @@ static int bfin_can_probe(struct platform_device *=
pdev)
>  		goto exit;
>  	}
> =20
> -	if (!request_mem_region(res_mem->start, resource_size(res_mem),
> -				dev_name(&pdev->dev))) {
> -		err =3D -EBUSY;
> -		goto exit;
> -	}

You should remove the corresponding release_mem_region() from the
remove() function, too.

> -
>  	/* request peripheral pins */
>  	err =3D peripheral_request_list(pdata, dev_name(&pdev->dev));
>  	if (err)
> @@ -573,7 +568,13 @@ static int bfin_can_probe(struct platform_device *=
pdev)
>  	}
> =20
>  	priv =3D netdev_priv(dev);
> -	priv->membase =3D (void __iomem *)res_mem->start;
> +
> +	priv->membase =3D devm_ioremap_resource(&pdev->dev, res_mem);
> +	if (IS_ERR((void *)priv->membase)) {
> +		dev_err(&pdev->dev, "Cannot map IO\n");
> +		return PTR_ERR((void *)priv->membase);

Is this cast still needed?

Can you move the devm_ conversion into a separate patch?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--9m8Dof6fL3lMJ8dNLNPLjuDnxWQAqQhRN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrURhAAoJECte4hHFiupUw28P/248PUrbsancWfFjGYEiwPhJ
ddGM+f3TtTrt9XHEhqgePTGi1Zdp/XA3mO4olu84X2O7ZwcJ/n9NvrI3JuCXpLzw
Klh80RZYlre2qkGW6HpwpuFcEtvNYMcwrRmUSEbYKupPnQK1poonIG/pfIXUA/rw
Ea05WsbaxOJRa9KzeG6Jk8jhn/4km68p1HCM4bf81z3eC1MoYE/0ibzDJcb0KjjL
+PVDrltyejZDjeF6OnOfSHm+CoBKu6k52rPyPh+yC/bzYzp8s5E5EUuflmJJFOEh
JuyLVATpqdtsxAy3jAdXR0xkF7qgiiAGiMI3JrBisLqLx0roTjJ/vyOv0jGHdYjU
qV9zNlizDaWgr1TRRtkkKodnF7/mFoKssvkOAavdxQW8Rxq5dm7hIjKmKg0IM4QT
JYiBT4G4s/7YNUfQx1RnkKx2DXQFVFPTNSi+3YhQ7zTraaWuyl+OuNQX/26TihiQ
Q7DdrfV7SlYtFHjYgNQdDzvkwceB+b9K3idK6c7obKXSRwTy8fDkan8y3LA6tcZx
GwS4MyWmvq/A6EnpF8bCSdlj3MbeMZWDt17fCUoDFFMkGFJGUAG9nwFa2cwkAfZI
s03evZiCP0i1/7u73aZlf9OK8kjdLwIRqOvXHo4lYtdw8T4qX0KmeLQGLovYVyrR
uUiHYzWsk0ZQvp4pIwvh
=6aEw
-----END PGP SIGNATURE-----

--9m8Dof6fL3lMJ8dNLNPLjuDnxWQAqQhRN--
