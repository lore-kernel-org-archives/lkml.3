Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3LSRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:16:26 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48590 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3LSRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:16:24 -0500
Date: Thu, 19 Dec 2013 17:16:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: ti_am335x_tscadc: Make am335x_tsc_se_update()
 local
Message-ID: <20131219171617.GB16145@lee--X1>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
 <1387466911-3732-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387466911-3732-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Sebastian Andrzej Siewior wrote:

> Since the "recent" changes, am335x_tsc_se_update() has no longer any
> users outside of this file so make it local.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I'm pretty sure I Acked this already.

> ---
>  drivers/mfd/ti_am335x_tscadc.c       | 3 +--
>  include/linux/mfd/ti_am335x_tscadc.h | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index 88718ab..67d0eb4 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -48,11 +48,10 @@ static const struct regmap_config tscadc_regmap_config = {
>  	.val_bits = 32,
>  };
>  
> -void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
> +static void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
>  {
>  	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
>  }
> -EXPORT_SYMBOL_GPL(am335x_tsc_se_update);
>  
>  void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
>  {
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index d498d98f..1fe7219 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -176,7 +176,6 @@ static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
>  	return *tscadc_dev;
>  }
>  
> -void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc);
>  void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val);
>  void am335x_tsc_se_clr(struct ti_tscadc_dev *tsadc, u32 val);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
