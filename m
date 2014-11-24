Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaKXKHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:07:50 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:49834 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKXKHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:07:49 -0500
Date: Mon, 24 Nov 2014 10:07:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: support.opensource@diasemi.com, sameo@linux.intel.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: da9063: Get irq base dynamically before
 registering device
Message-ID: <20141124100743.GB4241@x1>
References: <1416583748-6622-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1416583748-6622-2-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416583748-6622-2-git-send-email-d.lavnikevich@sam-solutions.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Dmitry Lavnikevich wrote:

> After registering mfd device with proper irq_base
> platform_get_irq_byname() calls will return VIRQ instead of local IRQ.
> This fixes da9063 rtc registration issue:
> da9063-rtc da9063-rtc: Failed to request ALARM IRQ 1: -22
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> ---
>  drivers/mfd/da9063-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
> index 93db8bb..f38bc98 100644
> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c
> @@ -118,7 +118,7 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
>  		da9063->irq_base = pdata->irq_base;
>  	} else {
>  		da9063->flags = 0;
> -		da9063->irq_base = 0;
> +		da9063->irq_base = -1;
>  	}
>  	da9063->chip_irq = irq;
>  
> @@ -168,6 +168,8 @@ int da9063_device_init(struct da9063 *da9063, unsigned int irq)
>  		return ret;
>  	}
>  
> +	da9063->irq_base = regmap_irq_chip_get_base(da9063->regmap_irq);
> +
>  	ret = mfd_add_devices(da9063->dev, -1, da9063_devs,
>  			      ARRAY_SIZE(da9063_devs), NULL, da9063->irq_base,
>  			      NULL);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
