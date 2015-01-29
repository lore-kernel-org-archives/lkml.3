Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbbA2I0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:26:54 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42455 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbA2I0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:26:52 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c9-54c9eebefdfe
Date: Thu, 29 Jan 2015 09:26:30 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: rui.zhang@intel.com, edubezval@gmail.com, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, amit.daniel@samsung.com,
        kesavan.abhilash@gmail.com, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v4 2/2] thermal: exynos: Add TMU support for Exynos7 SoC
Message-id: <20150129092630.39963382@amdc2363>
In-reply-to: <1422337703-11289-2-git-send-email-a.kesavan@samsung.com>
References: <1422337703-11289-1-git-send-email-a.kesavan@samsung.com>
 <1422337703-11289-2-git-send-email-a.kesavan@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd19706GGPw6aWnxeM1iJouGqyEW
	G2esZ7WYf+Uaq8Wav0oWvQuusllc3jWHzeJz7xFGixnn9zFZPHnYx+bA5bFz1l12j8V7XjJ5
	9G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bJzweZCs6XVcx+voi9gfFhXBcjJ4eEgInE3TtH
	WSBsMYkL99azdTFycQgJLGKUWD6jhx3C+cUo8fTmAbAqFgFViSULm5hBbDYBPYnPd58ygdgi
	AjoSj+f0MILYzAKfGSW6Z8t3MXJwCAv4SCz5nwUS5gUq79uwC6yVU8BNor9jH9hIIYFGRonv
	E7RAbH4BSYn2fz+YIQ6ykzj3aQM7RK+gxI/J91ggxmtJbN7WxAphy0tsXvOWeQKj4CwkZbOQ
	lM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnA0PJPawbiyweIQowAHoxIPL0f9
	yRAh1sSy4srcQ4wSHMxKIrzib4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KEBNITS1Kz
	U1MLUotgskwcnFINjMv5ph2fKbtii4boPuV7rBsL3MNPOFpaBp8VqTi6Jv+LReY8sVml5l58
	e6d23nQIZim0Mau57dx0gTvr1Ske64xjT+fk5bjYLZGIffb+8iOfzGNfarQbMm1/5wQYH/y5
	qiPqulguq/yHrFMLHrRfCD5V6jaDbUXW6nwz+chlrT/6ppbtMjdLVGIpzkg01GIuKk4EAHPb
	KouCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

> Add registers, bit fields and compatible strings for Exynos7 TMU
> (Thermal Management Unit). Following are a few of the differences
> in the Exynos7 TMU from earlier SoCs:
>         - 8 trigger levels
>         - Different bit offsets and more registers for the rising
>         and falling thresholds.
>         - New power down detection bit in the TMU_CONTROL register
>         which does not update the CURRENT_TEMP0 when tmu power down
>         is detected.
>         - Change in bit offset for the NEXT_DATA field of EMUL_CON
>         register. EMUL_CON register address has also changed.
>         - INTSTAT and INTCLEAR registers present in earlier SoCs
>         have been combined into one INTPEND register. The register
>         address for INTCLEAR and INTPEND is also different.
>         - Since there are 8 rising/falling interrupts as against
>         at most 4 in earlier SoCs the INTEN bit offsets are different.
>         - Multiple probe support which is handled by a TMU_CONTROL1
>         register (No support for this in the current patch).
> 
> This patch adds special clock support required only for Exynos7. It
> also updates the "code_to_temp" prototype as Exynos7 has 9 bit
> code-temp mapping.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> This patch set has been tested on linux next-20150123 with Eduardo's
> thermal-next branch merged along with the arch-side exynos7 related
> dts changes applied.
> 
> Changes since v3:
> Addressed comments from Lukasz Majewski:
> 	- Added more comments in the code setting the thresholds.
> 	- Split the documentation out into another patch.
> Changes since v2:
> 	- Rebased on top of Lukasz' latest exynos tmu series (v4).
> 	- Added new exynos7 soc_type.
> Changes since v1:
> 	- Rebased on top of Lukasz' latest exynos tmu series (v2).
> 	- Added sclk support to patch adding Exynos7 tmu support.
> 	Previously, it was a separate patch.
> 	- Used the SOC type to decide if sclk is present.
> 
>  drivers/thermal/samsung/exynos_tmu.c |  204
> ++++++++++++++++++++++++++++++++--
> drivers/thermal/samsung/exynos_tmu.h |    1 + 2 files changed, 197
> insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c
> b/drivers/thermal/samsung/exynos_tmu.c index 852e622..660ff69 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -119,6 +119,26 @@
>  #define EXYNOS5440_TMU_TH_RISE4_SHIFT		24
>  #define EXYNOS5440_EFUSE_SWAP_OFFSET		8
>  
> +/* Exynos7 specific registers */
> +#define EXYNOS7_THD_TEMP_RISE7_6		0x50
> +#define EXYNOS7_THD_TEMP_FALL7_6		0x60
> +#define EXYNOS7_TMU_REG_INTEN			0x110
> +#define EXYNOS7_TMU_REG_INTPEND			0x118
> +#define EXYNOS7_TMU_REG_EMUL_CON		0x160
> +
> +#define EXYNOS7_TMU_TEMP_MASK			0x1ff
> +#define EXYNOS7_PD_DET_EN_SHIFT			23
> +#define EXYNOS7_TMU_INTEN_RISE0_SHIFT		0
> +#define EXYNOS7_TMU_INTEN_RISE1_SHIFT		1
> +#define EXYNOS7_TMU_INTEN_RISE2_SHIFT		2
> +#define EXYNOS7_TMU_INTEN_RISE3_SHIFT		3
> +#define EXYNOS7_TMU_INTEN_RISE4_SHIFT		4
> +#define EXYNOS7_TMU_INTEN_RISE5_SHIFT		5
> +#define EXYNOS7_TMU_INTEN_RISE6_SHIFT		6
> +#define EXYNOS7_TMU_INTEN_RISE7_SHIFT		7
> +#define EXYNOS7_EMUL_DATA_SHIFT			7
> +#define EXYNOS7_EMUL_DATA_MASK			0x1ff
> +
>  #define MCELSIUS	1000
>  /**
>   * struct exynos_tmu_data : A structure to hold the private data of
> the TMU @@ -133,6 +153,7 @@
>   * @lock: lock to implement synchronization.
>   * @clk: pointer to the clock structure.
>   * @clk_sec: pointer to the clock structure for accessing the
> base_second.
> + * @sclk: pointer to the clock structure for accessing the tmu
> special clk.
>   * @temp_error1: fused value of the first point trim.
>   * @temp_error2: fused value of the second point trim.
>   * @regulator: pointer to the TMU regulator structure.
> @@ -152,8 +173,8 @@ struct exynos_tmu_data {
>  	enum soc_type soc;
>  	struct work_struct irq_work;
>  	struct mutex lock;
> -	struct clk *clk, *clk_sec;
> -	u8 temp_error1, temp_error2;
> +	struct clk *clk, *clk_sec, *sclk;
> +	u16 temp_error1, temp_error2;
>  	struct regulator *regulator;
>  	struct thermal_zone_device *tzd;
>  
> @@ -223,7 +244,7 @@ static int temp_to_code(struct exynos_tmu_data
> *data, u8 temp)
>   * Calculate a temperature value from a temperature code.
>   * The unit of the temperature is degree Celsius.
>   */
> -static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
> +static int code_to_temp(struct exynos_tmu_data *data, u16 temp_code)
>  {
>  	struct exynos_tmu_platform_data *pdata = data->pdata;
>  	int temp;
> @@ -513,6 +534,84 @@ static int exynos5440_tmu_initialize(struct
> platform_device *pdev) return ret;
>  }
>  
> +static int exynos7_tmu_initialize(struct platform_device *pdev)
> +{
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	struct thermal_zone_device *tz = data->tzd;
> +	struct exynos_tmu_platform_data *pdata = data->pdata;
> +	unsigned int status, trim_info;
> +	unsigned int rising_threshold = 0, falling_threshold = 0;
> +	int ret = 0, threshold_code, i;
> +	unsigned long temp, temp_hist;
> +	unsigned int reg_off, bit_off;
> +
> +	status = readb(data->base + EXYNOS_TMU_REG_STATUS);
> +	if (!status) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
> +
> +	data->temp_error1 = trim_info & EXYNOS7_TMU_TEMP_MASK;
> +	if (!data->temp_error1 ||
> +	   (pdata->min_efuse_value > data->temp_error1) ||
> +	   (data->temp_error1 > pdata->max_efuse_value))
> +		data->temp_error1 = pdata->efuse_value &
> EXYNOS_TMU_TEMP_MASK; +
> +	/* Write temperature code for rising and falling threshold */
> +	for (i = (of_thermal_get_ntrips(tz) - 1); i >= 0; i--) {
> +		/*
> +		 * On exynos7 there are 4 rising and 4 falling
> threshold
> +		 * registers (0x50-0x5c and 0x60-0x6c respectively).
> Each
> +		 * register holds the value of two threshold levels
> (at bit
> +		 * offsets 0 and 16). Based on the fact that there
> are atmost
> +		 * eight possible trigger levels, calculate the
> register and
> +		 * bit offsets where the threshold levels are to be
> written.
> +		 *
> +		 * e.g. EXYNOS7_THD_TEMP_RISE7_6 (0x50)
> +		 * [24:16] - Threshold level 7
> +		 * [8:0] - Threshold level 6
> +		 * e.g. EXYNOS7_THD_TEMP_RISE5_4 (0x54)
> +		 * [24:16] - Threshold level 5
> +		 * [8:0] - Threshold level 4
> +		 *
> +		 * and similarly for falling thresholds.
> +		 *
> +		 * Based on the above, calculate the register and
> bit offsets
> +		 * for rising/falling threshold levels and populate
> them.
> +		 */
> +		reg_off = ((7 - i) / 2) * 4;
> +		bit_off = ((8 - i) % 2);
> +
> +		tz->ops->get_trip_temp(tz, i, &temp);
> +		temp /= MCELSIUS;
> +
> +		tz->ops->get_trip_hyst(tz, i, &temp_hist);
> +		temp_hist = temp - (temp_hist / MCELSIUS);
> +
> +		/* Set 9-bit temperature code for rising threshold
> levels */
> +		threshold_code = temp_to_code(data, temp);
> +		rising_threshold = readl(data->base +
> +			EXYNOS7_THD_TEMP_RISE7_6 + reg_off);
> +		rising_threshold &= ~(EXYNOS7_TMU_TEMP_MASK << (16 *
> bit_off));
> +		rising_threshold |= threshold_code << (16 * bit_off);
> +		writel(rising_threshold,
> +		       data->base + EXYNOS7_THD_TEMP_RISE7_6 +
> reg_off); +
> +		/* Set 9-bit temperature code for falling threshold
> levels */
> +		threshold_code = temp_to_code(data, temp_hist);
> +		falling_threshold &= ~(EXYNOS7_TMU_TEMP_MASK << (16
> * bit_off));
> +		falling_threshold |= threshold_code << (16 *
> bit_off);
> +		writel(falling_threshold,
> +		       data->base + EXYNOS7_THD_TEMP_FALL7_6 +
> reg_off);
> +	}
> +
> +	data->tmu_clear_irqs(data);
> +out:
> +	return ret;
> +}
> +
>  static void exynos4210_tmu_control(struct platform_device *pdev,
> bool on) {
>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> @@ -573,6 +672,46 @@ static void exynos5440_tmu_control(struct
> platform_device *pdev, bool on) writel(con, data->base +
> EXYNOS5440_TMU_S0_7_CTRL); }
>  
> +static void exynos7_tmu_control(struct platform_device *pdev, bool
> on) +{
> +	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> +	struct thermal_zone_device *tz = data->tzd;
> +	unsigned int con, interrupt_en;
> +
> +	con = get_con_reg(data, readl(data->base +
> EXYNOS_TMU_REG_CONTROL)); +
> +	if (on) {
> +		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
> +		interrupt_en =
> +			(of_thermal_is_trip_valid(tz, 7)
> +			<< EXYNOS7_TMU_INTEN_RISE7_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 6)
> +			<< EXYNOS7_TMU_INTEN_RISE6_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 5)
> +			<< EXYNOS7_TMU_INTEN_RISE5_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 4)
> +			<< EXYNOS7_TMU_INTEN_RISE4_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 3)
> +			<< EXYNOS7_TMU_INTEN_RISE3_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 2)
> +			<< EXYNOS7_TMU_INTEN_RISE2_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 1)
> +			<< EXYNOS7_TMU_INTEN_RISE1_SHIFT) |
> +			(of_thermal_is_trip_valid(tz, 0)
> +			<< EXYNOS7_TMU_INTEN_RISE0_SHIFT);
> +
> +		interrupt_en |=
> +			interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
> +	} else {
> +		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
> +		interrupt_en = 0; /* Disable all interrupts */
> +	}
> +	con |= 1 << EXYNOS7_PD_DET_EN_SHIFT;
> +
> +	writel(interrupt_en, data->base + EXYNOS7_TMU_REG_INTEN);
> +	writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
> +}
> +
>  static int exynos_get_temp(void *p, long *temp)
>  {
>  	struct exynos_tmu_data *data = p;
> @@ -602,9 +741,19 @@ static u32 get_emul_con_reg(struct
> exynos_tmu_data *data, unsigned int val, val &=
> ~(EXYNOS_EMUL_TIME_MASK << EXYNOS_EMUL_TIME_SHIFT); val |=
> (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT); }
> -		val &= ~(EXYNOS_EMUL_DATA_MASK <<
> EXYNOS_EMUL_DATA_SHIFT);
> -		val |= (temp_to_code(data, temp) <<
> EXYNOS_EMUL_DATA_SHIFT) |
> -			EXYNOS_EMUL_ENABLE;
> +		if (data->soc == SOC_ARCH_EXYNOS7) {
> +			val &= ~(EXYNOS7_EMUL_DATA_MASK <<
> +				EXYNOS7_EMUL_DATA_SHIFT);
> +			val |= (temp_to_code(data, temp) <<
> +				EXYNOS7_EMUL_DATA_SHIFT) |
> +				EXYNOS_EMUL_ENABLE;
> +		} else {
> +			val &= ~(EXYNOS_EMUL_DATA_MASK <<
> +				EXYNOS_EMUL_DATA_SHIFT);
> +			val |= (temp_to_code(data, temp) <<
> +				EXYNOS_EMUL_DATA_SHIFT) |
> +				EXYNOS_EMUL_ENABLE;
> +		}
>  	} else {
>  		val &= ~EXYNOS_EMUL_ENABLE;
>  	}
> @@ -620,6 +769,8 @@ static void exynos4412_tmu_set_emulation(struct
> exynos_tmu_data *data, 
>  	if (data->soc == SOC_ARCH_EXYNOS5260)
>  		emul_con = EXYNOS5260_EMUL_CON;
> +	else if (data->soc == SOC_ARCH_EXYNOS7)
> +		emul_con = EXYNOS7_TMU_REG_EMUL_CON;
>  	else
>  		emul_con = EXYNOS_EMUL_CON;
>  
> @@ -683,6 +834,12 @@ static int exynos5440_tmu_read(struct
> exynos_tmu_data *data) return readb(data->base +
> EXYNOS5440_TMU_S0_7_TEMP); }
>  
> +static int exynos7_tmu_read(struct exynos_tmu_data *data)
> +{
> +	return readw(data->base + EXYNOS_TMU_REG_CURRENT_TEMP) &
> +		EXYNOS7_TMU_TEMP_MASK;
> +}
> +
>  static void exynos_tmu_work(struct work_struct *work)
>  {
>  	struct exynos_tmu_data *data = container_of(work,
> @@ -721,6 +878,8 @@ static void exynos4210_tmu_clear_irqs(struct
> exynos_tmu_data *data) if (data->soc == SOC_ARCH_EXYNOS5260) {
>  		tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT;
>  		tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR;
> +	} else if (data->soc == SOC_ARCH_EXYNOS7) {
> +		tmu_intstat = tmu_intclear = EXYNOS7_TMU_REG_INTPEND;
>  	} else {
>  		tmu_intstat = EXYNOS_TMU_REG_INTSTAT;
>  		tmu_intclear = EXYNOS_TMU_REG_INTCLEAR;
> @@ -782,6 +941,9 @@ static const struct of_device_id
> exynos_tmu_match[] = { {
>  		.compatible = "samsung,exynos5440-tmu",
>  	},
> +	{
> +		.compatible = "samsung,exynos7-tmu",
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
> @@ -805,6 +967,8 @@ static int exynos_of_get_soc_type(struct
> device_node *np) return SOC_ARCH_EXYNOS5420_TRIMINFO;
>  	else if (of_device_is_compatible(np,
> "samsung,exynos5440-tmu")) return SOC_ARCH_EXYNOS5440;
> +	else if (of_device_is_compatible(np, "samsung,exynos7-tmu"))
> +		return SOC_ARCH_EXYNOS7;
>  
>  	return -EINVAL;
>  }
> @@ -928,6 +1092,13 @@ static int exynos_map_dt_data(struct
> platform_device *pdev) data->tmu_set_emulation =
> exynos5440_tmu_set_emulation; data->tmu_clear_irqs =
> exynos5440_tmu_clear_irqs; break;
> +	case SOC_ARCH_EXYNOS7:
> +		data->tmu_initialize = exynos7_tmu_initialize;
> +		data->tmu_control = exynos7_tmu_control;
> +		data->tmu_read = exynos7_tmu_read;
> +		data->tmu_set_emulation =
> exynos4412_tmu_set_emulation;
> +		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
> +		break;
>  	default:
>  		dev_err(&pdev->dev, "Platform not supported\n");
>  		return -EINVAL;
> @@ -1018,21 +1189,37 @@ static int exynos_tmu_probe(struct
> platform_device *pdev) goto err_clk_sec;
>  	}
>  
> +	if (data->soc == SOC_ARCH_EXYNOS7) {
> +		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
> +		if (IS_ERR(data->sclk)) {
> +			dev_err(&pdev->dev, "Failed to get sclk\n");
> +			goto err_clk;
> +		} else {
> +			ret = clk_prepare_enable(data->sclk);
> +			if (ret) {
> +				dev_err(&pdev->dev, "Failed to
> enable sclk\n");
> +				goto err_clk;
> +			}
> +		}
> +	}
> +
>  	ret = exynos_tmu_initialize(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to initialize TMU\n");
> -		goto err_clk;
> +		goto err_sclk;
>  	}
>  
>  	ret = devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
>  		IRQF_TRIGGER_RISING | IRQF_SHARED,
> dev_name(&pdev->dev), data); if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq: %d\n",
> data->irq);
> -		goto err_clk;
> +		goto err_sclk;
>  	}
>  
>  	exynos_tmu_control(pdev, true);
>  	return 0;
> +err_sclk:
> +	clk_disable_unprepare(data->sclk);
>  err_clk:
>  	clk_unprepare(data->clk);
>  err_clk_sec:
> @@ -1052,6 +1239,7 @@ static int exynos_tmu_remove(struct
> platform_device *pdev) thermal_zone_of_sensor_unregister(&pdev->dev,
> tzd); exynos_tmu_control(pdev, false);
>  
> +	clk_disable_unprepare(data->sclk);
>  	clk_unprepare(data->clk);
>  	if (!IS_ERR(data->clk_sec))
>  		clk_unprepare(data->clk_sec);
> diff --git a/drivers/thermal/samsung/exynos_tmu.h
> b/drivers/thermal/samsung/exynos_tmu.h index 9f9b1b8..4d71ec6 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -34,6 +34,7 @@ enum soc_type {
>  	SOC_ARCH_EXYNOS5420,
>  	SOC_ARCH_EXYNOS5420_TRIMINFO,
>  	SOC_ARCH_EXYNOS5440,
> +	SOC_ARCH_EXYNOS7,
>  };
>  
>  /**


Acked-by: Lukasz Majewski <l.majewski@samsung.com>
Tested-by: Lukasz Majewski <l.majewski@samsung.com>

Test HW: Odroid-U3 (Exynos4412)

linux-soc-thermal/fixes
SHA1: 252454f5cbda2c6b40c5d36f58cac2938437b85d

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
