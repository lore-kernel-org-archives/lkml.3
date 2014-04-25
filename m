Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaDYPQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:16:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38469 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaDYPQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:16:15 -0400
Date: Fri, 25 Apr 2014 10:15:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151556.GH29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-5-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDnEQgWzhgf+8aPe"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-5-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dDnEQgWzhgf+8aPe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:19AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-max77693.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max=
77693.c
> index f0f18e2..2c7c3e1 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1175,23 +1175,22 @@ static int max77693_muic_probe(struct platform_de=
vice *pdev)
>  	}
> =20
>  	/* Initialize extcon device */
> -	info->edev =3D devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
> -				  GFP_KERNEL);
> -	if (!info->edev) {
> +	info->edev =3D devm_extcon_dev_allocate(&pdev->dev,
> +					      max77693_extcon_cable);

you're using spaces for indentation here, I suppose that was intentional
to align the following line to the opening (. No strong feelings but
IIRC checkpatch.pl --strict will complain about it.

> +	if (IS_ERR(info->edev)) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		ret =3D -ENOMEM;
>  		goto err_irq;
>  	}
>  	info->edev->name =3D DEV_NAME;
>  	info->edev->dev.parent =3D &pdev->dev;
> -	info->edev->supported_cable =3D max77693_extcon_cable;
> +
>  	ret =3D devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
>  		goto err_irq;
>  	}
> =20
> -
>  	/* Initialize MUIC register by using platform data or default data */
>  	if (pdata && pdata->muic_data) {
>  		init_data =3D pdata->muic_data->init_data;
> --=20
> 1.8.0
>=20

--=20
balbi

--dDnEQgWzhgf+8aPe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnwsAAoJEIaOsuA1yqREhnMP/RQrAQG5f+LTPl1A8crzbx+v
EYP7TtCH/jJpNNXw2K27AFepdFoxxTJnnWtueA8MkFp/d0otGbxZSO1ko6ATeCgF
+T2/6YnXzIhic+2zt81pWda8cNojIpyFRCGh63X93YRvaAst6ay+ZusETUzIVZub
NCw0K1sBKznPoqn/iAgukJCfEJdOzjcFRuikwdtYjPGvuCqikMd1C2bb1Gnu6aqN
7AFIr6mzGeYAyGkf8lowSpZr8zGCSW1Y0r6vjKXn6VLrxvKL8tmJczc84zIO0YR+
Q40XfxgVfR86NO2sglyDt1+ooU5lQdVcei+YcDOum8g/79bzjZPvKtSvQqnuO1Rn
717HwIjZqToCbqgHZA5MjctG0rcOgzTxpth5dIBcXpkNMBSL7RzdR+lBdLGDkzaV
s18SEIEL09OefzTjtpByoqyNM3GJOilMkIyhxo+PMCJnLfqKxxu+jux2nFcrrPuL
iCd1Qe1VAjn7F2plibz4cl2EWaAwy5JeuU4eLtiaWgU/WV4nnLRhCsq7+wC5N6cj
qFSnUwoNzR3soPFjp+RxA7jFv8NGXgRZj6yETdJOoWBft9gCgxhBJMMyOvDSzisg
f1I3OTQLZXOD7TbKqbR7U6wtCzZG50V3aNuw0yI9HjYmdsKZiZNIvSjZ5kjW9QOJ
dzexE6DwC5PvJZzjdbpw
=vPye
-----END PGP SIGNATURE-----

--dDnEQgWzhgf+8aPe--
