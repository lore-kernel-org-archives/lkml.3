Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaG1HCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:02:11 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40004 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1HCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:02:07 -0400
Date: Mon, 28 Jul 2014 08:02:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6 RESEND] mfd: wm5110: Add in the output done interrupts
Message-ID: <20140728070202.GF5273@lee--X1>
References: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1405419710-14789-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405419710-14789-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Charles Keepax wrote:

> wm5110 has interrupts to signal that an output has fully enabled. This
> patch adds in these interrupts although use is not made of them yet.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c           |   18 +++++
>  include/linux/mfd/arizona/core.h      |    8 ++-
>  include/linux/mfd/arizona/registers.h |  120 +++++++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index b26be6e..4729007 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -416,6 +416,24 @@ static const struct regmap_irq wm5110_irqs[ARIZONA_NUM_IRQ] = {
>  	[ARIZONA_IRQ_ISRC2_CFG_ERR] = {
>  		.reg_offset = 3, .mask = ARIZONA_ISRC2_CFG_ERR_EINT1
>  	},
> +	[ARIZONA_IRQ_HP3R_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP3R_DONE_EINT1
> +	},
> +	[ARIZONA_IRQ_HP3L_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP3L_DONE_EINT1
> +	},
> +	[ARIZONA_IRQ_HP2R_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP2R_DONE_EINT1
> +	},
> +	[ARIZONA_IRQ_HP2L_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP2L_DONE_EINT1
> +	},
> +	[ARIZONA_IRQ_HP1R_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP1R_DONE_EINT1
> +	},
> +	[ARIZONA_IRQ_HP1L_DONE] = {
> +		.reg_offset = 3, .mask = ARIZONA_HP1L_DONE_EINT1
> +	},
>  
>  	[ARIZONA_IRQ_BOOT_DONE] = {
>  		.reg_offset = 4, .mask = ARIZONA_BOOT_DONE_EINT1
> diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
> index 70854d8..6a62fc9 100644
> --- a/include/linux/mfd/arizona/core.h
> +++ b/include/linux/mfd/arizona/core.h
> @@ -78,8 +78,14 @@ enum arizona_type {
>  #define ARIZONA_IRQ_FLL1_CLOCK_OK         49
>  #define ARIZONA_IRQ_MICD_CLAMP_RISE	  50
>  #define ARIZONA_IRQ_MICD_CLAMP_FALL	  51
> -
> -#define ARIZONA_NUM_IRQ                   52
> +#define ARIZONA_IRQ_HP3R_DONE             52
> +#define ARIZONA_IRQ_HP3L_DONE             53
> +#define ARIZONA_IRQ_HP2R_DONE             54
> +#define ARIZONA_IRQ_HP2L_DONE             55
> +#define ARIZONA_IRQ_HP1R_DONE             56
> +#define ARIZONA_IRQ_HP1L_DONE             57
> +
> +#define ARIZONA_NUM_IRQ                   58
>  
>  struct snd_soc_dapm_context;
>  
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index 7204d81..df93563 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -4795,6 +4795,30 @@
>  #define ARIZONA_ISRC2_CFG_ERR_EINT1_MASK         0x0040  /* ISRC2_CFG_ERR_EINT1 */
>  #define ARIZONA_ISRC2_CFG_ERR_EINT1_SHIFT             6  /* ISRC2_CFG_ERR_EINT1 */
>  #define ARIZONA_ISRC2_CFG_ERR_EINT1_WIDTH             1  /* ISRC2_CFG_ERR_EINT1 */
> +#define ARIZONA_HP3R_DONE_EINT1                  0x0020  /* HP3R_DONE_EINT1 */
> +#define ARIZONA_HP3R_DONE_EINT1_MASK             0x0020  /* HP3R_DONE_EINT1 */
> +#define ARIZONA_HP3R_DONE_EINT1_SHIFT                 5  /* HP3R_DONE_EINT1 */
> +#define ARIZONA_HP3R_DONE_EINT1_WIDTH                 1  /* HP3R_DONE_EINT1 */
> +#define ARIZONA_HP3L_DONE_EINT1                  0x0010  /* HP3L_DONE_EINT1 */
> +#define ARIZONA_HP3L_DONE_EINT1_MASK             0x0010  /* HP3L_DONE_EINT1 */
> +#define ARIZONA_HP3L_DONE_EINT1_SHIFT                 4  /* HP3L_DONE_EINT1 */
> +#define ARIZONA_HP3L_DONE_EINT1_WIDTH                 1  /* HP3L_DONE_EINT1 */
> +#define ARIZONA_HP2R_DONE_EINT1                  0x0008  /* HP2R_DONE_EINT1 */
> +#define ARIZONA_HP2R_DONE_EINT1_MASK             0x0008  /* HP2R_DONE_EINT1 */
> +#define ARIZONA_HP2R_DONE_EINT1_SHIFT                 3  /* HP2R_DONE_EINT1 */
> +#define ARIZONA_HP2R_DONE_EINT1_WIDTH                 1  /* HP2R_DONE_EINT1 */
> +#define ARIZONA_HP2L_DONE_EINT1                  0x0004  /* HP2L_DONE_EINT1 */
> +#define ARIZONA_HP2L_DONE_EINT1_MASK             0x0004  /* HP2L_DONE_EINT1 */
> +#define ARIZONA_HP2L_DONE_EINT1_SHIFT                 2  /* HP2L_DONE_EINT1 */
> +#define ARIZONA_HP2L_DONE_EINT1_WIDTH                 1  /* HP2L_DONE_EINT1 */
> +#define ARIZONA_HP1R_DONE_EINT1                  0x0002  /* HP1R_DONE_EINT1 */
> +#define ARIZONA_HP1R_DONE_EINT1_MASK             0x0002  /* HP1R_DONE_EINT1 */
> +#define ARIZONA_HP1R_DONE_EINT1_SHIFT                 1  /* HP1R_DONE_EINT1 */
> +#define ARIZONA_HP1R_DONE_EINT1_WIDTH                 1  /* HP1R_DONE_EINT1 */
> +#define ARIZONA_HP1L_DONE_EINT1                  0x0001  /* HP1L_DONE_EINT1 */
> +#define ARIZONA_HP1L_DONE_EINT1_MASK             0x0001  /* HP1L_DONE_EINT1 */
> +#define ARIZONA_HP1L_DONE_EINT1_SHIFT                 0  /* HP1L_DONE_EINT1 */
> +#define ARIZONA_HP1L_DONE_EINT1_WIDTH                 1  /* HP1L_DONE_EINT1 */
>  
>  /*
>   * R3332 (0xD04) - Interrupt Status 5
> @@ -4963,6 +4987,30 @@
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT1_MASK      0x0040  /* IM_ISRC2_CFG_ERR_EINT1 */
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT1_SHIFT          6  /* IM_ISRC2_CFG_ERR_EINT1 */
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT1_WIDTH          1  /* IM_ISRC2_CFG_ERR_EINT1 */
> +#define ARIZONA_IM_HP3R_DONE_EINT1               0x0020  /* IM_HP3R_DONE_EINT1 */
> +#define ARIZONA_IM_HP3R_DONE_EINT1_MASK          0x0020  /* IM_HP3R_DONE_EINT1 */
> +#define ARIZONA_IM_HP3R_DONE_EINT1_SHIFT              5  /* IM_HP3R_DONE_EINT1 */
> +#define ARIZONA_IM_HP3R_DONE_EINT1_WIDTH              1  /* IM_HP3R_DONE_EINT1 */
> +#define ARIZONA_IM_HP3L_DONE_EINT1               0x0010  /* IM_HP3L_DONE_EINT1 */
> +#define ARIZONA_IM_HP3L_DONE_EINT1_MASK          0x0010  /* IM_HP3L_DONE_EINT1 */
> +#define ARIZONA_IM_HP3L_DONE_EINT1_SHIFT              4  /* IM_HP3L_DONE_EINT1 */
> +#define ARIZONA_IM_HP3L_DONE_EINT1_WIDTH              1  /* IM_HP3L_DONE_EINT1 */
> +#define ARIZONA_IM_HP2R_DONE_EINT1               0x0008  /* IM_HP2R_DONE_EINT1 */
> +#define ARIZONA_IM_HP2R_DONE_EINT1_MASK          0x0008  /* IM_HP2R_DONE_EINT1 */
> +#define ARIZONA_IM_HP2R_DONE_EINT1_SHIFT              3  /* IM_HP2R_DONE_EINT1 */
> +#define ARIZONA_IM_HP2R_DONE_EINT1_WIDTH              1  /* IM_HP2R_DONE_EINT1 */
> +#define ARIZONA_IM_HP2L_DONE_EINT1               0x0004  /* IM_HP2L_DONE_EINT1 */
> +#define ARIZONA_IM_HP2L_DONE_EINT1_MASK          0x0004  /* IM_HP2L_DONE_EINT1 */
> +#define ARIZONA_IM_HP2L_DONE_EINT1_SHIFT              2  /* IM_HP2L_DONE_EINT1 */
> +#define ARIZONA_IM_HP2L_DONE_EINT1_WIDTH              1  /* IM_HP2L_DONE_EINT1 */
> +#define ARIZONA_IM_HP1R_DONE_EINT1               0x0002  /* IM_HP1R_DONE_EINT1 */
> +#define ARIZONA_IM_HP1R_DONE_EINT1_MASK          0x0002  /* IM_HP1R_DONE_EINT1 */
> +#define ARIZONA_IM_HP1R_DONE_EINT1_SHIFT              1  /* IM_HP1R_DONE_EINT1 */
> +#define ARIZONA_IM_HP1R_DONE_EINT1_WIDTH              1  /* IM_HP1R_DONE_EINT1 */
> +#define ARIZONA_IM_HP1L_DONE_EINT1               0x0001  /* IM_HP1L_DONE_EINT1 */
> +#define ARIZONA_IM_HP1L_DONE_EINT1_MASK          0x0001  /* IM_HP1L_DONE_EINT1 */
> +#define ARIZONA_IM_HP1L_DONE_EINT1_SHIFT              0  /* IM_HP1L_DONE_EINT1 */
> +#define ARIZONA_IM_HP1L_DONE_EINT1_WIDTH              1  /* IM_HP1L_DONE_EINT1 */
>  
>  /*
>   * R3340 (0xD0C) - Interrupt Status 5 Mask
> @@ -5139,6 +5187,30 @@
>  #define ARIZONA_ISRC2_CFG_ERR_EINT2_MASK         0x0040  /* ISRC2_CFG_ERR_EINT2 */
>  #define ARIZONA_ISRC2_CFG_ERR_EINT2_SHIFT             6  /* ISRC2_CFG_ERR_EINT2 */
>  #define ARIZONA_ISRC2_CFG_ERR_EINT2_WIDTH             1  /* ISRC2_CFG_ERR_EINT2 */
> +#define ARIZONA_HP3R_DONE_EINT2                  0x0020  /* HP3R_DONE_EINT2 */
> +#define ARIZONA_HP3R_DONE_EINT2_MASK             0x0020  /* HP3R_DONE_EINT2 */
> +#define ARIZONA_HP3R_DONE_EINT2_SHIFT                 5  /* HP3R_DONE_EINT2 */
> +#define ARIZONA_HP3R_DONE_EINT2_WIDTH                 1  /* HP3R_DONE_EINT2 */
> +#define ARIZONA_HP3L_DONE_EINT2                  0x0010  /* HP3L_DONE_EINT2 */
> +#define ARIZONA_HP3L_DONE_EINT2_MASK             0x0010  /* HP3L_DONE_EINT2 */
> +#define ARIZONA_HP3L_DONE_EINT2_SHIFT                 4  /* HP3L_DONE_EINT2 */
> +#define ARIZONA_HP3L_DONE_EINT2_WIDTH                 1  /* HP3L_DONE_EINT2 */
> +#define ARIZONA_HP2R_DONE_EINT2                  0x0008  /* HP2R_DONE_EINT2 */
> +#define ARIZONA_HP2R_DONE_EINT2_MASK             0x0008  /* HP2R_DONE_EINT2 */
> +#define ARIZONA_HP2R_DONE_EINT2_SHIFT                 3  /* HP2R_DONE_EINT2 */
> +#define ARIZONA_HP2R_DONE_EINT2_WIDTH                 1  /* HP2R_DONE_EINT2 */
> +#define ARIZONA_HP2L_DONE_EINT2                  0x0004  /* HP2L_DONE_EINT2 */
> +#define ARIZONA_HP2L_DONE_EINT2_MASK             0x0004  /* HP2L_DONE_EINT2 */
> +#define ARIZONA_HP2L_DONE_EINT2_SHIFT                 2  /* HP2L_DONE_EINT2 */
> +#define ARIZONA_HP2L_DONE_EINT2_WIDTH                 1  /* HP2L_DONE_EINT2 */
> +#define ARIZONA_HP1R_DONE_EINT2                  0x0002  /* HP1R_DONE_EINT2 */
> +#define ARIZONA_HP1R_DONE_EINT2_MASK             0x0002  /* HP1R_DONE_EINT2 */
> +#define ARIZONA_HP1R_DONE_EINT2_SHIFT                 1  /* HP1R_DONE_EINT2 */
> +#define ARIZONA_HP1R_DONE_EINT2_WIDTH                 1  /* HP1R_DONE_EINT2 */
> +#define ARIZONA_HP1L_DONE_EINT2                  0x0001  /* HP1L_DONE_EINT2 */
> +#define ARIZONA_HP1L_DONE_EINT2_MASK             0x0001  /* HP1L_DONE_EINT2 */
> +#define ARIZONA_HP1L_DONE_EINT2_SHIFT                 0  /* HP1L_DONE_EINT2 */
> +#define ARIZONA_HP1L_DONE_EINT2_WIDTH                 1  /* HP1L_DONE_EINT2 */
>  
>  /*
>   * R3348 (0xD14) - IRQ2 Status 5
> @@ -5307,6 +5379,30 @@
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT2_MASK      0x0040  /* IM_ISRC2_CFG_ERR_EINT2 */
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT2_SHIFT          6  /* IM_ISRC2_CFG_ERR_EINT2 */
>  #define ARIZONA_IM_ISRC2_CFG_ERR_EINT2_WIDTH          1  /* IM_ISRC2_CFG_ERR_EINT2 */
> +#define ARIZONA_IM_HP3R_DONE_EINT2               0x0020  /* IM_HP3R_DONE_EINT2 */
> +#define ARIZONA_IM_HP3R_DONE_EINT2_MASK          0x0020  /* IM_HP3R_DONE_EINT2 */
> +#define ARIZONA_IM_HP3R_DONE_EINT2_SHIFT              5  /* IM_HP3R_DONE_EINT2 */
> +#define ARIZONA_IM_HP3R_DONE_EINT2_WIDTH              1  /* IM_HP3R_DONE_EINT2 */
> +#define ARIZONA_IM_HP3L_DONE_EINT2               0x0010  /* IM_HP3L_DONE_EINT2 */
> +#define ARIZONA_IM_HP3L_DONE_EINT2_MASK          0x0010  /* IM_HP3L_DONE_EINT2 */
> +#define ARIZONA_IM_HP3L_DONE_EINT2_SHIFT              4  /* IM_HP3L_DONE_EINT2 */
> +#define ARIZONA_IM_HP3L_DONE_EINT2_WIDTH              1  /* IM_HP3L_DONE_EINT2 */
> +#define ARIZONA_IM_HP2R_DONE_EINT2               0x0008  /* IM_HP2R_DONE_EINT2 */
> +#define ARIZONA_IM_HP2R_DONE_EINT2_MASK          0x0008  /* IM_HP2R_DONE_EINT2 */
> +#define ARIZONA_IM_HP2R_DONE_EINT2_SHIFT              3  /* IM_HP2R_DONE_EINT2 */
> +#define ARIZONA_IM_HP2R_DONE_EINT2_WIDTH              1  /* IM_HP2R_DONE_EINT2 */
> +#define ARIZONA_IM_HP2L_DONE_EINT2               0x0004  /* IM_HP2L_DONE_EINT2 */
> +#define ARIZONA_IM_HP2L_DONE_EINT2_MASK          0x0004  /* IM_HP2L_DONE_EINT2 */
> +#define ARIZONA_IM_HP2L_DONE_EINT2_SHIFT              2  /* IM_HP2L_DONE_EINT2 */
> +#define ARIZONA_IM_HP2L_DONE_EINT2_WIDTH              1  /* IM_HP2L_DONE_EINT2 */
> +#define ARIZONA_IM_HP1R_DONE_EINT2               0x0002  /* IM_HP1R_DONE_EINT2 */
> +#define ARIZONA_IM_HP1R_DONE_EINT2_MASK          0x0002  /* IM_HP1R_DONE_EINT2 */
> +#define ARIZONA_IM_HP1R_DONE_EINT2_SHIFT              1  /* IM_HP1R_DONE_EINT2 */
> +#define ARIZONA_IM_HP1R_DONE_EINT2_WIDTH              1  /* IM_HP1R_DONE_EINT2 */
> +#define ARIZONA_IM_HP1L_DONE_EINT2               0x0001  /* IM_HP1L_DONE_EINT2 */
> +#define ARIZONA_IM_HP1L_DONE_EINT2_MASK          0x0001  /* IM_HP1L_DONE_EINT2 */
> +#define ARIZONA_IM_HP1L_DONE_EINT2_SHIFT              0  /* IM_HP1L_DONE_EINT2 */
> +#define ARIZONA_IM_HP1L_DONE_EINT2_WIDTH              1  /* IM_HP1L_DONE_EINT2 */
>  
>  /*
>   * R3356 (0xD1C) - IRQ2 Status 5 Mask
> @@ -5464,6 +5560,30 @@
>  #define ARIZONA_ISRC2_CFG_ERR_STS_MASK           0x0040  /* ISRC2_CFG_ERR_STS */
>  #define ARIZONA_ISRC2_CFG_ERR_STS_SHIFT               6  /* ISRC2_CFG_ERR_STS */
>  #define ARIZONA_ISRC2_CFG_ERR_STS_WIDTH               1  /* ISRC2_CFG_ERR_STS */
> +#define ARIZONA_HP3R_DONE_STS                    0x0020  /* HP3R_DONE_STS */
> +#define ARIZONA_HP3R_DONE_STS_MASK               0x0020  /* HP3R_DONE_STS */
> +#define ARIZONA_HP3R_DONE_STS_SHIFT                   5  /* HP3R_DONE_STS */
> +#define ARIZONA_HP3R_DONE_STS_WIDTH                   1  /* HP3R_DONE_STS */
> +#define ARIZONA_HP3L_DONE_STS                    0x0010  /* HP3L_DONE_STS */
> +#define ARIZONA_HP3L_DONE_STS_MASK               0x0010  /* HP3L_DONE_STS */
> +#define ARIZONA_HP3L_DONE_STS_SHIFT                   4  /* HP3L_DONE_STS */
> +#define ARIZONA_HP3L_DONE_STS_WIDTH                   1  /* HP3L_DONE_STS */
> +#define ARIZONA_HP2R_DONE_STS                    0x0008  /* HP2R_DONE_STS */
> +#define ARIZONA_HP2R_DONE_STS_MASK               0x0008  /* HP2R_DONE_STS */
> +#define ARIZONA_HP2R_DONE_STS_SHIFT                   3  /* HP2R_DONE_STS */
> +#define ARIZONA_HP2R_DONE_STS_WIDTH                   1  /* HP2R_DONE_STS */
> +#define ARIZONA_HP2L_DONE_STS                    0x0004  /* HP2L_DONE_STS */
> +#define ARIZONA_HP2L_DONE_STS_MASK               0x0004  /* HP2L_DONE_STS */
> +#define ARIZONA_HP2L_DONE_STS_SHIFT                   2  /* HP2L_DONE_STS */
> +#define ARIZONA_HP2L_DONE_STS_WIDTH                   1  /* HP2L_DONE_STS */
> +#define ARIZONA_HP1R_DONE_STS                    0x0002  /* HP1R_DONE_STS */
> +#define ARIZONA_HP1R_DONE_STS_MASK               0x0002  /* HP1R_DONE_STS */
> +#define ARIZONA_HP1R_DONE_STS_SHIFT                   1  /* HP1R_DONE_STS */
> +#define ARIZONA_HP1R_DONE_STS_WIDTH                   1  /* HP1R_DONE_STS */
> +#define ARIZONA_HP1L_DONE_STS                    0x0001  /* HP1L_DONE_STS */
> +#define ARIZONA_HP1L_DONE_STS_MASK               0x0001  /* HP1L_DONE_STS */
> +#define ARIZONA_HP1L_DONE_STS_SHIFT                   0  /* HP1L_DONE_STS */
> +#define ARIZONA_HP1L_DONE_STS_WIDTH                   1  /* HP1L_DONE_STS */
>  
>  /*
>   * R3363 (0xD23) - Interrupt Raw Status 5

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
