Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaDYPPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:15:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50078 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaDYPPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:15:13 -0400
Date: Fri, 25 Apr 2014 10:14:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151453.GG29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:18AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-max8997.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8=
997.c
> index 804a446..d9f7f1b 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -699,16 +699,15 @@ static int max8997_muic_probe(struct platform_devic=
e *pdev)
>  	}
> =20
>  	/* External connector */
> -	info->edev =3D devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
> -				  GFP_KERNEL);
> -	if (!info->edev) {
> +	info->edev =3D devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cabl=
e);
> +	if (IS_ERR(info->edev)) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		ret =3D -ENOMEM;
>  		goto err_irq;
>  	}
>  	info->edev->name =3D DEV_NAME;
>  	info->edev->dev.parent =3D &pdev->dev;
> -	info->edev->supported_cable =3D max8997_extcon_cable;
> +
>  	ret =3D devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
> --=20
> 1.8.0
>=20

--=20
balbi

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnvsAAoJEIaOsuA1yqRElGMQAIS1tnPP3WeCp/RMv3+lqrKF
JBbE/okO+5NjvaEMC0ELFQDT8kJwOb3H23EmmweL7+Rw+aOgAQSucx0aG0k9Hroq
yIANuDAtpeQbuRlFkgw8fwYqQmPIMAu4LzLZkDNuqUja+av8MTSXnXCS9oGDoHTs
AD1eqCVumL/c8Ft/gpTFqMfdFYfGbtYQ+I1PZr5HHINF/Us9nEerabuyYWvdd57Y
vbKX3t4lfXo8TpcnP+06IT3EHXyTNV/a+DibWUxkxbqyDekzkDQkdKegKY4Jjv3K
4CEf7n1TZDMo034yewNnR4Ixw5q+pictXNY+4Ryf34ivAuBrZIigjer5SA7kiySX
6ZxAx+Y32Tue5he+AhWaGHrCpzedNaC4FvHN0k1RieTqM4nM89Vot/EhqJDyKoVw
0ROL8/SIDkoCwKXQ9TAO/xFeLQXvgMb03b7g1u8MQ2eslDxQNgB/ja7Idyr3lEjl
gy6JBFTPVbMsqeLmUf9B9H36jPEJuyxd4dRsZ7UFnM4hvvF9VgPl++MsetJxck2I
gjcm2Nm3hQFM18Jyb0mgGZG7HTaorwrj5iJ5PzPRRu966RIrmcQBAGQ6/AN65YaH
j2PGzgf77BEd38NcLWlMlVMsywN3IpdS80cnid4TyiqNtDMb9rJupodARFEev61m
q97l0P7Y+VGif2PoPkbA
=L7O2
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
