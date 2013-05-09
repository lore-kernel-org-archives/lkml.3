Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3EIOck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:32:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51376 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3EIOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:32:38 -0400
Message-ID: <518BB377.3000303@ti.com>
Date: Thu, 9 May 2013 10:32:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V3 09/21] thermal: exynos: Move register definitions from
 driver file to data file
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-10-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367931671-3906-10-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OEQXBXCNEOGAQWPWJCOS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OEQXBXCNEOGAQWPWJCOS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Amit,

On 07-05-2013 09:00, Amit Daniel Kachhap wrote:
> This patch migrates the TMU register definition/bitfields to data file.=
 This
> is needed to support SoC's which use the same TMU controller but regist=
er
> validity, offsets or bitfield may slightly vary across SOC's.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |  177 +++++++++------------=
-------
>  drivers/thermal/samsung/exynos_tmu.h      |   76 ++++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.c |   59 ++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h |   68 +++++++++++
>  4 files changed, 260 insertions(+), 120 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 23baeeb..97b87aa 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -36,77 +36,6 @@
>  #include "exynos_tmu.h"
>  #include "exynos_tmu_data.h"
> =20
> -/* Exynos generic registers */
> -#define EXYNOS_TMU_REG_TRIMINFO		0x0
> -#define EXYNOS_TMU_REG_CONTROL		0x20
> -#define EXYNOS_TMU_REG_STATUS		0x28
> -#define EXYNOS_TMU_REG_CURRENT_TEMP	0x40
> -#define EXYNOS_TMU_REG_INTEN		0x70
> -#define EXYNOS_TMU_REG_INTSTAT		0x74
> -#define EXYNOS_TMU_REG_INTCLEAR		0x78
> -
> -#define EXYNOS_TMU_TRIM_TEMP_MASK	0xff
> -#define EXYNOS_TMU_GAIN_SHIFT		8
> -#define EXYNOS_TMU_GAIN_MASK		0xf
> -#define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
> -#define EXYNOS_TMU_REF_VOLTAGE_MASK	0x1f
> -#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
> -#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
> -#define EXYNOS_TMU_CORE_EN_SHIFT	0
> -
> -/* Exynos4210 specific registers */
> -#define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL1	0x54
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL2	0x58
> -#define EXYNOS4210_TMU_REG_TRIG_LEVEL3	0x5C
> -#define EXYNOS4210_TMU_REG_PAST_TEMP0	0x60
> -#define EXYNOS4210_TMU_REG_PAST_TEMP1	0x64
> -#define EXYNOS4210_TMU_REG_PAST_TEMP2	0x68
> -#define EXYNOS4210_TMU_REG_PAST_TEMP3	0x6C
> -
> -#define EXYNOS4210_TMU_TRIG_LEVEL0_MASK	0x1
> -#define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
> -#define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
> -#define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
> -#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
> -#define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
> -
> -/* Exynos5250 and Exynos4412 specific registers */
> -#define EXYNOS_TMU_TRIMINFO_CON	0x14
> -#define EXYNOS_THD_TEMP_RISE		0x50
> -#define EXYNOS_THD_TEMP_FALL		0x54
> -#define EXYNOS_EMUL_CON		0x80
> -
> -#define EXYNOS_TRIMINFO_RELOAD		0x1
> -#define EXYNOS_TRIMINFO_SHIFT		0x0
> -#define EXYNOS_TMU_RISE_INT_MASK	0x111
> -#define EXYNOS_TMU_RISE_INT_SHIFT	0
> -#define EXYNOS_TMU_FALL_INT_MASK	0x111
> -#define EXYNOS_TMU_FALL_INT_SHIFT	12
> -#define EXYNOS_TMU_CLEAR_RISE_INT	0x111
> -#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
> -#define EXYNOS_TMU_TRIP_MODE_SHIFT	13
> -#define EXYNOS_TMU_TRIP_MODE_MASK	0x7
> -#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> -
> -#define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
> -#define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
> -#define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
> -#define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
> -#define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
> -#define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
> -#define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
> -
> -#ifdef CONFIG_THERMAL_EMULATION
> -#define EXYNOS_EMUL_TIME	0x57F0
> -#define EXYNOS_EMUL_TIME_MASK	0xffff
> -#define EXYNOS_EMUL_TIME_SHIFT	16
> -#define EXYNOS_EMUL_DATA_SHIFT	8
> -#define EXYNOS_EMUL_DATA_MASK	0xFF
> -#define EXYNOS_EMUL_ENABLE	0x1
> -#endif /* CONFIG_THERMAL_EMULATION */
> -
>  struct exynos_tmu_data {
>  	struct exynos_tmu_platform_data *pdata;
>  	struct resource *mem;
> @@ -191,6 +120,7 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  {
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
> +	struct exynos_tmu_registers *reg =3D pdata->registers;
>  	unsigned int status, trim_info, con;
>  	unsigned int rising_threshold =3D 0, falling_threshold =3D 0;
>  	int ret =3D 0, threshold_code, i, trigger_levs =3D 0;
> @@ -198,20 +128,20 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	status =3D readb(data->base + EXYNOS_TMU_REG_STATUS);
> +	status =3D readb(data->base + reg->tmu_status);
>  	if (!status) {
>  		ret =3D -EBUSY;
>  		goto out;
>  	}
> =20
> -	if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
> -		__raw_writel(EXYNOS_TRIMINFO_RELOAD,
> -				data->base + EXYNOS_TMU_TRIMINFO_CON);
> -	}
> +	if (data->soc =3D=3D SOC_ARCH_EXYNOS)
> +		__raw_writel(1, data->base + reg->triminfo_ctrl);
> +
>  	/* Save trimming info in order to perform calibration */
> -	trim_info =3D readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
> -	data->temp_error1 =3D trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
> -	data->temp_error2 =3D ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);=

> +	trim_info =3D readl(data->base + reg->triminfo_data);
> +	data->temp_error1 =3D trim_info & EXYNOS_TMU_TEMP_MASK;
> +	data->temp_error2 =3D ((trim_info >> reg->triminfo_85_shift) &
> +				EXYNOS_TMU_TEMP_MASK);

You changed from EXYNOS_TMU_TRIM_TEMP_MASK to EXYNOS_TMU_TEMP_MASK. Was
it this really what you wanted?

> =20
>  	if ((pdata->min_efuse_value > data->temp_error1) ||
>  			(data->temp_error1 > pdata->max_efuse_value) ||
> @@ -231,13 +161,12 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  			goto out;
>  		}
>  		writeb(threshold_code,
> -			data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
> +			data->base + reg->threshold_temp);
>  		for (i =3D 0; i < trigger_levs; i++)
>  			writeb(pdata->trigger_levels[i],
> -			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0 + i * 4);
> +			data->base + reg->threshold_th0 + i * 4);
> =20

Is 4 your addressing unit? I believe there is a macro definition for this=
=2E

> -		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
> -			data->base + EXYNOS_TMU_REG_INTCLEAR);
> +		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
>  	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
>  		/* Write temperature code for rising and falling threshold */
>  		for (i =3D 0; i < trigger_levs; i++) {
> @@ -258,18 +187,19 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  			}
>  			if (pdata->trigger_type[i] !=3D HW_TRIP)
>  				continue;
> -			con =3D readl(data->base + EXYNOS_TMU_REG_CONTROL);
> -			con |=3D (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
> -			writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
> +			con =3D readl(data->base + reg->tmu_ctrl);
> +			con |=3D (1 << reg->therm_trip_en_shift);
> +			writel(con, data->base + reg->tmu_ctrl);
>  		}
> =20
>  		writel(rising_threshold,
> -				data->base + EXYNOS_THD_TEMP_RISE);
> +				data->base + reg->threshold_th0);
>  		writel(falling_threshold,
> -				data->base + EXYNOS_THD_TEMP_FALL);
> +				data->base + reg->threshold_th1);
> =20
> -		writel(EXYNOS_TMU_CLEAR_RISE_INT | EXYNOS_TMU_CLEAR_FALL_INT,
> -				data->base + EXYNOS_TMU_REG_INTCLEAR);
> +		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> +			(reg->inten_fall_mask << reg->inten_fall_shift),
> +				data->base + reg->tmu_intclear);
>  	}
>  out:
>  	clk_disable(data->clk);
> @@ -282,46 +212,46 @@ static void exynos_tmu_control(struct platform_de=
vice *pdev, bool on)
>  {
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
> +	struct exynos_tmu_registers *reg =3D pdata->registers;
>  	unsigned int con, interrupt_en;
> =20
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	con =3D readl(data->base + EXYNOS_TMU_REG_CONTROL);
> +	con =3D readl(data->base + reg->tmu_ctrl);
> =20
>  	if (pdata->reference_voltage) {
> -		con &=3D ~(EXYNOS_TMU_REF_VOLTAGE_MASK <<
> -				EXYNOS_TMU_REF_VOLTAGE_SHIFT);
> -		con |=3D pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
> +		con &=3D ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
> +		con |=3D pdata->reference_voltage << reg->buf_vref_sel_shift;
>  	}
> =20
>  	if (pdata->gain) {
> -		con &=3D ~(EXYNOS_TMU_GAIN_MASK << EXYNOS_TMU_GAIN_SHIFT);
> -		con |=3D (pdata->gain << EXYNOS_TMU_GAIN_SHIFT);
> +		con &=3D ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
> +		con |=3D (pdata->gain << reg->buf_slope_sel_shift);
>  	}
> =20
>  	if (pdata->noise_cancel_mode) {
> -		con &=3D ~(EXYNOS_TMU_TRIP_MODE_MASK <<
> -					EXYNOS_TMU_TRIP_MODE_SHIFT);
> -		con |=3D (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
> +		con &=3D ~(reg->therm_trip_mode_mask <<
> +					reg->therm_trip_mode_shift);
> +		con |=3D (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
>  	}
> =20
>  	if (on) {
> -		con |=3D (1 << EXYNOS_TMU_CORE_EN_SHIFT);
> +		con |=3D (1 << reg->core_en_shift);
>  		interrupt_en =3D
> -		pdata->trigger_enable[3] << EXYNOS_TMU_INTEN_RISE3_SHIFT |
> -		pdata->trigger_enable[2] << EXYNOS_TMU_INTEN_RISE2_SHIFT |
> -		pdata->trigger_enable[1] << EXYNOS_TMU_INTEN_RISE1_SHIFT |
> -		pdata->trigger_enable[0] << EXYNOS_TMU_INTEN_RISE0_SHIFT;
> +			pdata->trigger_enable[3] << reg->inten_rise3_shift |
> +			pdata->trigger_enable[2] << reg->inten_rise2_shift |
> +			pdata->trigger_enable[1] << reg->inten_rise1_shift |
> +			pdata->trigger_enable[0] << reg->inten_rise0_shift;
>  		if (pdata->threshold_falling)
>  			interrupt_en |=3D
> -				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
> +				interrupt_en << reg->inten_fall0_shift;
>  	} else {
> -		con &=3D ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
> +		con &=3D ~(1 << reg->core_en_shift);
>  		interrupt_en =3D 0; /* Disable all interrupts */
>  	}
> -	writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
> -	writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
> +	writel(interrupt_en, data->base + reg->tmu_inten);
> +	writel(con, data->base + reg->tmu_ctrl);
> =20
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -329,13 +259,15 @@ static void exynos_tmu_control(struct platform_de=
vice *pdev, bool on)
> =20
>  static int exynos_tmu_read(struct exynos_tmu_data *data)
>  {
> +	struct exynos_tmu_platform_data *pdata =3D data->pdata;
> +	struct exynos_tmu_registers *reg =3D pdata->registers;
>  	u8 temp_code;
>  	int temp;
> =20
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	temp_code =3D readb(data->base + EXYNOS_TMU_REG_CURRENT_TEMP);
> +	temp_code =3D readb(data->base + reg->tmu_cur_temp);
>  	temp =3D code_to_temp(data, temp_code);
> =20
>  	clk_disable(data->clk);
> @@ -348,7 +280,9 @@ static int exynos_tmu_read(struct exynos_tmu_data *=
data)
>  static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp=
)
>  {
>  	struct exynos_tmu_data *data =3D drv_data;
> -	unsigned int reg;
> +	struct exynos_tmu_platform_data *pdata =3D data->pdata;
> +	struct exynos_tmu_registers *reg =3D pdata->registers;
> +	unsigned int val;
>  	int ret =3D -EINVAL;
> =20
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
> @@ -360,19 +294,19 @@ static int exynos_tmu_set_emulation(void *drv_dat=
a, unsigned long temp)
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	reg =3D readl(data->base + EXYNOS_EMUL_CON);
> +	val =3D readl(data->base + reg->emul_con);
> =20
>  	if (temp) {
>  		temp /=3D MCELSIUS;
> =20
> -		reg =3D (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
> +		val =3D (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
>  			(temp_to_code(data, temp)
> -			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
> +			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
>  	} else {
> -		reg &=3D ~EXYNOS_EMUL_ENABLE;
> +		val &=3D ~EXYNOS_EMUL_ENABLE;
>  	}
> =20
> -	writel(reg, data->base + EXYNOS_EMUL_CON);
> +	writel(val, data->base + reg->emul_con);
> =20
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -389,17 +323,20 @@ static void exynos_tmu_work(struct work_struct *w=
ork)
>  {
>  	struct exynos_tmu_data *data =3D container_of(work,
>  			struct exynos_tmu_data, irq_work);
> +	struct exynos_tmu_platform_data *pdata =3D data->pdata;
> +	struct exynos_tmu_registers *reg =3D pdata->registers;
> =20
>  	exynos_report_trigger();
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> +
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS)
> -		writel(EXYNOS_TMU_CLEAR_RISE_INT |
> -				EXYNOS_TMU_CLEAR_FALL_INT,
> -				data->base + EXYNOS_TMU_REG_INTCLEAR);
> +		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> +			(reg->inten_fall_mask << reg->inten_fall_shift),
> +				data->base + reg->tmu_intclear);
>  	else
> -		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
> -				data->base + EXYNOS_TMU_REG_INTCLEAR);
> +		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> +
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 70cc518..1e5e492 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -46,6 +46,81 @@ enum soc_type {
>  };
> =20
>  /**
> + * struct exynos_tmu_register - register descriptors to access registe=
rs and
> + * bitfields. The register validity, offsets and bitfield values may v=
ary
> + * slightly across different exynos SOC's.

No documentation for your registers? Or at least where to find explanatio=
n?

> + */
> +struct exynos_tmu_registers {
> +	u32	triminfo_data;
> +	u32	triminfo_25_shift;
> +	u32	triminfo_85_shift;
> +
> +	u32	triminfo_ctrl;
> +	u32	triminfo_reload_shift;
> +
> +	u32	tmu_ctrl;
> +	u32	buf_vref_sel_shift;
> +	u32	buf_vref_sel_mask;
> +	u32	therm_trip_mode_shift;
> +	u32	therm_trip_mode_mask;
> +	u32	therm_trip_en_shift;
> +	u32	buf_slope_sel_shift;
> +	u32	buf_slope_sel_mask;
> +	u32	therm_trip_tq_en_shift;
> +	u32	core_en_shift;
> +
> +	u32	tmu_status;
> +
> +	u32	tmu_cur_temp;
> +	u32	tmu_cur_temp_shift;
> +
> +	u32	threshold_temp;
> +
> +	u32	threshold_th0;
> +	u32	threshold_th0_l0_shift;
> +	u32	threshold_th0_l1_shift;
> +	u32	threshold_th0_l2_shift;
> +	u32	threshold_th0_l3_shift;
> +
> +	u32	threshold_th1;
> +	u32	threshold_th1_l0_shift;
> +	u32	threshold_th1_l1_shift;
> +	u32	threshold_th1_l2_shift;
> +	u32	threshold_th1_l3_shift;
> +
> +	u32	threshold_th2;
> +	u32	threshold_th2_l0_shift;
> +
> +	u32	threshold_th3;
> +	u32	threshold_th3_l0_shift;
> +
> +	u32	tmu_inten;
> +	u32	inten_rise_shift;
> +	u32	inten_rise_mask;
> +	u32	inten_fall_shift;
> +	u32	inten_fall_mask;
> +	u32	inten_rise0_shift;
> +	u32	inten_rise1_shift;
> +	u32	inten_rise2_shift;
> +	u32	inten_rise3_shift;
> +	u32	inten_fall0_shift;
> +	u32	inten_fall1_shift;
> +	u32	inten_fall2_shift;
> +	u32	inten_fall3_shift;
> +
> +	u32	tmu_intstat;
> +
> +	u32	tmu_intclear;
> +
> +	u32	tmu_evten;
> +
> +	u32	emul_con;
> +	u32	emul_temp_shift;
> +	u32	emul_time_shift;
> +	u32	emul_time_mask;
> +};
> +
> +/**
>   * struct exynos_tmu_platform_data
>   * @threshold: basic temperature for generating interrupt
>   *	       25 <=3D threshold <=3D 125 [unit: degree Celsius]
> @@ -116,5 +191,6 @@ struct exynos_tmu_platform_data {
>  	enum soc_type type;
>  	struct freq_clip_table freq_tab[4];
>  	unsigned int freq_tab_count;
> +	struct exynos_tmu_registers *registers;
>  };
>  #endif /* _LINUX_EXYNOS_THERMAL_H */
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 6b937f5..3a1ded1 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -25,6 +25,28 @@
>  #include "exynos_tmu_data.h"
> =20
>  #if defined(CONFIG_CPU_EXYNOS4210)
> +static struct exynos_tmu_registers exynos4210_tmu_registers =3D {
> +	.triminfo_data =3D EXYNOS_TMU_REG_TRIMINFO,
> +	.triminfo_25_shift =3D EXYNOS_TRIMINFO_25_SHIFT,
> +	.triminfo_85_shift =3D EXYNOS_TRIMINFO_85_SHIFT,
> +	.tmu_ctrl =3D EXYNOS_TMU_REG_CONTROL,
> +	.buf_vref_sel_shift =3D EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> +	.buf_vref_sel_mask =3D EXYNOS_TMU_REF_VOLTAGE_MASK,
> +	.buf_slope_sel_shift =3D EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> +	.buf_slope_sel_mask =3D EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.core_en_shift =3D EXYNOS_TMU_CORE_EN_SHIFT,
> +	.tmu_status =3D EXYNOS_TMU_REG_STATUS,
> +	.tmu_cur_temp =3D EXYNOS_TMU_REG_CURRENT_TEMP,
> +	.threshold_temp =3D EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
> +	.threshold_th0 =3D EXYNOS4210_TMU_REG_TRIG_LEVEL0,
> +	.tmu_inten =3D EXYNOS_TMU_REG_INTEN,
> +	.inten_rise_mask =3D EXYNOS4210_TMU_TRIG_LEVEL_MASK,
> +	.inten_rise0_shift =3D EXYNOS_TMU_INTEN_RISE0_SHIFT,
> +	.inten_rise1_shift =3D EXYNOS_TMU_INTEN_RISE1_SHIFT,
> +	.inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
> +	.inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
> +	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
> +};
>  struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D =
{
>  	.threshold =3D 80,
>  	.trigger_levels[0] =3D 5,
> @@ -55,10 +77,46 @@ struct exynos_tmu_platform_data const exynos4210_de=
fault_tmu_data =3D {
>  	},
>  	.freq_tab_count =3D 2,
>  	.type =3D SOC_ARCH_EXYNOS4210,
> +	.registers =3D &exynos4210_tmu_registers,
>  };
>  #endif
> =20
>  #if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
> +static struct exynos_tmu_registers exynos5250_tmu_registers =3D {
> +	.triminfo_data =3D EXYNOS_TMU_REG_TRIMINFO,
> +	.triminfo_25_shift =3D EXYNOS_TRIMINFO_25_SHIFT,
> +	.triminfo_85_shift =3D EXYNOS_TRIMINFO_85_SHIFT,
> +	.triminfo_ctrl =3D EXYNOS_TMU_TRIMINFO_CON,
> +	.triminfo_reload_shift =3D EXYNOS_TRIMINFO_RELOAD_SHIFT,
> +	.tmu_ctrl =3D EXYNOS_TMU_REG_CONTROL,
> +	.buf_vref_sel_shift =3D EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> +	.buf_vref_sel_mask =3D EXYNOS_TMU_REF_VOLTAGE_MASK,
> +	.therm_trip_mode_shift =3D EXYNOS_TMU_TRIP_MODE_SHIFT,
> +	.therm_trip_mode_mask =3D EXYNOS_TMU_TRIP_MODE_MASK,
> +	.therm_trip_en_shift =3D EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> +	.buf_slope_sel_shift =3D EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> +	.buf_slope_sel_mask =3D EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.core_en_shift =3D EXYNOS_TMU_CORE_EN_SHIFT,
> +	.tmu_status =3D EXYNOS_TMU_REG_STATUS,
> +	.tmu_cur_temp =3D EXYNOS_TMU_REG_CURRENT_TEMP,
> +	.threshold_th0 =3D EXYNOS_THD_TEMP_RISE,
> +	.threshold_th1 =3D EXYNOS_THD_TEMP_FALL,
> +	.tmu_inten =3D EXYNOS_TMU_REG_INTEN,
> +	.inten_rise_mask =3D EXYNOS_TMU_RISE_INT_MASK,
> +	.inten_rise_shift =3D EXYNOS_TMU_RISE_INT_SHIFT,
> +	.inten_fall_mask =3D EXYNOS_TMU_FALL_INT_MASK,
> +	.inten_fall_shift =3D EXYNOS_TMU_FALL_INT_SHIFT,
> +	.inten_rise0_shift =3D EXYNOS_TMU_INTEN_RISE0_SHIFT,
> +	.inten_rise1_shift =3D EXYNOS_TMU_INTEN_RISE1_SHIFT,
> +	.inten_rise2_shift =3D EXYNOS_TMU_INTEN_RISE2_SHIFT,
> +	.inten_rise3_shift =3D EXYNOS_TMU_INTEN_RISE3_SHIFT,
> +	.inten_fall0_shift =3D EXYNOS_TMU_INTEN_FALL0_SHIFT,
> +	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
> +	.emul_con =3D EXYNOS_EMUL_CON,
> +	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
> +	.emul_time_shift =3D EXYNOS_EMUL_TIME_SHIFT,
> +	.emul_time_mask =3D EXYNOS_EMUL_TIME_MASK,
> +};
>  struct exynos_tmu_platform_data const exynos5250_default_tmu_data =3D =
{
>  	.threshold_falling =3D 10,
>  	.trigger_levels[0] =3D 85,
> @@ -93,5 +151,6 @@ struct exynos_tmu_platform_data const exynos5250_def=
ault_tmu_data =3D {
>  	},
>  	.freq_tab_count =3D 2,
>  	.type =3D SOC_ARCH_EXYNOS,
> +	.registers =3D &exynos5250_tmu_registers,
>  };
>  #endif

One thing, I believe your data can be declared as const.

> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 5b69711..0560413 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -23,6 +23,74 @@
>  #ifndef _LINUX_EXYNOS_TMU_DATA_H
>  #define _LINUX_EXYNOS_TMU_DATA_H
> =20
> +/* Exynos generic registers */
> +#define EXYNOS_TMU_REG_TRIMINFO		0x0
> +#define EXYNOS_TMU_REG_CONTROL		0x20
> +#define EXYNOS_TMU_REG_STATUS		0x28
> +#define EXYNOS_TMU_REG_CURRENT_TEMP	0x40
> +#define EXYNOS_TMU_REG_INTEN		0x70
> +#define EXYNOS_TMU_REG_INTSTAT		0x74
> +#define EXYNOS_TMU_REG_INTCLEAR		0x78
> +
> +#define EXYNOS_TMU_TEMP_MASK		0xff
> +#define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
> +#define EXYNOS_TMU_REF_VOLTAGE_MASK	0x1f
> +#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
> +#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
> +#define EXYNOS_TMU_CORE_EN_SHIFT	0
> +
> +/* Exynos4210 specific registers */
> +#define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
> +#define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
> +#define EXYNOS4210_TMU_REG_TRIG_LEVEL1	0x54
> +#define EXYNOS4210_TMU_REG_TRIG_LEVEL2	0x58
> +#define EXYNOS4210_TMU_REG_TRIG_LEVEL3	0x5C
> +#define EXYNOS4210_TMU_REG_PAST_TEMP0	0x60
> +#define EXYNOS4210_TMU_REG_PAST_TEMP1	0x64
> +#define EXYNOS4210_TMU_REG_PAST_TEMP2	0x68
> +#define EXYNOS4210_TMU_REG_PAST_TEMP3	0x6C
> +
> +#define EXYNOS4210_TMU_TRIG_LEVEL0_MASK	0x1
> +#define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
> +#define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
> +#define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
> +#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
> +#define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
> +
> +/* Exynos5250 and Exynos4412 specific registers */
> +#define EXYNOS_TMU_TRIMINFO_CON	0x14
> +#define EXYNOS_THD_TEMP_RISE		0x50
> +#define EXYNOS_THD_TEMP_FALL		0x54
> +#define EXYNOS_EMUL_CON		0x80
> +
> +#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
> +#define EXYNOS_TRIMINFO_25_SHIFT	0
> +#define EXYNOS_TRIMINFO_85_SHIFT	8
> +#define EXYNOS_TMU_RISE_INT_MASK	0x111
> +#define EXYNOS_TMU_RISE_INT_SHIFT	0
> +#define EXYNOS_TMU_FALL_INT_MASK	0x111
> +#define EXYNOS_TMU_FALL_INT_SHIFT	12
> +#define EXYNOS_TMU_CLEAR_RISE_INT	0x111
> +#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
> +#define EXYNOS_TMU_TRIP_MODE_SHIFT	13
> +#define EXYNOS_TMU_TRIP_MODE_MASK	0x7
> +#define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> +
> +#define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
> +#define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
> +#define EXYNOS_TMU_INTEN_RISE2_SHIFT	8
> +#define EXYNOS_TMU_INTEN_RISE3_SHIFT	12
> +#define EXYNOS_TMU_INTEN_FALL0_SHIFT	16
> +#define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
> +#define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
> +
> +#define EXYNOS_EMUL_TIME	0x57F0
> +#define EXYNOS_EMUL_TIME_MASK	0xffff
> +#define EXYNOS_EMUL_TIME_SHIFT	16
> +#define EXYNOS_EMUL_DATA_SHIFT	8
> +#define EXYNOS_EMUL_DATA_MASK	0xFF
> +#define EXYNOS_EMUL_ENABLE	0x1
> +
>  #if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_EXYNOS_THERMAL_DA=
TA)
>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>=20



------enig2OEQXBXCNEOGAQWPWJCOS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGLs3cACgkQCXcVR3XQvP1teAD/cybWxaL8ISLI97RMqY73tcYH
cf/eB59u186LCDHfk8kBAIfRXiO8cPzfD0ZFqxJQ0YB+7vp6hcCt3caFHt+96Vat
=mhI9
-----END PGP SIGNATURE-----

------enig2OEQXBXCNEOGAQWPWJCOS--
