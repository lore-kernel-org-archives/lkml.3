Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3AYMyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:54:10 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:57051 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3AYMyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1359114505-4473-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1359114505-4473-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 25 Jan 2013 13:54:05 +0100
Message-ID: <CACRpkdZvoacYP0rwnrcyHfKWrN67HvN5jCVom4Lx6Qd9RC0fjg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib-acpi: Add ACPI5 event model support to gpio.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        grant.likely@secretlab.ca, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:48 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add ability to handle ACPI events signalled by GPIO interrupts.
>
> ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
> handled by ACPI event methods which need to be called from the GPIO
> controller's interrupt handler. acpi_gpio_request_interrupt() finds out which
> gpio pins have acpi event methods and assigns interrupt handlers that calls
> the acpi event methods for those pins.
>
> Partially based on work by Rui Zhang <rui.zhang@intel.com>
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
(...)
> +/**
> + * acpi_gpio_request_interrupt() - Register isr for gpio controller ACPI events
> + * @chip:      gpio chip representation of the gpio controller


Hm chip, controller, controller, chip chip, controller controller...
Are we using two different names for the same thing?

> + *
> + * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
> + * handled by ACPI event methods which need to be called from the GPIO
> + * controller's interrupt handler. acpi_gpio_request_interrupt finds out which
> + * gpio pins have acpi event methods and assigns interrupt handlers that calls
> + * the acpi event methods for those pins.
> + */
> +
> +void acpi_gpio_request_interrupt(struct gpio_chip *chip)

So I was like "um, what acpi requests an interrupt for a GPIO (maybe a pin)...

... read read ...

Aha the function should probably be named:
acpi_gpiochip_request_interrupts()

Because it just grabs all IRQs coming from that chip right?

Second: why is there no mirror function *releasing* all the IRQs again?
One-way interface?

Yours,
Linus Walleij
