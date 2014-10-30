Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbaJ3QQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:16:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:21888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaJ3QQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,286,1413270000"; 
   d="scan'208";a="599139409"
Date: Thu, 30 Oct 2014 18:15:28 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH v5 07/12] leds: leds-gpio: Add support for GPIO
 descriptors
Message-ID: <20141030161528.GS1304@lahna.fi.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <3395005.IveyhHQnye@vostro.rjw.lan>
 <CACRpkdYR70Az1uLyjsaujQN-q-4+qRD=GpqJaOuvnKZhypL=cA@mail.gmail.com>
 <17483842.EFni4iQX1H@vostro.rjw.lan>
 <20141029085306.GI1304@lahna.fi.intel.com>
 <CACRpkdaKiz4wODUnH+2+ELY3XGSYYsQ_iFMm+iY=o6rmVcxmSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaKiz4wODUnH+2+ELY3XGSYYsQ_iFMm+iY=o6rmVcxmSw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 04:40:05PM +0100, Linus Walleij wrote:
> > Yes, I'll just let dust to settle before sending out a patch that
> > converts the existing users of platform_gpio_blink_set() callback to
> > gpio descriptors.
> 
> Dust settle = 2 weeks, 18 months, 5 years?

I started to do the conversion already but then noticed that it is not
that trivial after all.

For example we have one user in arch/arm/mach-orion5x/dns323-setup.c:

static struct gpio_led_platform_data dns323ab_led_data = {
	.num_leds       = ARRAY_SIZE(dns323ab_leds),
	.leds           = dns323ab_leds,
	.gpio_blink_set = orion_gpio_led_blink_set,
};

orion_gpio_led_blink_set() is part of orion specific custom GPIO
"driver" defined in arch/arm/plat-orion/gpio.c and as far as I can tell
cannot use GPIO descriptors as it directly programs these numbers to the
hardware.

We can convert the descriptor to a number in the beginning of
orion_gpio_led_blink_set() if that helps.

Other two users: rx1950_led_blink_set() and h1940_led_blink_set() seem
to have similar needs for the numeric value.

> Sorry for nagging but I've been *SO* burnt by people in the past
> saying they will "fix things later real soon" and then never get around
> to it.

Understood.

> But I guess I'm gonna trust you anyway.

Thanks :)
