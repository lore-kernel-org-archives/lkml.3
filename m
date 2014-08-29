Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaH2RBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:01:11 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47188 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaH2RBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <5400159F.4070608@roeck-us.net>
References: <1406139132-5404-1-git-send-email-linux@roeck-us.net>
 <CAAVeFuKsJpSYo2DMyTdYE2J5Cu_ZD=b9o-=S0DLDccyNmwniNg@mail.gmail.com>
 <53D0A8B7.2010005@roeck-us.net> <CAAVeFuK5uKhpkpEnoRFGKU4G4Fey0+giz5wwmtr+OCLJHPvnLQ@mail.gmail.com>
 <53E32C09.5000704@roeck-us.net> <CAAVeFuJohBznnjELvJj0OUCK+anbZ-j1xPc9gyKDGVq9X0MDSA@mail.gmail.com>
 <53E8DE1D.9070503@roeck-us.net> <CAAVeFuK8kb3kopVaM9qz+qOa4RT_oji8LNLQa_UHDxxxwyfZgw@mail.gmail.com>
 <CACRpkdZfRxNHGtZvzjn_vb2FGNPrvh1znWSGi0znN2_yHmz0Tw@mail.gmail.com> <5400159F.4070608@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 29 Aug 2014 10:00:47 -0700
Message-ID: <CAAVeFu+kfJULtfAsHSdSAfro5gxjUFzYZxo1pC7jESFTERtN9A@mail.gmail.com>
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

On Thu, Aug 28, 2014 at 10:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 08/28/2014 10:44 PM, Linus Walleij wrote:
>>
>> On Mon, Aug 11, 2014 at 5:20 PM, Alexandre Courbot <gnurou@gmail.com>
>> wrote:
>>>
>>> On Tue, Aug 12, 2014 at 12:15 AM, Guenter Roeck <linux@roeck-us.net>
>>> wrote:
>>
>>
>>>> This is just one of many patches which would make it possible to submit
>>>> the rest, which would make use of it. What you are saying is that it
>>>> won't
>>>> make sense to submit that series into the kernel, because one of the
>>>> very
>>>> first patches needed to enable that won't be accepted. Kind of a
>>>> circular
>>>> argument, but I guess I'll have to live with it.
>>>
>>>
>>> Well I have not seen the other patches you mention and cannot guess
>>> their existence. If you send the full series it will of course be
>>> considered as such, but right now this lone patch does not hint any
>>> upstream user for this interface.
>>>
>>> Note that this doesn't change anything to the core of the argument ;
>>> we have not heard what Linus thinks about named GPIOs in
>>> /sys/class/gpio yet, maybe he will have a different opinion...
>>
>>
>> The sysfs is sort of broken by design because of things like this and
>> some other stuff.
>>
>> I think the sysfs is scary, for example since it's not hierarchical
>> but flat and build on the assumption that there is one single
>> GPIO numberspace. As pointed out in some other message
>> in the thread it would be nicer to have:
>>
>> /dev/gpiochip0/gpio0
>> /dev/gpiochip0/gpio1
>> ....
>>
>> instead of the horrid sysfs ABI that will have to maintain forever.
>>
> Blocking any attempts to make it more useful doesn't help much, though.

This patch is not making it more useful. It just introduces an
inferior way to do something that is already possible.

I have stated it countless times already, but again:
"/sys/bus/.../device/gpio_function" is better than
"/sys/class/gpio/device_function_foo_whatnot" (and actually,
"/sys/bus/.../device/gpios/function" would be even better).

You can already do the former. I just don't see the need to introduce
an API to do the latter.

Why is the former better? Because it uses the sysfs hierarchy to make
the GPIO visible under their consumer's node. That's how sysfs is
intended to be used.

Just explain me why you cannot live with this or why your proposal is
better, and my concerns about this patch will be lifted.
