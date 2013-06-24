Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3FXPAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:00:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54887 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3FXPA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:00:28 -0400
Message-ID: <51C85EF4.6060509@ti.com>
Date: Mon, 24 Jun 2013 11:00:04 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH V7 08/30] thermal: exynos: Add missing definations and
 code cleanup
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com> <1372071051-3167-9-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1372071051-3167-9-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2EWAGXPJVXFGGTLDDSKHL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EWAGXPJVXFGGTLDDSKHL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-06-2013 06:50, Amit Daniel Kachhap wrote:
> This patch adds some extra register bitfield definations and cleans
> up the code to prepare for moving register macros and definations insid=
e
> the TMU data section. In this code cleanup the TMU enable bit is correc=
tly used
> as bit0 and bit1 is taken care which is reserve bit.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>


> ---
>  drivers/thermal/samsung/exynos_tmu.c |   62 +++++++++++++++++++++++++-=
--------
>  1 files changed, 46 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 5df04a1..fa33a48 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -43,9 +43,12 @@
> =20
>  #define EXYNOS_TMU_TRIM_TEMP_MASK	0xff
>  #define EXYNOS_TMU_GAIN_SHIFT		8
> +#define EXYNOS_TMU_GAIN_MASK		0xf
>  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
> -#define EXYNOS_TMU_CORE_ON		3
> -#define EXYNOS_TMU_CORE_OFF		2
> +#define EXYNOS_TMU_REF_VOLTAGE_MASK	0x1f
> +#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
> +#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
> +#define EXYNOS_TMU_CORE_EN_SHIFT	0
>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET	50
> =20
>  /* Exynos4210 specific registers */
> @@ -63,6 +66,7 @@
>  #define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
>  #define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
>  #define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
> +#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
>  #define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
> =20
>  /* Exynos5250 and Exynos4412 specific registers */
> @@ -72,17 +76,30 @@
>  #define EXYNOS_EMUL_CON		0x80
> =20
>  #define EXYNOS_TRIMINFO_RELOAD		0x1
> +#define EXYNOS_TRIMINFO_SHIFT		0x0
> +#define EXYNOS_TMU_RISE_INT_MASK	0x111
> +#define EXYNOS_TMU_RISE_INT_SHIFT	0
> +#define EXYNOS_TMU_FALL_INT_MASK	0x111
> +#define EXYNOS_TMU_FALL_INT_SHIFT	12
>  #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
> -#define EXYNOS_MUX_ADDR_VALUE		6
> -#define EXYNOS_MUX_ADDR_SHIFT		20
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
> +#define EXYNOS_TMU_TRIP_MODE_MASK	0x7
> +
> +#define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
> +#define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
> +#define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
> +#define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
> +#define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
> +#define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
> +#define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
> =20
>  #define EFUSE_MIN_VALUE 40
>  #define EFUSE_MAX_VALUE 100
> =20
>  #ifdef CONFIG_THERMAL_EMULATION
>  #define EXYNOS_EMUL_TIME	0x57F0
> +#define EXYNOS_EMUL_TIME_MASK	0xffff
>  #define EXYNOS_EMUL_TIME_SHIFT	16
>  #define EXYNOS_EMUL_DATA_SHIFT	8
>  #define EXYNOS_EMUL_DATA_MASK	0xFF
> @@ -261,24 +278,37 @@ static void exynos_tmu_control(struct platform_de=
vice *pdev, bool on)
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	con =3D pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
> -		pdata->gain << EXYNOS_TMU_GAIN_SHIFT;
> +	con =3D readl(data->base + EXYNOS_TMU_REG_CONTROL);
> =20
> -	if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
> -		con |=3D pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
> -		con |=3D (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
> +	if (pdata->reference_voltage) {
> +		con &=3D ~(EXYNOS_TMU_REF_VOLTAGE_MASK <<
> +				EXYNOS_TMU_REF_VOLTAGE_SHIFT);
> +		con |=3D pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
> +	}
> +
> +	if (pdata->gain) {
> +		con &=3D ~(EXYNOS_TMU_GAIN_MASK << EXYNOS_TMU_GAIN_SHIFT);
> +		con |=3D (pdata->gain << EXYNOS_TMU_GAIN_SHIFT);
> +	}
> +
> +	if (pdata->noise_cancel_mode) {
> +		con &=3D ~(EXYNOS_TMU_TRIP_MODE_MASK <<
> +					EXYNOS_TMU_TRIP_MODE_SHIFT);
> +		con |=3D (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
>  	}
> =20
>  	if (on) {
> -		con |=3D EXYNOS_TMU_CORE_ON;
> -		interrupt_en =3D pdata->trigger_level3_en << 12 |
> -			pdata->trigger_level2_en << 8 |
> -			pdata->trigger_level1_en << 4 |
> -			pdata->trigger_level0_en;
> +		con |=3D (1 << EXYNOS_TMU_CORE_EN_SHIFT);
> +		interrupt_en =3D
> +		pdata->trigger_level3_en << EXYNOS_TMU_INTEN_RISE3_SHIFT |
> +		pdata->trigger_level2_en << EXYNOS_TMU_INTEN_RISE2_SHIFT |
> +		pdata->trigger_level1_en << EXYNOS_TMU_INTEN_RISE1_SHIFT |
> +		pdata->trigger_level0_en << EXYNOS_TMU_INTEN_RISE0_SHIFT;
>  		if (pdata->threshold_falling)
> -			interrupt_en |=3D interrupt_en << 16;
> +			interrupt_en |=3D
> +				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
>  	} else {
> -		con |=3D EXYNOS_TMU_CORE_OFF;
> +		con &=3D ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
>  		interrupt_en =3D 0; /* Disable all interrupts */
>  	}
>  	writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2EWAGXPJVXFGGTLDDSKHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHIXvQACgkQCXcVR3XQvP2r8wD9F4n9Pa/EfK9vMyD5c9kM40od
e1Fw1UCRnl354ADqHGkBANQUecqzCyFq12iZBhkgnwDwUHrRYYs1hreUgT0wHI8n
=CPjV
-----END PGP SIGNATURE-----

------enig2EWAGXPJVXFGGTLDDSKHL--
