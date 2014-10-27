Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJ0FVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:21:50 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36646 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaJ0FVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <2758495.RYBbleVHkC@vostro.rjw.lan>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <20141024073436.GN1484@lahna.fi.intel.com> <1971306.rIA5QAW7ve@vostro.rjw.lan>
 <2758495.RYBbleVHkC@vostro.rjw.lan>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 27 Oct 2014 14:21:23 +0900
Message-ID: <CAAVeFuK2sBC2n5TdMwEbhi3gq7DqQm-3h-esQpoQd3U1jDJxpg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 7:05 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
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

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

As we discussed already, this is a great idea. The only thing that is
missing is a paragraph in Documentation/gpio/consumer.txt with an
explanation of the global mechanism and a simple example to illustrate
how and when this should be used.
