Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695Ab3FTCWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:22:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37877 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935506Ab3FTCWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:22:43 -0400
Message-ID: <51C26765.6030407@ti.com>
Date: Wed, 19 Jun 2013 22:22:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 25/30] thermal: exynos: Fix to set the second point
 correction value
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-26-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-26-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2CJJAJLVHUTFJSBDVRSND"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2CJJAJLVHUTFJSBDVRSND
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch sets the second point trimming value according to the platfo=
rm
> data if the register value is 0.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index a4dbc84..af0e6ca 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -180,10 +180,15 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  	data->temp_error2 =3D ((trim_info >> reg->triminfo_85_shift) &
>  				EXYNOS_TMU_TEMP_MASK);
> =20
> -	if ((pdata->min_efuse_value > data->temp_error1) ||
> -			(data->temp_error1 > pdata->max_efuse_value) ||
> -			(data->temp_error2 !=3D 0))
> -		data->temp_error1 =3D pdata->efuse_value;
> +	if (!data->temp_error1 ||
> +		(pdata->min_efuse_value > data->temp_error1) ||
> +		(data->temp_error1 > pdata->max_efuse_value))
> +		data->temp_error1 =3D pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
> +
> +	if (!data->temp_error2)
> +		data->temp_error2 =3D
> +			(pdata->efuse_value >> reg->triminfo_85_shift) &
> +			EXYNOS_TMU_TEMP_MASK;
> =20
>  	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>  		dev_err(&pdev->dev, "Invalid max trigger level\n");
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2CJJAJLVHUTFJSBDVRSND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCZ2UACgkQCXcVR3XQvP0EBwD/VZK9GS8xGZMqtVo72a6xW6f/
mA4z//PVeZ/UjgthrA4BANDoCDkstprAcMqVVXG1UNRq9VPdlbzHu5Ix4rd7py8N
=fRlp
-----END PGP SIGNATURE-----

------enig2CJJAJLVHUTFJSBDVRSND--
