Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaFIOXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:23:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58396 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaFIOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:23:44 -0400
Date: Mon, 9 Jun 2014 15:23:13 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sascha Silbe <x-linux@infra-silbe.de>
Cc: Johan Hovold <jhovold@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
Message-ID: <20140609152313.45f353d6@alan.etchedpixels.co.uk>
In-Reply-To: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de>
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> +#ifdef CONFIG_GPIOLIB
> +#include <linux/gpio.h>
> +#endif


Please create a new struct, a new file and put all the GPIO stuff in
there rather than #if bombing the driver.

You can then declare blank methods for the gpio stuff if GPIO is not
compiled in - ie in the headers


#ifdef CONFIG_GPIOLIB
extern int ftdi_gpio_open(struct ftdi_private *priv);
etc...
#else
extern inline  int ftdi_gpio_open(struct ftdi_private *priv) { return 0 };
#endif


that keeps the code itself clean and easy to read and also ensures all
the types are checked everywhere we want.

Functionality wise nothing stands out as a problem. I would expect -EBUSY
not -ENXIO if the port was being used for GPIO so could not be used for
tty.

I would favour the new config option.

Alan
