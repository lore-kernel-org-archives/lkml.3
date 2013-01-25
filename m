Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3AYOBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:01:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:39588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3AYOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:01:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,538,1355126400"; 
   d="scan'208";a="252384428"
Message-ID: <51029142.9050901@linux.intel.com>
Date: Fri, 25 Jan 2013 16:05:54 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        grant.likely@secretlab.ca, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] gpiolib-acpi: Add ACPI5 event model support to gpio.
References: <1359114505-4473-1-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdZvoacYP0rwnrcyHfKWrN67HvN5jCVom4Lx6Qd9RC0fjg@mail.gmail.com>
In-Reply-To: <CACRpkdZvoacYP0rwnrcyHfKWrN67HvN5jCVom4Lx6Qd9RC0fjg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 02:54 PM, Linus Walleij wrote:
> On Fri, Jan 25, 2013 at 12:48 PM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> Add ability to handle ACPI events signalled by GPIO interrupts.
>>
>> ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
>> handled by ACPI event methods which need to be called from the GPIO
>> controller's interrupt handler. acpi_gpio_request_interrupt() finds out which
>> gpio pins have acpi event methods and assigns interrupt handlers that calls
>> the acpi event methods for those pins.
>>
>> Partially based on work by Rui Zhang<rui.zhang@intel.com>
>>
>> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
> (...)
>> +/**
>> + * acpi_gpio_request_interrupt() - Register isr for gpio controller ACPI events
>> + * @chip:      gpio chip representation of the gpio controller
>
>
> Hm chip, controller, controller, chip chip, controller controller...
> Are we using two different names for the same thing?

They get mixed up a bit here yes.
I'll change them all to chip.

>
>> + *
>> + * ACPI5 platforms can use GPIO signaled ACPI events. These GPIO interrupts are
>> + * handled by ACPI event methods which need to be called from the GPIO
>> + * controller's interrupt handler. acpi_gpio_request_interrupt finds out which
>> + * gpio pins have acpi event methods and assigns interrupt handlers that calls
>> + * the acpi event methods for those pins.
>> + */
>> +
>> +void acpi_gpio_request_interrupt(struct gpio_chip *chip)
>
> So I was like "um, what acpi requests an interrupt for a GPIO (maybe a pin)...
>
> ... read read ...
>
> Aha the function should probably be named:
> acpi_gpiochip_request_interrupts()
>

True, will rename it.

> Because it just grabs all IRQs coming from that chip right?

Not all, only the ones that have an ACPI handler method defined. 
Basically ACPI5 supports using some of the gpio interrupts for the same 
purpose as SCI interrupts.

>
> Second: why is there no mirror function *releasing* all the IRQs again?
> One-way interface?

My thinking was that using devm_request_threaded_irq(chip->dev, ...) 
will automatically free the interrupts on driver detach, making the 
release function unnecessary.

-Mathias

