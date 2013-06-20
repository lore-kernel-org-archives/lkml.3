Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567Ab3FTCSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:18:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54211 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935491Ab3FTCSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:18:14 -0400
Message-ID: <51C26659.9050003@ti.com>
Date: Wed, 19 Jun 2013 22:18:01 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 24/30] thermal: exynos: Add thermal configuration data
 for exynos5440 TMU sensor
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-25-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-25-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2HQTIBGQSLDNSIQXNWCXJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HQTIBGQSLDNSIQXNWCXJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds configuration data for exynos5440 soc. Also register
> definations for the controller are added.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    4 ++
>  drivers/thermal/samsung/exynos_tmu_data.c |   71 +++++++++++++++++++++=
++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h |    7 +++
>  3 files changed, 82 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index db4035d..a4dbc84 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -455,6 +455,10 @@ static const struct of_device_id exynos_tmu_match[=
] =3D {
>  		.compatible =3D "samsung,exynos5250-tmu",
>  		.data =3D (void *)EXYNOS5250_TMU_DRV_DATA,
>  	},
> +	{
> +		.compatible =3D "samsung,exynos5440-tmu",
> +		.data =3D (void *)EXYNOS5440_TMU_DRV_DATA,
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 694557e..b34e726 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -175,3 +175,74 @@ struct exynos_tmu_init_data const exynos5250_defau=
lt_tmu_data =3D {
>  	.tmu_count =3D 1,
>  };
>  #endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5440)
> +static const struct exynos_tmu_registers exynos5440_tmu_registers =3D =
{
> +	.triminfo_data =3D EXYNOS5440_TMU_S0_7_TRIM,
> +	.triminfo_25_shift =3D EXYNOS_TRIMINFO_25_SHIFT,
> +	.triminfo_85_shift =3D EXYNOS_TRIMINFO_85_SHIFT,
> +	.tmu_ctrl =3D EXYNOS5440_TMU_S0_7_CTRL,
> +	.buf_vref_sel_shift =3D EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> +	.buf_vref_sel_mask =3D EXYNOS_TMU_REF_VOLTAGE_MASK,
> +	.therm_trip_mode_shift =3D EXYNOS_TMU_TRIP_MODE_SHIFT,
> +	.therm_trip_mode_mask =3D EXYNOS_TMU_TRIP_MODE_MASK,
> +	.therm_trip_en_shift =3D EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> +	.buf_slope_sel_shift =3D EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> +	.buf_slope_sel_mask =3D EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.core_en_shift =3D EXYNOS_TMU_CORE_EN_SHIFT,
> +	.tmu_status =3D EXYNOS5440_TMU_S0_7_STATUS,
> +	.tmu_cur_temp =3D EXYNOS5440_TMU_S0_7_TEMP,
> +	.threshold_th0 =3D EXYNOS5440_TMU_S0_7_TH0,
> +	.threshold_th1 =3D EXYNOS5440_TMU_S0_7_TH1,
> +	.threshold_th2 =3D EXYNOS5440_TMU_S0_7_TH2,
> +	.threshold_th3_l0_shift =3D EXYNOS5440_TMU_TH_RISE4_SHIFT,
> +	.tmu_inten =3D EXYNOS5440_TMU_S0_7_IRQEN,
> +	.inten_rise_mask =3D EXYNOS5440_TMU_RISE_INT_MASK,
> +	.inten_rise_shift =3D EXYNOS5440_TMU_RISE_INT_SHIFT,
> +	.inten_fall_mask =3D EXYNOS5440_TMU_FALL_INT_MASK,
> +	.inten_fall_shift =3D EXYNOS5440_TMU_FALL_INT_SHIFT,
> +	.inten_rise0_shift =3D EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
> +	.inten_rise1_shift =3D EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
> +	.inten_rise2_shift =3D EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
> +	.inten_rise3_shift =3D EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
> +	.inten_fall0_shift =3D EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
> +	.tmu_intstat =3D EXYNOS5440_TMU_S0_7_IRQ,
> +	.tmu_intclear =3D EXYNOS5440_TMU_S0_7_IRQ,
> +	.tmu_irqstatus =3D EXYNOS5440_TMU_IRQ_STATUS,
> +	.emul_con =3D EXYNOS5440_TMU_S0_7_DEBUG,
> +	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
> +	.tmu_pmin =3D EXYNOS5440_TMU_PMIN,
> +};
> +
> +#define EXYNOS5440_TMU_DATA \
> +	.trigger_levels[0] =3D 100, \
> +	.trigger_levels[4] =3D 105, \
> +	.trigger_enable[0] =3D 1, \
> +	.trigger_type[0] =3D SW_TRIP, \
> +	.trigger_type[4] =3D HW_TRIP, \

No active / passive cooling?

> +	.max_trigger_level =3D 5, \
> +	.gain =3D 5, \
> +	.reference_voltage =3D 16, \
> +	.noise_cancel_mode =3D 4, \
> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING, \
> +	.cal_mode =3D 0, \
> +	.efuse_value =3D 0x5b2d, \
> +	.min_efuse_value =3D 16, \
> +	.max_efuse_value =3D 76, \
> +	.first_point_trim =3D 25, \
> +	.second_point_trim =3D 70, \
> +	.default_temp_offset =3D 25, \
> +	.type =3D SOC_ARCH_EXYNOS5440, \
> +	.registers =3D &exynos5440_tmu_registers, \
> +	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
> +			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),

No freq table on 5440? hmm.. So no cpufreq_cooling then? Any reason why
not? I suppose one of these 3 sensors are on your CPU domain, right?

> +
> +struct exynos_tmu_init_data const exynos5440_default_tmu_data =3D {
> +	.tmu_data =3D {
> +		{ EXYNOS5440_TMU_DATA } ,
> +		{ EXYNOS5440_TMU_DATA } ,
> +		{ EXYNOS5440_TMU_DATA } ,
> +	},
> +	.tmu_count =3D 3,
> +};
> +#endif
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index ad263e9..43ce5fb 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -143,4 +143,11 @@ extern struct exynos_tmu_init_data const exynos525=
0_default_tmu_data;
>  #define EXYNOS5250_TMU_DRV_DATA (NULL)
>  #endif
> =20
> +#if defined(CONFIG_SOC_EXYNOS5440)
> +extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
> +#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
> +#else
> +#define EXYNOS5440_TMU_DRV_DATA (NULL)
> +#endif
> +
>  #endif /*_EXYNOS_TMU_DATA_H*/
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2HQTIBGQSLDNSIQXNWCXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCZlkACgkQCXcVR3XQvP1tZAD/cWvOUDlYjivpHS9RWzULJiYK
PdkLyCwI11Jw8kgIafMA/35UQSMKOBJYSjERwzFYwOaC7wT9xZVTsg/tIghagRGl
=wVnq
-----END PGP SIGNATURE-----

------enig2HQTIBGQSLDNSIQXNWCXJ--
