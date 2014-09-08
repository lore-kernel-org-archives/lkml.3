Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaIHOhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:37:08 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:60142 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaIHOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:37:06 -0400
Date: Mon, 8 Sep 2014 15:37:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix TSC resume
Message-ID: <20140908143700.GE30307@lee--X1>
References: <20140908132842.GA17443@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140908132842.GA17443@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Sebastian Andrzej Siewior wrote:

> In the resume path, the ADC invokes am335x_tsc_se_set_cache() with 0 as
> the steps argument if continous mode is not in use. This in turn disables
> all steps and so the TSC is not working until one ADC sampling is
> performed.
> 
> This patch fixes it by writing the current cached mask instead of the
> passed steps.
> 
> Fixes: 7ca6740cd1cd ("mfd: input: iio: ti_amm335x: Rework TSC/ADCA
> synchronization")
> Cc: stable@vger.kernel.org # v3.13+
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/mfd/ti_am335x_tscadc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index e3076afe6b3c..e87a2485468f 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -58,7 +58,7 @@ void am335x_tsc_se_set_cache(struct ti_tscadc_dev *tsadc, u32 val)
>  	if (tsadc->adc_waiting)
>  		wake_up(&tsadc->reg_se_wait);
>  	else if (!tsadc->adc_in_use)
> -		tscadc_writel(tsadc, REG_SE, val);
> +		tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
>  
>  	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
>  }

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
