Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaIHIAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:00:38 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42807 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaIHIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:00:37 -0400
Date: Mon, 8 Sep 2014 09:00:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] mfd: tps65217: Tell regmap what registers are valid
Message-ID: <20140908080030.GK1397@lee--X1>
References: <1409951778-30513-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409951778-30513-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Mark Brown wrote:

> Allow regmap to provide debugfs access to the register map by telling it
> what registers are valid.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  drivers/mfd/tps65217.c       | 2 ++
>  include/linux/mfd/tps65217.h | 2 ++
>  2 files changed, 4 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
> index 3cc4c7084b92..a8ee52c95f2f 100644
> --- a/drivers/mfd/tps65217.c
> +++ b/drivers/mfd/tps65217.c
> @@ -146,6 +146,8 @@ EXPORT_SYMBOL_GPL(tps65217_clear_bits);
>  static struct regmap_config tps65217_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
> +
> +	.max_register = TPS65217_REG_MAX,
>  };
>  
>  static const struct of_device_id tps65217_of_match[] = {
> diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
> index 95d6938737fd..ac7fba44d7e4 100644
> --- a/include/linux/mfd/tps65217.h
> +++ b/include/linux/mfd/tps65217.h
> @@ -60,6 +60,8 @@
>  #define TPS65217_REG_SEQ5		0X1D
>  #define TPS65217_REG_SEQ6		0X1E
>  
> +#define TPS65217_REG_MAX		TPS65217_REG_SEQ6
> +
>  /* Register field definitions */
>  #define TPS65217_CHIPID_CHIP_MASK	0xF0
>  #define TPS65217_CHIPID_REV_MASK	0x0F

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
