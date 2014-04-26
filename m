Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaDZElj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 00:41:39 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44424 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaDZEli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 00:41:38 -0400
Date: Fri, 25 Apr 2014 21:41:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] Input: gpio_keys - convert struct descriptions to
 kernel-doc
Message-ID: <20140426044134.GA27425@core.coreip.homeip.net>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1398442937-15309-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398442937-15309-4-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:22:17PM +0300, Andy Shevchenko wrote:
> This patch converts descriptions of the structures defined in linux/gpio_keys.h
> to follow kernel-doc format.
> 
> There is no functional change.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thank you.

> ---
>  include/linux/gpio_keys.h | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/gpio_keys.h b/include/linux/gpio_keys.h
> index a7e977f..997134a 100644
> --- a/include/linux/gpio_keys.h
> +++ b/include/linux/gpio_keys.h
> @@ -3,29 +3,50 @@
>  
>  struct device;
>  
> +/**
> + * struct gpio_keys_button - configuration parameters
> + * @code:		input event code (KEY_*, SW_*)
> + * @gpio:		%-1 if this key does not support gpio
> + * @active_low:
> + * @desc:
> + * @type:		input event type (%EV_KEY, %EV_SW, %EV_ABS)
> + * @wakeup:		configure the button as a wake-up source
> + * @debounce_interval:	debounce ticks interval in msecs
> + * @can_disable:
> + * @value:		axis value for %EV_ABS
> + * @irq:		Irq number in case of interrupt keys
> + */
>  struct gpio_keys_button {
> -	/* Configuration parameters */
> -	unsigned int code;	/* input event code (KEY_*, SW_*) */
> -	int gpio;		/* -1 if this key does not support gpio */
> +	unsigned int code;
> +	int gpio;
>  	int active_low;
>  	const char *desc;
> -	unsigned int type;	/* input event type (EV_KEY, EV_SW, EV_ABS) */
> -	int wakeup;		/* configure the button as a wake-up source */
> -	int debounce_interval;	/* debounce ticks interval in msecs */
> +	unsigned int type;
> +	int wakeup;
> +	int debounce_interval;
>  	bool can_disable;
> -	int value;		/* axis value for EV_ABS */
> -	unsigned int irq;	/* Irq number in case of interrupt keys */
> +	int value;
> +	unsigned int irq;
>  };
>  
> +/**
> + * struct gpio_keys_platform_data - platform data for gpio_keys driver
> + * @buttons:
> + * @nbuttons:
> + * @poll_interval:	polling interval in msecs - for polling driver only
> + * @rep:		enable input subsystem auto repeat
> + * @enable:
> + * @disable:
> + * @name:		input device name
> + */
>  struct gpio_keys_platform_data {
>  	struct gpio_keys_button *buttons;
>  	int nbuttons;
> -	unsigned int poll_interval;	/* polling interval in msecs -
> -					   for polling driver only */
> -	unsigned int rep:1;		/* enable input subsystem auto repeat */
> +	unsigned int poll_interval;
> +	unsigned int rep:1;
>  	int (*enable)(struct device *dev);
>  	void (*disable)(struct device *dev);
> -	const char *name;		/* input device name */
> +	const char *name;
>  };
>  
>  #endif
> -- 
> 1.9.2
> 

-- 
Dmitry
