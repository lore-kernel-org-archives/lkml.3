Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaGTULg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:11:36 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54681 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaGTULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:11:35 -0400
Date: Sun, 20 Jul 2014 22:11:30 +0200
From: Andreas Mohr <andi@lisas.de>
To: Wang YanQing <udknight@gmail.com>
Cc: linus.walleij@linaro.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio:gpio-pl2303: add gpio driver for GPIOs on PL2303
Message-ID: <20140720201130.GA9380@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720000131.GA2158@udknight>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +#include <linux/slab.h>
> +#include <linux/usb.h>
> +#include <linux/gpio.h>



> +	pl2303_gpio_write(&pl2303_gpio->gpio_chip);
> +
> +	ret = gpiochip_add(&pl2303_gpio->gpio_chip);
> +	if (ret < 0) {


AFAICS that stuff is conditional:ed by #ifdef CONFIG_GPIOLIB in
gpio.h (or rather, its internally included asm-generic/gpio.h)

Thus

> +config GPIO_PL2303
> +	tristate "USB Prolific 2303 gpio support"
> +	depends on USB_SERIAL_PL2303
> +	help
> +	  Enable support for GPIOs on USB Prolific 2303
> +	  It support two GPIOs on PL2303HX currently.

quite likely a
	depends on GPIOLIB && ...
is missing here (as is done with several other GPIO support drivers
in the same Kconfig)

Thanks for this nicely functionality-enhancing serial driver addition,

Andreas Mohr
