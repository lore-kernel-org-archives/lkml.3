Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295Ab3FSXJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:09:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSXJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:09:50 -0400
Message-ID: <51C23A2E.1050800@ti.com>
Date: Wed, 19 Jun 2013 19:09:34 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 17/30] thermal: exynos: Remove non DT based support
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-18-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-18-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2BUWUPODRGDMBUSFKENOL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2BUWUPODRGDMBUSFKENOL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> Recently non DT support from Exynos platform is removed and hence
> removing non DT support from the driver also. This will help in easy
> maintainence.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index acbd295..4356118 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -403,19 +403,6 @@ static const struct of_device_id exynos_tmu_match[=
] =3D {
>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>  #endif
> =20
> -static struct platform_device_id exynos_tmu_driver_ids[] =3D {
> -	{
> -		.name		=3D "exynos4210-tmu",
> -		.driver_data    =3D (kernel_ulong_t)EXYNOS4210_TMU_DRV_DATA,
> -	},
> -	{
> -		.name		=3D "exynos5250-tmu",
> -		.driver_data    =3D (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
> -	},
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(platform, exynos_tmu_driver_ids);
> -
>  static inline struct  exynos_tmu_platform_data *exynos_get_driver_data=
(
>  			struct platform_device *pdev)
>  {
> @@ -428,8 +415,7 @@ static inline struct  exynos_tmu_platform_data *exy=
nos_get_driver_data(
>  		return (struct exynos_tmu_platform_data *) match->data;
>  	}
>  #endif
> -	return (struct exynos_tmu_platform_data *)
> -			platform_get_device_id(pdev)->driver_data;
> +	return NULL;
>  }
> =20
>  static int exynos_tmu_probe(struct platform_device *pdev)
> @@ -586,7 +572,6 @@ static struct platform_driver exynos_tmu_driver =3D=
 {
>  	},
>  	.probe =3D exynos_tmu_probe,
>  	.remove	=3D exynos_tmu_remove,
> -	.id_table =3D exynos_tmu_driver_ids,
>  };
> =20
>  module_platform_driver(exynos_tmu_driver);
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2BUWUPODRGDMBUSFKENOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCOi4ACgkQCXcVR3XQvP2lAgD+OEUIEGdRUqYtNCq15vg0LRgF
XoaPWVz/i8u5h30Xm0UBAMQ8VWadiEKA1TdT0VPggJkYNO5c8P+/mw5IXL24jfwh
=tHPJ
-----END PGP SIGNATURE-----

------enig2BUWUPODRGDMBUSFKENOL--
