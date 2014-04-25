Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaDYPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:16:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50133 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaDYPQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:16:24 -0400
Date: Fri, 25 Apr 2014 10:16:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
Message-ID: <20140425151606.GI29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-6-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IbA9xpzOQlG26JSn"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-6-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IbA9xpzOQlG26JSn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:20AM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
>=20
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-max14577.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max=
14577.c
> index d17dd4f..d49e891 100644
> --- a/drivers/extcon/extcon-max14577.c
> +++ b/drivers/extcon/extcon-max14577.c
> @@ -739,14 +739,15 @@ static int max14577_muic_probe(struct platform_devi=
ce *pdev)
>  	}
> =20
>  	/* Initialize extcon device */
> -	info->edev =3D devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL=
);
> -	if (!info->edev) {
> +	info->edev =3D devm_extcon_dev_allocate(&pdev->dev,
> +					      max14577_extcon_cable);
> +	if (IS_ERR(info->edev)) {
>  		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
>  		return -ENOMEM;
>  	}
> =20
>  	info->edev->name =3D dev_name(&pdev->dev);
> -	info->edev->supported_cable =3D max14577_extcon_cable;
> +
>  	ret =3D devm_extcon_dev_register(&pdev->dev, info->edev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to register extcon device\n");
> --=20
> 1.8.0
>=20

--=20
balbi

--IbA9xpzOQlG26JSn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnw2AAoJEIaOsuA1yqREsG0P/RdRWl6WHcza9QMiWqdD+9is
vuTKTkInXsQEQwuyO7xXCjXF6ekGjzIKgvM2AAOf3FmmvsypsCMLxoZ4wyR/aHUe
Tijme6lF3CiqGJWLLWi0w9Fyu9yVEvvl5VRCL5rDxERKwYWGKosdi5LORf/t4Uvw
WP8CDBZPA8p/K5PSlZQ6vEggf08fZJBiVXV/C3k3vyLTmfnA6ZPw6GaBnk5eU4/3
CE8gNObdlkfvuEIjhxQExXnj9G7ItwiHru6S7xn1CCYWoV7VmTKAxtsZgTmlUApG
fcYhhqDxUqe81q/EkG3vGANwATbi8svJiaCQnEWSTC6oCDSPf7+785eE4L6tod73
aWYWFsSHSEPAjJNZvm2voZRcadUEWT0qxlBw4q6T9JewdWoxO1UTtWLum4Nbs+8J
U+eSLTmP9juktrkV1a2juTOo+7HTN69phl8/q3jddvxJfZMcHQnwWv15qfR0qh41
Qg2872mgwzVT0+B75snPeovNEuJPpD6BAaUUmkqKCKlJJJLlwosj2ecNwFpUfI+g
Pi82OZtB68YJF0EVSTgRWF5ewNZkOQZXoab5VW/P9vj7A2rIzP6O67YCxRIu1xDe
QNaaQF8oQ+YsXCc61UJqRc9eH68/9pcj4wyXnioe0AbcOQ2CN3Ksfs0Jsvh/BT5/
l+7liRiVScWoENeWMa0J
=ikPY
-----END PGP SIGNATURE-----

--IbA9xpzOQlG26JSn--
