Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaJTMr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:47:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20525 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaJTMrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:47:23 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-b8-544504580a17
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] thermal: exynos: fix IRQ clearing on TMU initialization
Date: Mon, 20 Oct 2014 14:46:46 +0200
Message-id: <10553368.74zsSH4p9d@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1489241.Qb16XOmjOZ@amdc1032>
References: <1489241.Qb16XOmjOZ@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jAd1IFtcQg6PrWC0aroZYzL9yjdXi
	bNMbdos3DzczWlzeNYfN4nPvEUaLGef3MVk8edjH5sDhsXPWXXaPxXteMnn0bVnF6PF5k1wA
	SxSXTUpqTmZZapG+XQJXxvl9NQXroiv+r7rK2MD40qeLkZNDQsBEYsH2h8wQtpjEhXvr2boY
	uTiEBBYxSkyd9IIdwmlhkvh3vIkVpIpNwEpiYvsqRhBbREBL4sSl7UwgRcwCXUwSr9cdB0pw
	cAgL+Ej8eWgOUsMioCpxe/10dhCbF6j+ae96sF5RAU+JHdtXsoHYnEDxQys/gcWFBDQlLh38
	yAxRLyjxY/I9FhCbWUBeYt/+qawQtpbE+p3HmSYwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgSH+DPpHYyrGiwOMQpwMCrx8O4wcwkRYk0sK67MPcQowcGsJMLr
	8h8oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgdHmiPlp
	iZvK+54XCN9aUvSv2Kj/t2ji4cNLNq5ev3LBWdsnoRf9VL+GXXg7j21BUHDOm8k3UgsOKXcc
	lZ8+3y1i4t5ZxQrWU+7M/lIZFx60ffkn72mP/YWZOR6lrp+8+LzdKoN6CbPcZ5rXUuZrJh80
	/MtfGzPHnv/0rzWLBdi3/nQ5sKCf+UWgEktxRqKhFnNRcSIA8Qlu+W0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Eduaro, could you please merge this patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Friday, October 03, 2014 06:17:17 PM Bartlomiej Zolnierkiewicz wrote:
> * Factor out code for clearing raised IRQs from exynos_tmu_work() to
>   exynos_tmu_clear_irqs().
> 
> * Add a comment about documentation bugs to exynos_tmu_clear_irqs().
> 
>   [ The documentation for Exynos3250, Exynos4412, Exynos5250 and
>     Exynos5260 incorrectly states that INTCLEAR register has
>     a different placing of bits responsible for FALL IRQs than
>     INTSTAT register.  Exynos5420 and Exynos5440 documentation is
>     correct (Exynos4210 doesn't support FALL IRQs at all). ]
> 
> * Use exynos_tmu_clear_irqs() in exynos_tmu_initialize() instead
>   of open-coded code trying to clear IRQs according to predefined
>   masks.  After this change exynos_tmu_initialize() just clears
>   IRQs that are raised like it is already done in exynos_tmu_work().
> 
>   As a nice side-effect the code now uses the correct offset
>   (16 instead of 12) for bits responsible for clearing FALL IRQs
>   in INTCLEAR register on Exynos3250, Exynos4412 and Exynos5250.
> 
> * Remove no longer needed intclr_rise_[mask,shift] and
>   intclr_fall_[mask,shift] fields from struct exynos_tmu_registers.
> 
> * Remove no longer needed defines.
> 
> This patch has been tested on Exynos4412 and Exynos5420 SoCs.
> 
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Lukasz Majewski <l.majewski@samsung.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      | 29 +++++++++++++++++++++--------
>  drivers/thermal/samsung/exynos_tmu.h      |  8 --------
>  drivers/thermal/samsung/exynos_tmu_data.c | 21 ---------------------
>  drivers/thermal/samsung/exynos_tmu_data.h | 15 ---------------
>  4 files changed, 21 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 092ab69..49c0924 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -122,6 +122,23 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
>  	return temp;
>  }
>  
> +static void exynos_tmu_clear_irqs(struct exynos_tmu_data *data)
> +{
> +	const struct exynos_tmu_registers *reg = data->pdata->registers;
> +	unsigned int val_irq;
> +
> +	val_irq = readl(data->base + reg->tmu_intstat);
> +	/*
> +	 * Clear the interrupts.  Please note that the documentation for
> +	 * Exynos3250, Exynos4412, Exynos5250 and Exynos5260 incorrectly
> +	 * states that INTCLEAR register has a different placing of bits
> +	 * responsible for FALL IRQs than INTSTAT register.  Exynos5420
> +	 * and Exynos5440 documentation is correct (Exynos4210 doesn't
> +	 * support FALL IRQs at all).
> +	 */
> +	writel(val_irq, data->base + reg->tmu_intclear);
> +}
> +
>  static int exynos_tmu_initialize(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
> @@ -207,7 +224,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  			writeb(pdata->trigger_levels[i], data->base +
>  			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
>  
> -		writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
> +		exynos_tmu_clear_irqs(data);
>  	} else {
>  		/* Write temperature code for rising and falling threshold */
>  		for (i = 0; i < pdata->non_hw_trigger_levels; i++) {
> @@ -228,9 +245,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  		writel(falling_threshold,
>  				data->base + reg->threshold_th1);
>  
> -		writel((reg->intclr_rise_mask << reg->intclr_rise_shift) |
> -			(reg->intclr_fall_mask << reg->intclr_fall_shift),
> -				data->base + reg->tmu_intclear);
> +		exynos_tmu_clear_irqs(data);
>  
>  		/* if last threshold limit is also present */
>  		i = pdata->max_trigger_level - 1;
> @@ -396,7 +411,7 @@ static void exynos_tmu_work(struct work_struct *work)
>  			struct exynos_tmu_data, irq_work);
>  	struct exynos_tmu_platform_data *pdata = data->pdata;
>  	const struct exynos_tmu_registers *reg = pdata->registers;
> -	unsigned int val_irq, val_type;
> +	unsigned int val_type;
>  
>  	if (!IS_ERR(data->clk_sec))
>  		clk_enable(data->clk_sec);
> @@ -414,9 +429,7 @@ static void exynos_tmu_work(struct work_struct *work)
>  	clk_enable(data->clk);
>  
>  	/* TODO: take action based on particular interrupt */
> -	val_irq = readl(data->base + reg->tmu_intstat);
> -	/* clear the interrupts */
> -	writel(val_irq, data->base + reg->tmu_intclear);
> +	exynos_tmu_clear_irqs(data);
>  
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index f67203b..c58c766 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -100,10 +100,6 @@ enum soc_type {
>   * @inten_fall0_shift: shift bits of falling 0 interrupt bits.
>   * @tmu_intstat: Register containing the interrupt status values.
>   * @tmu_intclear: Register for clearing the raised interrupt status.
> - * @intclr_fall_shift: shift bits for interrupt clear fall 0
> - * @intclr_rise_shift: shift bits of all rising interrupt bits.
> - * @intclr_rise_mask: mask bits of all rising interrupt bits.
> - * @intclr_fall_mask: mask bits of all rising interrupt bits.
>   * @emul_con: TMU emulation controller register.
>   * @emul_temp_shift: shift bits of emulation temperature.
>   * @emul_time_shift: shift bits of emulation time.
> @@ -143,10 +139,6 @@ struct exynos_tmu_registers {
>  	u32	tmu_intstat;
>  
>  	u32	tmu_intclear;
> -	u32	intclr_fall_shift;
> -	u32	intclr_rise_shift;
> -	u32	intclr_fall_mask;
> -	u32	intclr_rise_mask;
>  
>  	u32	emul_con;
>  	u32	emul_temp_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index 8bae170..2683d28 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -39,7 +39,6 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
>  	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> -	.intclr_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
>  };
>  
>  struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
> @@ -106,10 +105,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> -	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
> -	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> -	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> -	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -193,10 +188,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> -	.intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
> -	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> -	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> -	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -289,10 +280,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR,
> -	.intclr_fall_shift = EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT,
> -	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> -	.intclr_rise_mask = EXYNOS5260_TMU_RISE_INT_MASK,
> -	.intclr_fall_mask = EXYNOS5260_TMU_FALL_INT_MASK,
>  	.emul_con = EXYNOS5260_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -373,10 +360,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> -	.intclr_fall_shift = EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT,
> -	.intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> -	.intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> -	.intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
>  	.emul_con = EXYNOS_EMUL_CON,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>  	.emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> @@ -465,10 +448,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>  	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>  	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>  	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> -	.intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
> -	.intclr_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
> -	.intclr_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
> -	.intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
>  	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>  	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>  	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> index 4b8f33c..65e2ea6 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -46,8 +46,6 @@
>  #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
>  #define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
>  
> -#define EXYNOS4210_TMU_TRIG_LEVEL_MASK	0x1111
> -
>  /* Exynos5250, Exynos4412, Exynos3250 specific registers */
>  #define EXYNOS_TMU_TRIMINFO_CON2	0x14
>  #define EXYNOS_THD_TEMP_RISE		0x50
> @@ -57,12 +55,6 @@
>  #define EXYNOS_TRIMINFO_RELOAD_ENABLE	1
>  #define EXYNOS_TRIMINFO_25_SHIFT	0
>  #define EXYNOS_TRIMINFO_85_SHIFT	8
> -#define EXYNOS_TMU_RISE_INT_MASK	0x111
> -#define EXYNOS_TMU_RISE_INT_SHIFT	0
> -#define EXYNOS_TMU_FALL_INT_MASK	0x111
> -#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
> -#define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT	16
> -#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT	4
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> @@ -87,10 +79,6 @@
>  #define EXYNOS5260_TMU_REG_INTEN		0xC0
>  #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
>  #define EXYNOS5260_TMU_REG_INTCLEAR		0xC8
> -#define EXYNOS5260_TMU_CLEAR_RISE_INT		0x1111
> -#define EXYNOS5260_TMU_CLEAR_FALL_INT		(0x1111 << 16)
> -#define EXYNOS5260_TMU_RISE_INT_MASK		0x1111
> -#define EXYNOS5260_TMU_FALL_INT_MASK		0x1111
>  #define EXYNOS5260_EMUL_CON			0x100
>  
>  /* Exynos4412 specific */
> @@ -112,9 +100,6 @@
>  #define EXYNOS5440_TMU_IRQ_STATUS		0x000
>  #define EXYNOS5440_TMU_PMIN			0x004
>  
> -#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
> -#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
> -#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
>  #define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
>  #define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
>  #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2

