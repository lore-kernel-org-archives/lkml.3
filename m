Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKCNWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:22:13 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60856 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKCNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:22:10 -0500
MIME-Version: 1.0
In-Reply-To: <2758495.RYBbleVHkC@vostro.rjw.lan>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
	<20141024073436.GN1484@lahna.fi.intel.com>
	<1971306.rIA5QAW7ve@vostro.rjw.lan>
	<2758495.RYBbleVHkC@vostro.rjw.lan>
Date: Mon, 3 Nov 2014 14:22:10 +0100
Message-ID: <CACRpkdanUC4QYbMXgMOkiGS+6oVyD1Opg_sFo95TEsyHJTM6_w@mail.gmail.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:05 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Provide a way for device drivers using GPIOs described by ACPI
> GpioIo resources in _CRS to tell the GPIO subsystem what names
> (connection IDs) to associate with specific GPIO pins defined
> in there.
>
> To do that, a driver needs to define a mapping table as a
> NULL-terminated array of struct acpi_gpio_mapping objects
> that each contain a name, a pointer to an array of pin data
> (struct acpi_gpio_params) objects and the size of that array.
>
> Each struct acpi_gpio_params object consists of three fields,
> crs_entry_index, pin_index, active_low, representing the index of

I prefer that you call the second thing "line_index" rather than
"pin_index". Not all GPIOs in the world are tied to physical pins.
Also it is easy to confuse stuff with the pin control terminology
if it's called "pin".

> the target GpioIo()/GpioInt() resource in _CRS starting from zero,
> the index of the target pin in that resource starting from zero,
> and the active-low flag for that pin, respectively.
>
> Next, the mapping table needs to be passed as the second argument to
> acpi_dev_add_driver_gpios() that will register it with the ACPI device
> object pointed to by its first argument.  That object must represent
> the ACPI namespace node containing the _CRS object referred to by the
> GPIO mapping.  That should be done in the driver's .probe() routine.
>
> On removal, the driver should unregister its GPIO mapping table
> by calling acpi_dev_remove_driver_gpios() on the ACPI device
> object where that table was previously registered.
>
> Included are fixes from Mika Westerberg.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

And "pin" is mentioned several times in the commit message.
I prefer that we talk about "lines".

(...)

> +struct acpi_gpio_params {
> +       unsigned int crs_entry_index;
> +       unsigned int pin_index;

So line_index;

> +       bool active_low;
> +};

With that change:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
