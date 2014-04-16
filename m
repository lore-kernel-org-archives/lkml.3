Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaDPJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:59:31 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:60708 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaDPJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:59:28 -0400
Date: Wed, 16 Apr 2014 10:59:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>, broonie@kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: tps65090: Stop caching registers
Message-ID: <20140416095922.GG4754@lee--X1>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397592876-5741-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397592876-5741-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nearly all of the registers in tps65090 combine control bits and
> status bits.  Turn off caching of registers so that we can read status
> bits reliably.
> 
> NOTE: the IRQnMASK and CG_CTRLn registers are the exception and could
> be cached.  If we find that we spend a lot of time reading those we
> can turn on cache for just those registers.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/tps65090.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index c3cddb4..4cfdd07 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -149,21 +149,11 @@ static struct regmap_irq_chip tps65090_irq_chip = {
>  	.mask_invert = true,
>  };
>  
> -static bool is_volatile_reg(struct device *dev, unsigned int reg)
> -{
> -	if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS2))
> -		return true;
> -	else
> -		return false;
> -}
> -

I don't know enough about Regmap internals to know what this actually
affects in real terms.

Mark,
  Does this change seem sane to you?

>  static const struct regmap_config tps65090_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  	.max_register = TOTAL_NUM_REG,
>  	.num_reg_defaults_raw = TOTAL_NUM_REG,
> -	.cache_type = REGCACHE_RBTREE,
> -	.volatile_reg = is_volatile_reg,
>  };
>  
>  #ifdef CONFIG_OF

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
