Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbbAHTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:23:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55124 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbAHTXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:23:04 -0500
MIME-Version: 1.0
In-Reply-To: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
Date: Thu, 8 Jan 2015 20:23:03 +0100
Message-ID: <CACRpkdbuFq9_FpzdQ8oWvC9hjy-tAMiFeZEi0C0Xk9W1WRibmg@mail.gmail.com>
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        baolu.lu@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:43 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> Some platforms have an USB OTG port fully (or partially) controlled by
> GPIOs:
>
> (1) USB ID is connected directly to GPIO
>
> Optionally:
> (2) VBUS is enabled by a GPIO (when ID is grounded)
> (3) Platform has 2 USB controllers connected to same port: one for
>     device and one for host role. D+/- are switched between phys
>     by GPIO.
>
> As per initial version, this driver has the duty to control whether
> USB-Host cable is plugged in or not:
>  - If yes, OTG port is configured for host role
>  - If no, by standard, the OTG port is configured for device role
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Pretty interesting! I don't understand the USB stuff so commenting
from a GPIO side of things only.

> +config EXTCON_OTG_GPIO
> +       tristate "VIRTUAL USB OTG PORT support"
> +       depends on GPIOLIB

Isn't it dependent on ACPI? This was mentioned in the commit message.

> +/*
> + * Virtual USB OTG Port driver controlled by gpios
> + *
> + * Copyright (c) 2014, Intel Corporation.
> + * Author: David Cohen <david.a.cohen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/extcon.h>
> +#include <linux/gpio.h>

You should include <linux/gpio/consumer.h>

And nothing else. (I think it'll just work.)

> +static int __init vuport_init(void)
> +{
> +       return platform_driver_register(&vuport_driver);
> +}
> +subsys_initcall(vuport_init);

Usually we try to avoid this kind of early initcalls.
Doesn't deferred probe work as intended?

Yours,
Linus Walleij
