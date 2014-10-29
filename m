Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaJ2JlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:41:22 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58566 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaJ2JlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:41:20 -0400
MIME-Version: 1.0
In-Reply-To: <1414153014-152246-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1414153014-152246-1-git-send-email-mika.westerberg@linux.intel.com>
	<1414153014-152246-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Wed, 29 Oct 2014 10:41:19 +0100
Message-ID: <CACRpkdZ=+NmhivkNyjcgjDonypnXLdSBPdHQnbm8KS17pxK9NA@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 2:16 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> The GPIO resources (GpioIo/GpioInt) used in ACPI contain a GPIO number
> which is relative to the hardware GPIO controller. Typically this number
> can be translated directly to Linux GPIO number because the mapping is
> pretty much 1:1.
>
> However, when the GPIO driver is using pins exported by a pin controller
> driver via set of GPIO ranges, the mapping might not be 1:1 anymore and
> direct translation does not work.
>
> In such cases we need to translate the ACPI GPIO number to be suitable for
> the GPIO controller driver in question by checking all the pin controller
> GPIO ranges under the given device and using those to get the proper GPIO
> number.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I'm not sure what this patch does so I try to rely on you guys here.
I would strongly like to have Rafael's ACK before proceeding.

Trying to get the GPIO offsets to map 1:1 to Linux GPIO numbers
is something that should be avoided since we want to get rid of the
GPIO number space altogether. GPIO chips should try to register
with .base = -1 so that the gpiolib just assigns some random GPIO
numbers to the lines.

What does actually exist?

- GPIO offsets for a certain gpio_chip 0..N
- Pin offsets for a certain pin controller 0..N

GPIO ranges are for translating between these two.

But I have a vague idea that there is something like a numberspace
concept inside ACPI as well, and that is all magic to me...
mixing that into this is a bit scary to me.

> +#ifdef CONFIG_PINCTRL
> +/**
> + * acpi_gpiochip_pin_to_gpio_offset() - translates ACPI GPIO to Linux GPIO
> + * @chip: GPIO chip
> + * @pin: ACPI GPIO pin number from GpioIo/GpioInt resource

So I guess I'm curious about this Gpiolo/GpioInt resource number space...

Yours,
Linus Walleij
