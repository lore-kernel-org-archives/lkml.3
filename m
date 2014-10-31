Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbaJaJln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:41:43 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:59954 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbaJaJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141030161528.GS1304@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<3395005.IveyhHQnye@vostro.rjw.lan>
	<CACRpkdYR70Az1uLyjsaujQN-q-4+qRD=GpqJaOuvnKZhypL=cA@mail.gmail.com>
	<17483842.EFni4iQX1H@vostro.rjw.lan>
	<20141029085306.GI1304@lahna.fi.intel.com>
	<CACRpkdaKiz4wODUnH+2+ELY3XGSYYsQ_iFMm+iY=o6rmVcxmSw@mail.gmail.com>
	<20141030161528.GS1304@lahna.fi.intel.com>
Date: Fri, 31 Oct 2014 10:41:38 +0100
Message-ID: <CACRpkdYQwzwLJOCx76uONCpTsUtxhePaByyYPz-52Xw9L+DYQQ@mail.gmail.com>
Subject: Re: [PATCH v5 07/12] leds: leds-gpio: Add support for GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 5:15 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Thu, Oct 30, 2014 at 04:40:05PM +0100, Linus Walleij wrote:
>> > Yes, I'll just let dust to settle before sending out a patch that
>> > converts the existing users of platform_gpio_blink_set() callback to
>> > gpio descriptors.
>>
>> Dust settle = 2 weeks, 18 months, 5 years?
>
> I started to do the conversion already but then noticed that it is not
> that trivial after all.

Thanks for looking into this.

> For example we have one user in arch/arm/mach-orion5x/dns323-setup.c:
>
> static struct gpio_led_platform_data dns323ab_led_data = {
>         .num_leds       = ARRAY_SIZE(dns323ab_leds),
>         .leds           = dns323ab_leds,
>         .gpio_blink_set = orion_gpio_led_blink_set,
> };
>
> orion_gpio_led_blink_set() is part of orion specific custom GPIO
> "driver" defined in arch/arm/plat-orion/gpio.c and as far as I can tell
> cannot use GPIO descriptors as it directly programs these numbers to the
> hardware.
>
> We can convert the descriptor to a number in the beginning of
> orion_gpio_led_blink_set() if that helps.
>
> Other two users: rx1950_led_blink_set() and h1940_led_blink_set() seem
> to have similar needs for the numeric value.

Doing the conversion from descriptor to gpio number in the
platforms is *much desired*, because it is a nice divide-and-conquer
approach.

For example mach-orion is going to be deleted and replaced
with mach-mvebu at some time, so then part of the problem
goes away entirely.

Yours,
Linus Walleij
