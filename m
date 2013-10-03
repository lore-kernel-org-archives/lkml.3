Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3JCWCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:02:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46318 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab3JCWCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:02:06 -0400
Message-ID: <524DE944.8030603@ti.com>
Date: Thu, 3 Oct 2013 18:01:40 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 2/6] thermal: exynos: Provide separate TMU data for Exynos4412
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1380010102-25817-3-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1380010102-25817-3-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ctPpqo7gjkOEnAFcX0J6R6pgcxIOTvLe6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ctPpqo7gjkOEnAFcX0J6R6pgcxIOTvLe6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Lukasz,

Just minor comments.

On 24-09-2013 04:08, Lukasz Majewski wrote:
> Up till now Exynos5250 and Exynos4412 had the same definitions for TMU
> data. Following commit changes that, by introducing separate
> exynos4412_default_tmu_data structure.
>=20
> Since Exynos4412 was chronologically first, the corresponding name for
> TMU registers and default data was renamed.
>=20
> Additionally, new SOC_ARCH_EXYNOS4412 type has been defined.

It is not clear the objective of the patch itself. Was it just to make
the code more readable or are you fixing something?

>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    7 ++++---
>  drivers/thermal/samsung/exynos_tmu.h      |    1 +
>  drivers/thermal/samsung/exynos_tmu_data.c |   26 ++++++++++++++++++++-=
-----
>  drivers/thermal/samsung/exynos_tmu_data.h |    9 ++++++++-
>  4 files changed, 33 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index b43afda..a858cc4 100644
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
> @@ -630,8 +630,9 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  		return ret;
> =20
>  	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
> -		pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> -				pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS4412 ||
> +	    pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>  		data->soc =3D pdata->type;
>  	else {
>  		ret =3D -EINVAL;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index b364c9e..db37df0 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -41,6 +41,7 @@ enum calibration_mode {
> =20
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
> +	SOC_ARCH_EXYNOS4412,
>  	SOC_ARCH_EXYNOS,
>  	SOC_ARCH_EXYNOS5440,
>  };

I believe the above enum needs some documentation. SOC_ARCH_EXYNOS seams
to be a bit confusing.

> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 9002499..bd08093 100644
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
> @@ -162,15 +162,29 @@ static const struct exynos_tmu_registers exynos52=
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
> +		{ EXYNOS4412_TMU_DATA,
> +		.type =3D SOC_ARCH_EXYNOS4412,
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
> +		{ EXYNOS4412_TMU_DATA,
> +		.type =3D SOC_ARCH_EXYNOS,
> +		},

Please add a comment on this initialization, specially because we start
to mix macros with inline initialization. Starts to be hard to follow.

Besides, I believe
+		{
+			EXYNOS4412_TMU_DATA,
+			.type =3D SOC_ARCH_EXYNOS,
+		},

is a much more common style.


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


--ctPpqo7gjkOEnAFcX0J6R6pgcxIOTvLe6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJN6UcACgkQCXcVR3XQvP2JMAEA9LFqKMnC0Izrnf9fDAeuykqB
BD0Qr0+4Ri3yREgu5awA/RMigHCxddWxu/Cit3Oi/pBIvK1+uazpMeqs8lBhpfaH
=ytK4
-----END PGP SIGNATURE-----

--ctPpqo7gjkOEnAFcX0J6R6pgcxIOTvLe6--
