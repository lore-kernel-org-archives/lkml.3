Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaIAPVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:21:22 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64209 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaIAPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:21:21 -0400
Date: Mon, 1 Sep 2014 16:21:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Add ASYNC_SAMPLE_RATE_2 registers
Message-ID: <20140901152115.GG8796@lee--X1>
References: <1409582932-4512-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409582932-4512-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Charles Keepax wrote:

> Some arizona devices have a second asynchronous sample rate, add the
> registers necessary to support this.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |    3 +++
>  drivers/mfd/wm5110-tables.c           |    4 ++++
>  include/linux/mfd/arizona/registers.h |   28 ++++++++++++++++++++++------
>  sound/soc/codecs/arizona.c            |    2 +-
>  4 files changed, 30 insertions(+), 7 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index 6d9b7f8..d6f35bb 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -1059,6 +1059,8 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_ASYNC_CLOCK_1:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS:
>  	case ARIZONA_OUTPUT_SYSTEM_CLOCK:
>  	case ARIZONA_OUTPUT_ASYNC_CLOCK:
>  	case ARIZONA_RATE_ESTIMATOR_1:
> @@ -1892,6 +1894,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_SAMPLE_RATE_3_STATUS:
>  	case ARIZONA_HAPTICS_STATUS:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS:
>  	case ARIZONA_FLL1_NCO_TEST_0:
>  	case ARIZONA_FLL2_NCO_TEST_0:
>  	case ARIZONA_DAC_COMP_1:
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index beae0a3..4642b5b 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -702,6 +702,7 @@ static const struct reg_default wm5110_reg_default[] = {
>  	{ 0x00000104, 0x0011 },    /* R260   - Sample rate 3 */
>  	{ 0x00000112, 0x0305 },    /* R274   - Async clock 1 */
>  	{ 0x00000113, 0x0011 },    /* R275   - Async sample rate 1 */
> +	{ 0x00000114, 0x0011 },    /* R276   - Async sample rate 2 */
>  	{ 0x00000149, 0x0000 },    /* R329   - Output system clock */
>  	{ 0x0000014A, 0x0000 },    /* R330   - Output async clock */
>  	{ 0x00000152, 0x0000 },    /* R338   - Rate Estimator 1 */
> @@ -1738,6 +1739,8 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_ASYNC_CLOCK_1:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS:
>  	case ARIZONA_OUTPUT_SYSTEM_CLOCK:
>  	case ARIZONA_OUTPUT_ASYNC_CLOCK:
>  	case ARIZONA_RATE_ESTIMATOR_1:
> @@ -2820,6 +2823,7 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_SAMPLE_RATE_2_STATUS:
>  	case ARIZONA_SAMPLE_RATE_3_STATUS:
>  	case ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS:
> +	case ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS:
>  	case ARIZONA_MIC_DETECT_3:
>  	case ARIZONA_HEADPHONE_DETECT_2:
>  	case ARIZONA_INPUT_ENABLES_STATUS:
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index 68913ec..c0b075f 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -71,7 +71,9 @@
>  #define ARIZONA_SAMPLE_RATE_3_STATUS             0x10C
>  #define ARIZONA_ASYNC_CLOCK_1                    0x112
>  #define ARIZONA_ASYNC_SAMPLE_RATE_1              0x113
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2              0x114
>  #define ARIZONA_ASYNC_SAMPLE_RATE_1_STATUS       0x11B
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_STATUS       0x11C
>  #define ARIZONA_OUTPUT_SYSTEM_CLOCK              0x149
>  #define ARIZONA_OUTPUT_ASYNC_CLOCK               0x14A
>  #define ARIZONA_RATE_ESTIMATOR_1                 0x152
> @@ -1665,16 +1667,30 @@
>  /*
>   * R275 (0x113) - Async sample rate 1
>   */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_MASK           0x001F  /* ASYNC_SAMPLE_RATE - [4:0] */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_SHIFT               0  /* ASYNC_SAMPLE_RATE - [4:0] */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_WIDTH               5  /* ASYNC_SAMPLE_RATE - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_MASK         0x001F  /* ASYNC_SAMPLE_RATE_1 - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_SHIFT             0  /* ASYNC_SAMPLE_RATE_1 - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_WIDTH             5  /* ASYNC_SAMPLE_RATE_1 - [4:0] */
> +
> +/*
> + * R276 (0x114) - Async sample rate 2
> + */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_MASK         0x001F  /* ASYNC_SAMPLE_RATE_2 - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_SHIFT             0  /* ASYNC_SAMPLE_RATE_2 - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_WIDTH             5  /* ASYNC_SAMPLE_RATE_2 - [4:0] */
>  
>  /*
>   * R283 (0x11B) - Async sample rate 1 status
>   */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_STS_MASK       0x001F  /* ASYNC_SAMPLE_RATE_STS - [4:0] */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_STS_SHIFT           0  /* ASYNC_SAMPLE_RATE_STS - [4:0] */
> -#define ARIZONA_ASYNC_SAMPLE_RATE_STS_WIDTH           5  /* ASYNC_SAMPLE_RATE_STS - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_STS_MASK     0x001F  /* ASYNC_SAMPLE_RATE_1_STS - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_STS_SHIFT         0  /* ASYNC_SAMPLE_RATE_1_STS - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_1_STS_WIDTH         5  /* ASYNC_SAMPLE_RATE_1_STS - [4:0] */
> +
> +/*
> + * R284 (0x11C) - Async sample rate 2 status
> + */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_STS_MASK     0x001F  /* ASYNC_SAMPLE_RATE_2_STS - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_STS_SHIFT         0  /* ASYNC_SAMPLE_RATE_2_STS - [4:0] */
> +#define ARIZONA_ASYNC_SAMPLE_RATE_2_STS_WIDTH         5  /* ASYNC_SAMPLE_RATE_2_STS - [4:0] */
>  
>  /*
>   * R329 (0x149) - Output system clock
> diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
> index 2c71f16..0c05e7a 100644
> --- a/sound/soc/codecs/arizona.c
> +++ b/sound/soc/codecs/arizona.c
> @@ -1220,7 +1220,7 @@ static int arizona_hw_params_rate(struct snd_pcm_substream *substream,
>  		break;
>  	case ARIZONA_CLK_ASYNCCLK:
>  		snd_soc_update_bits(codec, ARIZONA_ASYNC_SAMPLE_RATE_1,
> -				    ARIZONA_ASYNC_SAMPLE_RATE_MASK, sr_val);
> +				    ARIZONA_ASYNC_SAMPLE_RATE_1_MASK, sr_val);
>  		if (base)
>  			snd_soc_update_bits(codec, base + ARIZONA_AIF_RATE_CTRL,
>  					    ARIZONA_AIF1_RATE_MASK,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
