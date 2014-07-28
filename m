Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaG1HC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:02:27 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55265 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaG1HCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:02:24 -0400
Date: Mon, 28 Jul 2014 08:02:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 RESEND] mfd: arizona: Rename thermal shutdown
 interrupt
Message-ID: <20140728070218.GG5273@lee--X1>
References: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1405419710-14789-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405419710-14789-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Charles Keepax wrote:

> Newer versions of the IP introduce short circuit protection which will
> also shutdown the speaker. Rename the interrupt and associated register
> bits associated with thermal events to better fit the function and avoid
> conflict with future interrupt additions.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |    8 ++--
>  drivers/mfd/wm5110-tables.c           |    8 ++--
>  drivers/mfd/wm8997-tables.c           |    8 ++--
>  include/linux/mfd/arizona/core.h      |    4 +-
>  include/linux/mfd/arizona/registers.h |   80 ++++++++++++++++----------------
>  sound/soc/codecs/arizona.c            |   10 ++--
>  6 files changed, 59 insertions(+), 59 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index c8a993b..fb4d4bb 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -138,11 +138,11 @@ static const struct regmap_irq wm5102_irqs[ARIZONA_NUM_IRQ] = {
>  		.reg_offset = 1, .mask = ARIZONA_DSP_IRQ1_EINT1
>  	},
>  
> -	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
>  	},
> -	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
>  	},
>  	[ARIZONA_IRQ_HPDET] = {
>  		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index 4729007..2822768 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -340,11 +340,11 @@ static const struct regmap_irq wm5110_irqs[ARIZONA_NUM_IRQ] = {
>  		.reg_offset = 1, .mask = ARIZONA_DSP_IRQ1_EINT1
>  	},
>  
> -	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
>  	},
> -	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
>  	},
>  	[ARIZONA_IRQ_HPDET] = {
>  		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
> diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
> index c7a81da..d641474 100644
> --- a/drivers/mfd/wm8997-tables.c
> +++ b/drivers/mfd/wm8997-tables.c
> @@ -65,11 +65,11 @@ static const struct regmap_irq wm8997_irqs[ARIZONA_NUM_IRQ] = {
>  	[ARIZONA_IRQ_GP2] = { .reg_offset = 0, .mask = ARIZONA_GP2_EINT1 },
>  	[ARIZONA_IRQ_GP1] = { .reg_offset = 0, .mask = ARIZONA_GP1_EINT1 },
>  
> -	[ARIZONA_IRQ_SPK_SHUTDOWN_WARN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_WARN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT_WARN] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_WARN_EINT1
>  	},
> -	[ARIZONA_IRQ_SPK_SHUTDOWN] = {
> -		.reg_offset = 2, .mask = ARIZONA_SPK_SHUTDOWN_EINT1
> +	[ARIZONA_IRQ_SPK_OVERHEAT] = {
> +		.reg_offset = 2, .mask = ARIZONA_SPK_OVERHEAT_EINT1
>  	},
>  	[ARIZONA_IRQ_HPDET] = {
>  		.reg_offset = 2, .mask = ARIZONA_HPDET_EINT1
> diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
> index 6a62fc9..819edf5 100644
> --- a/include/linux/mfd/arizona/core.h
> +++ b/include/linux/mfd/arizona/core.h
> @@ -46,8 +46,8 @@ enum arizona_type {
>  #define ARIZONA_IRQ_DSP_IRQ6              17
>  #define ARIZONA_IRQ_DSP_IRQ7              18
>  #define ARIZONA_IRQ_DSP_IRQ8              19
> -#define ARIZONA_IRQ_SPK_SHUTDOWN_WARN     20
> -#define ARIZONA_IRQ_SPK_SHUTDOWN          21
> +#define ARIZONA_IRQ_SPK_OVERHEAT_WARN     20
> +#define ARIZONA_IRQ_SPK_OVERHEAT          21
>  #define ARIZONA_IRQ_MICDET                22
>  #define ARIZONA_IRQ_HPDET                 23
>  #define ARIZONA_IRQ_WSEQ_DONE             24
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index df93563..f7d6f9e 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -4691,14 +4691,14 @@
>  /*
>   * R3330 (0xD02) - Interrupt Status 3
>   */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1          0x8000  /* SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_MASK     0x8000  /* SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_SHIFT        15  /* SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT1_WIDTH         1  /* SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT1               0x4000  /* SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT1_MASK          0x4000  /* SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT1_SHIFT             14  /* SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT1_WIDTH              1  /* SPK_SHUTDOWN_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT1          0x8000  /* SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_MASK     0x8000  /* SPK_OVERHEAD_WARN_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_SHIFT        15  /* SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT1_WIDTH         1  /* SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_EINT1               0x4000  /* SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_EINT1_MASK          0x4000  /* SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_EINT1_SHIFT             14  /* SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_SPK_OVERHEAT_EINT1_WIDTH              1  /* SPK_OVERHEAT_EINT1 */
>  #define ARIZONA_HPDET_EINT1                      0x2000  /* HPDET_EINT1 */
>  #define ARIZONA_HPDET_EINT1_MASK                 0x2000  /* HPDET_EINT1 */
>  #define ARIZONA_HPDET_EINT1_SHIFT                    13  /* HPDET_EINT1 */
> @@ -4883,14 +4883,14 @@
>  /*
>   * R3338 (0xD0A) - Interrupt Status 3 Mask
>   */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1       0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_MASK  0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_SHIFT     15  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT1_WIDTH      1  /* IM_SPK_SHUTDOWN_WARN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT1            0x4000  /* IM_SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_MASK       0x4000  /* IM_SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_SHIFT          14  /* IM_SPK_SHUTDOWN_EINT1 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT1_WIDTH           1  /* IM_SPK_SHUTDOWN_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1       0x8000  /* IM_SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_MASK  0x8000  /* IM_SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_SHIFT     15  /* IM_SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT1_WIDTH      1  /* IM_SPK_OVERHEAT_WARN_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT1            0x4000  /* IM_SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT1_MASK       0x4000  /* IM_SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT1_SHIFT          14  /* IM_SPK_OVERHEAT_EINT1 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT1_WIDTH           1  /* IM_SPK_OVERHEAT_EINT1 */
>  #define ARIZONA_IM_HPDET_EINT1                   0x2000  /* IM_HPDET_EINT1 */
>  #define ARIZONA_IM_HPDET_EINT1_MASK              0x2000  /* IM_HPDET_EINT1 */
>  #define ARIZONA_IM_HPDET_EINT1_SHIFT                 13  /* IM_HPDET_EINT1 */
> @@ -5083,14 +5083,14 @@
>  /*
>   * R3346 (0xD12) - IRQ2 Status 3
>   */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2          0x8000  /* SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_MASK     0x8000  /* SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_SHIFT        15  /* SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_EINT2_WIDTH         1  /* SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT2               0x4000  /* SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT2_MASK          0x4000  /* SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT2_SHIFT             14  /* SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_SPK_SHUTDOWN_EINT2_WIDTH              1  /* SPK_SHUTDOWN_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT2          0x8000  /* SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_MASK     0x8000  /* SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_SHIFT        15  /* SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_WARN_EINT2_WIDTH         1  /* SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_EINT2               0x4000  /* SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_EINT2_MASK          0x4000  /* SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_EINT2_SHIFT             14  /* SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_SPK_OVERHEAT_EINT2_WIDTH              1  /* SPK_OVERHEAT_EINT2 */
>  #define ARIZONA_HPDET_EINT2                      0x2000  /* HPDET_EINT2 */
>  #define ARIZONA_HPDET_EINT2_MASK                 0x2000  /* HPDET_EINT2 */
>  #define ARIZONA_HPDET_EINT2_SHIFT                    13  /* HPDET_EINT2 */
> @@ -5275,14 +5275,14 @@
>  /*
>   * R3354 (0xD1A) - IRQ2 Status 3 Mask
>   */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2       0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_MASK  0x8000  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_SHIFT     15  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_WARN_EINT2_WIDTH      1  /* IM_SPK_SHUTDOWN_WARN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT2            0x4000  /* IM_SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_MASK       0x4000  /* IM_SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_SHIFT          14  /* IM_SPK_SHUTDOWN_EINT2 */
> -#define ARIZONA_IM_SPK_SHUTDOWN_EINT2_WIDTH           1  /* IM_SPK_SHUTDOWN_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2       0x8000  /* IM_SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_MASK  0x8000  /* IM_SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_SHIFT     15  /* IM_SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_WARN_EINT2_WIDTH      1  /* IM_SPK_OVERHEAT_WARN_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT2            0x4000  /* IM_SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT2_MASK       0x4000  /* IM_SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT2_SHIFT          14  /* IM_SPK_OVERHEAT_EINT2 */
> +#define ARIZONA_IM_SPK_OVERHEAT_EINT2_WIDTH           1  /* IM_SPK_OVERHEAT_EINT2 */
>  #define ARIZONA_IM_HPDET_EINT2                   0x2000  /* IM_HPDET_EINT2 */
>  #define ARIZONA_IM_HPDET_EINT2_MASK              0x2000  /* IM_HPDET_EINT2 */
>  #define ARIZONA_IM_HPDET_EINT2_SHIFT                 13  /* IM_HPDET_EINT2 */
> @@ -5456,14 +5456,14 @@
>  /*
>   * R3361 (0xD21) - Interrupt Raw Status 3
>   */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_STS            0x8000  /* SPK_SHUTDOWN_WARN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_STS_MASK       0x8000  /* SPK_SHUTDOWN_WARN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_STS_SHIFT          15  /* SPK_SHUTDOWN_WARN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_WARN_STS_WIDTH           1  /* SPK_SHUTDOWN_WARN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_STS                 0x4000  /* SPK_SHUTDOWN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_STS_MASK            0x4000  /* SPK_SHUTDOWN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_STS_SHIFT               14  /* SPK_SHUTDOWN_STS */
> -#define ARIZONA_SPK_SHUTDOWN_STS_WIDTH                1  /* SPK_SHUTDOWN_STS */
> +#define ARIZONA_SPK_OVERHEAT_WARN_STS            0x8000  /* SPK_OVERHEAT_WARN_STS */
> +#define ARIZONA_SPK_OVERHEAT_WARN_STS_MASK       0x8000  /* SPK_OVERHEAT_WARN_STS */
> +#define ARIZONA_SPK_OVERHEAT_WARN_STS_SHIFT          15  /* SPK_OVERHEAT_WARN_STS */
> +#define ARIZONA_SPK_OVERHEAT_WARN_STS_WIDTH           1  /* SPK_OVERHEAT_WARN_STS */
> +#define ARIZONA_SPK_OVERHEAT_STS                 0x4000  /* SPK_OVERHEAT_STS */
> +#define ARIZONA_SPK_OVERHEAT_STS_MASK            0x4000  /* SPK_OVERHEAT_STS */
> +#define ARIZONA_SPK_OVERHEAT_STS_SHIFT               14  /* SPK_OVERHEAT_STS */
> +#define ARIZONA_SPK_OVERHEAT_STS_WIDTH                1  /* SPK_OVERHEAT_STS */
>  #define ARIZONA_HPDET_STS                        0x2000  /* HPDET_STS */
>  #define ARIZONA_HPDET_STS_MASK                   0x2000  /* HPDET_STS */
>  #define ARIZONA_HPDET_STS_SHIFT                      13  /* HPDET_STS */
> diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
> index 29e198f..1b14105 100644
> --- a/sound/soc/codecs/arizona.c
> +++ b/sound/soc/codecs/arizona.c
> @@ -107,7 +107,7 @@ static int arizona_spk_ev(struct snd_soc_dapm_widget *w,
>  		break;
>  	case SND_SOC_DAPM_POST_PMU:
>  		val = snd_soc_read(codec, ARIZONA_INTERRUPT_RAW_STATUS_3);
> -		if (val & ARIZONA_SPK_SHUTDOWN_STS) {
> +		if (val & ARIZONA_SPK_OVERHEAT_STS) {
>  			dev_crit(arizona->dev,
>  				 "Speaker not enabled due to temperature\n");
>  			return -EBUSY;
> @@ -159,7 +159,7 @@ static irqreturn_t arizona_thermal_warn(int irq, void *data)
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to read thermal status: %d\n",
>  			ret);
> -	} else if (val & ARIZONA_SPK_SHUTDOWN_WARN_STS) {
> +	} else if (val & ARIZONA_SPK_OVERHEAT_WARN_STS) {
>  		dev_crit(arizona->dev, "Thermal warning\n");
>  	}
>  
> @@ -177,7 +177,7 @@ static irqreturn_t arizona_thermal_shutdown(int irq, void *data)
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to read thermal status: %d\n",
>  			ret);
> -	} else if (val & ARIZONA_SPK_SHUTDOWN_STS) {
> +	} else if (val & ARIZONA_SPK_OVERHEAT_STS) {
>  		dev_crit(arizona->dev, "Thermal shutdown\n");
>  		ret = regmap_update_bits(arizona->regmap,
>  					 ARIZONA_OUTPUT_ENABLES_1,
> @@ -223,7 +223,7 @@ int arizona_init_spk(struct snd_soc_codec *codec)
>  		break;
>  	}
>  
> -	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_SHUTDOWN_WARN,
> +	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_OVERHEAT_WARN,
>  				  "Thermal warning", arizona_thermal_warn,
>  				  arizona);
>  	if (ret != 0)
> @@ -231,7 +231,7 @@ int arizona_init_spk(struct snd_soc_codec *codec)
>  			"Failed to get thermal warning IRQ: %d\n",
>  			ret);
>  
> -	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_SHUTDOWN,
> +	ret = arizona_request_irq(arizona, ARIZONA_IRQ_SPK_OVERHEAT,
>  				  "Thermal shutdown", arizona_thermal_shutdown,
>  				  arizona);
>  	if (ret != 0)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
