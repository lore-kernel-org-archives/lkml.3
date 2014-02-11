Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBKRRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:17:32 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47508 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBKRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:17:29 -0500
Date: Tue, 11 Feb 2014 17:17:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 05/12] GPIO: gpio-generic: Add label to platform data
Message-ID: <20140211171721.GE15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-6-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392138636-29240-6-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When registering more than one platform device, it is
> useful to set the gpio chip label in the platform data.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> This patch has been already merged by Linux; it has been included
> for completeness only.
> 
>  drivers/gpio/gpio-generic.c     | 2 ++
>  include/linux/basic_mmio_gpio.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index d2196bf..8c778af 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -531,6 +531,8 @@ static int bgpio_pdev_probe(struct platform_device *pdev)
>  		return err;
>  
>  	if (pdata) {
> +		if (pdata->label)

Why is this check necessary?

> +			bgc->gc.label = pdata->label;
>  		bgc->gc.base = pdata->base;
>  		if (pdata->ngpio > 0)
>  			bgc->gc.ngpio = pdata->ngpio;
> diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
> index d8a97ec..0e97856 100644
> --- a/include/linux/basic_mmio_gpio.h
> +++ b/include/linux/basic_mmio_gpio.h
> @@ -19,6 +19,7 @@
>  #include <linux/spinlock_types.h>
>  
>  struct bgpio_pdata {
> +	const char *label;
>  	int base;
>  	int ngpio;
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
