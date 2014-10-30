Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161112AbaJ3Pe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:34:56 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57312 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934764AbaJ3Pex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:34:53 -0400
MIME-Version: 1.0
In-Reply-To: <17483842.EFni4iQX1H@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<3395005.IveyhHQnye@vostro.rjw.lan>
	<CACRpkdYR70Az1uLyjsaujQN-q-4+qRD=GpqJaOuvnKZhypL=cA@mail.gmail.com>
	<17483842.EFni4iQX1H@vostro.rjw.lan>
Date: Thu, 30 Oct 2014 16:34:53 +0100
Message-ID: <CACRpkdZNH2NQ_SEFrWf94Jby_YzwfQj0o6zoMmgB5pBRX=Rw1Q@mail.gmail.com>
Subject: Re: [PATCH v5 07/12] leds: leds-gpio: Add support for GPIO descriptors
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
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

On Tue, Oct 28, 2014 at 10:56 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, October 28, 2014 04:26:25 PM Linus Walleij wrote:
>> On Fri, Oct 17, 2014 at 2:11 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>
>> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >
>> > GPIO descriptors are the preferred way over legacy GPIO numbers
>> > nowadays. Convert the driver to use GPIO descriptors internally but
>> > still allow passing legacy GPIO numbers from platform data to support
>> > existing platforms.
>> >
>> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > Acked-by: Alexandre Courbot <acourbot@nvidia.com>
>> > Acked-by: Bryan Wu <cooloney@gmail.com>
>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> (...)
>>
>> >         if (led_dat->blinking) {
>> > -               led_dat->platform_gpio_blink_set(led_dat->gpio,
>> > -                                                led_dat->new_level,
>> > -                                                NULL, NULL);
>> > +               int gpio = desc_to_gpio(led_dat->gpiod);
>> > +               int level = led_dat->new_level;
>>
>> So this desc_to_gpio() is done only to call the legacy callback below?
>>
>> > +               if (gpiod_is_active_low(led_dat->gpiod))
>> > +                       level = !level;
>>
>> And that leads to making it necessary to have this helper variable
>> to invert the level since that callback does not pass a descriptor
>> (which would inherently know if it's active low)....
>>
>> > +
>> > +               led_dat->platform_gpio_blink_set(gpio, level, NULL, NULL);
>>
>> Is it *really* impossible to change all the users of this callback?
>
> You said it could be done in a followup patch.  Here:
> http://marc.info/?l=linux-acpi&m=141154536921643&w=4
>
> And Mika said he would add that to his TODO list:
> http://marc.info/?l=linux-acpi&m=141155173924101&w=4
>
> I suppose that is still valid.

Yes, I *can* be done as follow up, and I still *prefer* that it
be fixed now.

Otherwise I wouldn't keep commenting on it.

>> > +               led_dat->gpiod = gpio_to_desc(template->gpio);
>> > +               if (IS_ERR(led_dat->gpiod))
>> > +                       return PTR_ERR(led_dat->gpiod);
>> >         }
>>
>> OK so this is the legacy codepath: point it out in a big fat
>> comment that this is the legacy codepath.
>
> That looks like it could be done in a followup patch too.

That's not so much work that it can't be done now.

The follow-up patch I mean.

> Since the series is in my linux-next branch at this point, I really wouldn't
> like to reshuffle commits in it if that can be avoided.

That's OK if we just get the follow-up stuff now (the comment patch
immediately!), not in 18 months.

Yours,
Linus Walleij
