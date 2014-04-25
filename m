Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaDYVVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:21:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34632 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaDYVVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:21:16 -0400
Date: Fri, 25 Apr 2014 14:21:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Input: gpio_keys - use dev instead of pdev in
 gpio_keys_setup_key()
Message-ID: <20140425212112.GA16783@core.coreip.homeip.net>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1398442937-15309-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442937-15309-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:22:15PM +0300, Andy Shevchenko wrote:
> The platform device is not used in gpio_keys_setup_key(). This patch
> substitutes it by struct device.

And the benefit of this is...?

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/input/keyboard/gpio_keys.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 2db1324..209d4c6 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -424,13 +424,12 @@ out:
>  	return IRQ_HANDLED;
>  }
>  
> -static int gpio_keys_setup_key(struct platform_device *pdev,
> +static int gpio_keys_setup_key(struct device *dev,
>  				struct input_dev *input,
>  				struct gpio_button_data *bdata,
>  				const struct gpio_keys_button *button)
>  {
>  	const char *desc = button->desc ? button->desc : "gpio_keys";
> -	struct device *dev = &pdev->dev;
>  	irq_handler_t isr;
>  	unsigned long irqflags;
>  	int irq, error;
> @@ -719,7 +718,7 @@ static int gpio_keys_probe(struct platform_device *pdev)
>  
>  	input->name = pdata->name ? : pdev->name;
>  	input->phys = "gpio-keys/input0";
> -	input->dev.parent = &pdev->dev;
> +	input->dev.parent = dev;
>  	input->open = gpio_keys_open;
>  	input->close = gpio_keys_close;
>  
> @@ -736,7 +735,7 @@ static int gpio_keys_probe(struct platform_device *pdev)
>  		const struct gpio_keys_button *button = &pdata->buttons[i];
>  		struct gpio_button_data *bdata = &ddata->data[i];
>  
> -		error = gpio_keys_setup_key(pdev, input, bdata, button);
> +		error = gpio_keys_setup_key(dev, input, bdata, button);
>  		if (error)
>  			goto fail2;
>  
> -- 
> 1.9.2
> 

Thanks.

-- 
Dmitry
