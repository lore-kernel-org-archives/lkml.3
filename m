Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3JNOVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:21:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab3JNOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:21:18 -0400
Message-ID: <525BFDC5.4000109@ti.com>
Date: Mon, 14 Oct 2013 10:20:53 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] thermal: exynos: Provide separate TMU data for
 Exynos4412
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-3-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1381300194-13134-3-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="8QTIFGTxN50L5nUipJ46sVoC4PwddkdTs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8QTIFGTxN50L5nUipJ46sVoC4PwddkdTs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-10-2013 02:29, Lukasz Majewski wrote:
> Up till now Exynos5250 and Exynos4412 had the same definitions for TMU
> data. Following commit changes that, by introducing separate
> exynos4412_default_tmu_data structure.
>=20
> Since Exynos4412 was chronologically first, the corresponding name for
> TMU registers and default data was renamed.
>=20
> Additionally, new SOC_ARCH_EXYNOS4412 type has been defined.
>=20
> Moreover, the SOC_ARCH_EXYNOS name has been changed to SOC_ARCH_EXYNOS5=
250.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>=20
> ---
> Changes for v2:
> - Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
> - Fix coding style for tmu_data elements definition
>=20
>  drivers/thermal/samsung/exynos_tmu.c      |    9 +++++----
>  drivers/thermal/samsung/exynos_tmu.h      |    3 ++-
>  drivers/thermal/samsung/exynos_tmu_data.c |   28 +++++++++++++++++++++=
+------
>  drivers/thermal/samsung/exynos_tmu_data.h |    9 ++++++++-
>  4 files changed, 37 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index b43afda..1312b34 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -488,7 +488,7 @@ static const struct of_device_id exynos_tmu_match[]=
 =3D {
>  	},
>  	{
>  		.compatible =3D "samsung,exynos4412-tmu",
> -		.data =3D (void *)EXYNOS5250_TMU_DRV_DATA,
> +		.data =3D (void *)EXYNOS4412_TMU_DRV_DATA,
>  	},
>  	{
>  		.compatible =3D "samsung,exynos5250-tmu",
> @@ -629,9 +629,10 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>  	if (ret)
>  		return ret;
> =20
> -	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
> -		pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> -				pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
> +	if (pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS4412 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS5250 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>  		data->soc =3D pdata->type;
>  	else {
>  		ret =3D -EINVAL;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index b364c9e..b42ece4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -41,7 +41,8 @@ enum calibration_mode {
> =20
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
> -	SOC_ARCH_EXYNOS,
> +	SOC_ARCH_EXYNOS4412,
> +	SOC_ARCH_EXYNOS5250,
>  	SOC_ARCH_EXYNOS5440,
>  };
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 9002499..d8de5c1 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -90,8 +90,8 @@ struct exynos_tmu_init_data const exynos4210_default_=
tmu_data =3D {
>  };
>  #endif
> =20
> -#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
> -static const struct exynos_tmu_registers exynos5250_tmu_registers =3D =
{
> +#if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)

Below will be only 4412 definitions,right? Why should we test for 5250?

> +static const struct exynos_tmu_registers exynos4412_tmu_registers =3D =
{
>  	.triminfo_data =3D EXYNOS_TMU_REG_TRIMINFO,
>  	.triminfo_25_shift =3D EXYNOS_TRIMINFO_25_SHIFT,
>  	.triminfo_85_shift =3D EXYNOS_TRIMINFO_85_SHIFT,
> @@ -128,7 +128,7 @@ static const struct exynos_tmu_registers exynos5250=
_tmu_registers =3D {
>  	.emul_time_mask =3D EXYNOS_EMUL_TIME_MASK,
>  };
> =20
> -#define EXYNOS5250_TMU_DATA \
> +#define EXYNOS4412_TMU_DATA \
>  	.threshold_falling =3D 10, \
>  	.trigger_levels[0] =3D 85, \
>  	.trigger_levels[1] =3D 103, \
> @@ -162,15 +162,31 @@ static const struct exynos_tmu_registers exynos52=
50_tmu_registers =3D {
>  		.temp_level =3D 103, \
>  	}, \
>  	.freq_tab_count =3D 2, \
> -	.type =3D SOC_ARCH_EXYNOS, \
> -	.registers =3D &exynos5250_tmu_registers, \
> +	.registers =3D &exynos4412_tmu_registers, \
>  	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>  			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>  			TMU_SUPPORT_EMUL_TIME)
> +#endif
> =20
> +#if defined(CONFIG_SOC_EXYNOS4412)
> +struct exynos_tmu_init_data const exynos4412_default_tmu_data =3D {
> +	.tmu_data =3D {
> +		{
> +			EXYNOS4412_TMU_DATA,
> +			.type =3D SOC_ARCH_EXYNOS4412,
> +		},
> +	},
> +	.tmu_count =3D 1,
> +};
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5250)
>  struct exynos_tmu_init_data const exynos5250_default_tmu_data =3D {
>  	.tmu_data =3D {
> -		{ EXYNOS5250_TMU_DATA },
> +		{
> +			EXYNOS4412_TMU_DATA,
> +			.type =3D SOC_ARCH_EXYNOS5250,
> +		},
>  	},
>  	.tmu_count =3D 1,
>  };
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index dc7feb5..b130b1e 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -138,7 +138,14 @@ extern struct exynos_tmu_init_data const exynos421=
0_default_tmu_data;
>  #define EXYNOS4210_TMU_DRV_DATA (NULL)
>  #endif
> =20
> -#if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))=

> +#if defined(CONFIG_SOC_EXYNOS4412)
> +extern struct exynos_tmu_init_data const exynos4412_default_tmu_data;
> +#define EXYNOS4412_TMU_DRV_DATA (&exynos4412_default_tmu_data)
> +#else
> +#define EXYNOS4412_TMU_DRV_DATA (NULL)
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5250)
>  extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
>  #define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
>  #else
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--8QTIFGTxN50L5nUipJ46sVoC4PwddkdTs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJb/c0ACgkQCXcVR3XQvP1AugEAh+JL1Uf3PyuM1lpmTYD4uIAE
GTjhHQFUWTLC9mhYvtcA/250f0nxseUo8V34NabOXuxy+7rDkCTvbDvcXKeoTrlQ
=sLzO
-----END PGP SIGNATURE-----

--8QTIFGTxN50L5nUipJ46sVoC4PwddkdTs--
