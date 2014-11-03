Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaKCWgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:36:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56947 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751197AbaKCWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:36:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
Date: Mon, 03 Nov 2014 23:56:53 +0100
Message-ID: <1433051.htaUTMPMBY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdanUC4QYbMXgMOkiGS+6oVyD1Opg_sFo95TEsyHJTM6_w@mail.gmail.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <2758495.RYBbleVHkC@vostro.rjw.lan> <CACRpkdanUC4QYbMXgMOkiGS+6oVyD1Opg_sFo95TEsyHJTM6_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 03, 2014 02:22:10 PM Linus Walleij wrote:
> On Sat, Oct 25, 2014 at 12:05 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Provide a way for device drivers using GPIOs described by ACPI
> > GpioIo resources in _CRS to tell the GPIO subsystem what names
> > (connection IDs) to associate with specific GPIO pins defined
> > in there.
> >
> > To do that, a driver needs to define a mapping table as a
> > NULL-terminated array of struct acpi_gpio_mapping objects
> > that each contain a name, a pointer to an array of pin data
> > (struct acpi_gpio_params) objects and the size of that array.
> >
> > Each struct acpi_gpio_params object consists of three fields,
> > crs_entry_index, pin_index, active_low, representing the index of
> 
> I prefer that you call the second thing "line_index" rather than
> "pin_index". Not all GPIOs in the world are tied to physical pins.
> Also it is easy to confuse stuff with the pin control terminology
> if it's called "pin".
> 
> > the target GpioIo()/GpioInt() resource in _CRS starting from zero,
> > the index of the target pin in that resource starting from zero,
> > and the active-low flag for that pin, respectively.
> >
> > Next, the mapping table needs to be passed as the second argument to
> > acpi_dev_add_driver_gpios() that will register it with the ACPI device
> > object pointed to by its first argument.  That object must represent
> > the ACPI namespace node containing the _CRS object referred to by the
> > GPIO mapping.  That should be done in the driver's .probe() routine.
> >
> > On removal, the driver should unregister its GPIO mapping table
> > by calling acpi_dev_remove_driver_gpios() on the ACPI device
> > object where that table was previously registered.
> >
> > Included are fixes from Mika Westerberg.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> And "pin" is mentioned several times in the commit message.
> I prefer that we talk about "lines".
> 
> (...)
> 
> > +struct acpi_gpio_params {
> > +       unsigned int crs_entry_index;
> > +       unsigned int pin_index;
> 
> So line_index;
> 
> > +       bool active_low;
> > +};
> 
> With that change:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

OK, made the changes and added your Reviewed-by.

One semi-related question though.  Alexandre ACKed the patch before, so
what did that mean from the GPIO subsystem's perspective?  Was the patch
approved, not approved, semi-approved?

Rafael

