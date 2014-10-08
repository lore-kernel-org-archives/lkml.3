Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaJHCze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:55:34 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58415 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaJHCzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <1693047.RuqBhhrutB@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <20141007104021.GN1583@lahna.fi.intel.com>
 <CAAVeFuL_fNdavtAnG9fWOo6Qin8YG+f1x1QG-5Z37YRC4nQByQ@mail.gmail.com> <1693047.RuqBhhrutB@vostro.rjw.lan>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 8 Oct 2014 11:55:08 +0900
Message-ID: <CAAVeFu+MvBUZTrRWB008rcsMzPvEb81TEg=L8RqBz=PJ9J6bwQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] gpio: Support for unified device properties interface
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 9:09 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, October 07, 2014 07:52:02 PM Alexandre Courbot wrote:
>> On Tue, Oct 7, 2014 at 7:40 PM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:
>> > On Tue, Oct 07, 2014 at 07:22:13PM +0900, Alexandre Courbot wrote:
>> >> On Tue, Oct 7, 2014 at 9:18 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> >> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >> >
>> >> > Some drivers need to deal with only firmware representation of its
>> >> > GPIOs. An example would be a GPIO button array driver where each button
>> >> > is described as a separate firmware node in device tree. Typically these
>> >> > child nodes do not have physical representation in the Linux device
>> >> > model.
>> >> >
>> >> > In order to help device drivers to handle such firmware child nodes we
>> >> > add dev[m]_get_named_gpiod_from_child() that takes a child firmware
>> >> > node pointer as its second argument (the first one is the parent device
>> >> > itself), finds the GPIO using whatever is the underlying firmware
>> >> > method, and requests the GPIO properly.
>> >> >
>> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >>
>> >> ...
>> >>
>> >> > +/* Child properties interface */
>> >> > +struct gpio_desc *dev_get_named_gpiod_from_child(struct device *dev, void *child,
>> >> > +                                                const char *propname, int index);
>> >> > +struct gpio_desc *devm_get_named_gpiod_from_child(struct device *dev, void *child,
>> >> > +                                                 const char *propname, int index);
>> >>
>> >> I see the reason for these functions and am not opposed to them.
>> >> However, I wonder if we could not replace propname by a con_id that
>> >> would be resolved to one of con_id-gpio for DT and whatever naming
>> >> convention ACPI is using?
>> >
>> > The code in gpio-leds.c and gpio_keys_polled.c refers to "gpios" as the
>> > property name. If we can change that somehow to work with con_id-gpio
>> > instead without breaking things, then why not.
>> >
>> >> This would prevent users to name GPIOs outside of the conventions
>> >> defined in the bindings and be generally safer. Is there a particular
>> >> reason (used by some old code?) for the current direct property
>> >> access? If not, maybe we could call a slightly-modified of_find_gpio()
>> >> to resolve the GPIO property for DT, and the equivalent function for
>> >> ACPI?
>> >
>> > Only reason I can think of is support for the existing properties that
>> > are used directly. Drivers using gpiod_get() and friends do not need
>> > dev_get_named_gpiod_from_child() anyway.
>>
>> Right. Another thing is that the property handling code (active low
>> only for now) is duplicated again, but that can be addressed
>> separately.
>>
>> I will have a look at gpio-leds and gpio_keys_polled to see if we
>> cannot make this work at a higher level. It's easier to have the
>> bindings respected if the code itself enforces them.
>
> I'm wondering if that can be done after merging the current work?
>
> We'll be able to use the drivers in question with our hardware in the
> meantime then ...

Yeah, that's probably ok. The properties in question already exist so
we will have to support them anyway ; it's just a matter of seeing
whether we can improve the proposed way.

So for now:

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
