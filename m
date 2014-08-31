Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaHaA5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 20:57:36 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41950 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaHaA5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 20:57:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140829173746.GA14028@roeck-us.net>
References: <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
 <53D0A8B7.2010005@roeck-us.net> <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>
 <53E32C09.5000704@roeck-us.net> <CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com>
 <53E8DE1D.9070503@roeck-us.net> <CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com>
 <CACRpkdZfRxNHGtZvzjn_vb2FGNPrvh1znWSGi0znN2_yHmz0Tw@mail.gmail.com>
 <5400159F.4070608@roeck-us.net> <CAAVeFu+kfJULtfAsHSdSAfro5gxjUFzYZxo1pC7jESFTERtN9A@mail.gmail.com>
 <20140829173746.GA14028@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 30 Aug 2014 17:57:11 -0700
Message-ID: <CAAVeFuLmeNNdAmd+J2YU4e21oJSa_phoFoPP8BOv7hKgzimY=g@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Provide and export gpiod_export_name
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:37 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Aug 29, 2014 at 10:00:47AM -0700, Alexandre Courbot wrote:
>> On Thu, Aug 28, 2014 at 10:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > On 08/28/2014 10:44 PM, Linus Walleij wrote:
>> >>
>> >> On Mon, Aug 11, 2014 at 5:20 PM, Alexandre Courbot <gnurou@gmail.com>
>> >> wrote:
>> >>>
>> >>> On Tue, Aug 12, 2014 at 12:15 AM, Guenter Roeck <linux@roeck-us.net>
>> >>> wrote:
>> >>
>> >>
>> >>>> This is just one of many patches which would make it possible to submit
>> >>>> the rest, which would make use of it. What you are saying is that it
>> >>>> won't
>> >>>> make sense to submit that series into the kernel, because one of the
>> >>>> very
>> >>>> first patches needed to enable that won't be accepted. Kind of a
>> >>>> circular
>> >>>> argument, but I guess I'll have to live with it.
>> >>>
>> >>>
>> >>> Well I have not seen the other patches you mention and cannot guess
>> >>> their existence. If you send the full series it will of course be
>> >>> considered as such, but right now this lone patch does not hint any
>> >>> upstream user for this interface.
>> >>>
>> >>> Note that this doesn't change anything to the core of the argument ;
>> >>> we have not heard what Linus thinks about named GPIOs in
>> >>> /sys/class/gpio yet, maybe he will have a different opinion...
>> >>
>> >>
>> >> The sysfs is sort of broken by design because of things like this and
>> >> some other stuff.
>> >>
>> >> I think the sysfs is scary, for example since it's not hierarchical
>> >> but flat and build on the assumption that there is one single
>> >> GPIO numberspace. As pointed out in some other message
>> >> in the thread it would be nicer to have:
>> >>
>> >> /dev/gpiochip0/gpio0
>> >> /dev/gpiochip0/gpio1
>> >> ....
>> >>
>> >> instead of the horrid sysfs ABI that will have to maintain forever.
>> >>
>> > Blocking any attempts to make it more useful doesn't help much, though.
>>
>> This patch is not making it more useful. It just introduces an
>> inferior way to do something that is already possible.
>>
>> I have stated it countless times already, but again:
>> "/sys/bus/.../device/gpio_function" is better than
>> "/sys/class/gpio/device_function_foo_whatnot" (and actually,
>> "/sys/bus/.../device/gpios/function" would be even better).
>>
>> You can already do the former. I just don't see the need to introduce
>> an API to do the latter.
>>
>> Why is the former better? Because it uses the sysfs hierarchy to make
>> the GPIO visible under their consumer's node. That's how sysfs is
>> intended to be used.
>>
>> Just explain me why you cannot live with this or why your proposal is
>> better, and my concerns about this patch will be lifted.
>>
>
> "device" is a platform driver and thus platform specific, which defeats
> the purpose of having a well defined path and makes it even more difficult
> to find a pin across multiple platform variants (which will have different
> platform drivers). It means user space will still need platform specific
> configuration data to find the pin. If user space needs such configuration
> data anyway, it may as well be a "<gpio chip, pin>" tuple instead of
> "<platform driver path, gpio pin name>". Even worse, in one of my use
> cases some of the platform drivers may have multiple instances with dynamic
> instance numbers, meaning I don't even have a well defined path to start with.
>
> On the other side, as it turns out, most of the gpio chips I deal with are
> company specific, and you can not prevent me from populating the 'names'
> array for those. It is a bit on the clumsy side, as I would prefer to have
> the consumer select the name instead of the provider, but it works. For the
> other drivers (so far only one) I only need an out-of-tree patch with a
> couple of lines of code to be able to populate the 'names' field. So unless
> you take the 'names' field away, which would break the existing ABI and is
> thus at least somewhat unlikely, I can still do what I need to do.

We won't take the names field away, as you mentioned we will have to
support the user-space ABI forever and ever. I hope that at some point
we will come with a better alternative, but the old one is here to
stay anyway. Linus and myself explained why this ABI is bad ; however,
it is also true that there is no better alternative besides
implementing a custom solution.

Which allows us to reduce the argument about your patch to: "it's a
more comfortable way of doing something bad". Since that something bad
is not going away, we might as well have another (arguably better) way
of doing it.

Also:
- This patch is limited to gpiolib-sysfs.c, so damage is contained there
- The patch is small
- I cannot help but notice that Linus did not scream about it
- I did not have a strong reject about it either, but was looking for
a better way to achieve the desired  result. Looks like there is none
at the moment.

So I'm somehow ok if this patch makes it in ; I still think we should
not encourage usage of this ABI, but you do not introduce any new
harmful toy - just provide another way to use one that already exists.

Linus, please consider my position about this patch as neutral, and
feel free to take it if you think it is worth.

/me thinks about moving the sysfs interface declaration into its own
header file so as to not mix the pure and the impure... :)
