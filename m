Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaACAO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:14:57 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59565 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaACAOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1401011547340.27645@nftneq.ynat.uz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
 <20131230162158.7420e811@alan.etchedpixels.co.uk> <BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
 <20140101201053.12be7d27@alan.etchedpixels.co.uk> <alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
 <20140101230135.48f6f781@alan.etchedpixels.co.uk> <alpine.DEB.2.02.1401011547340.27645@nftneq.ynat.uz>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 2 Jan 2014 16:14:29 -0800
Message-ID: <CAK5ve-KTQvJeLXmJt-NgPy6Ju+kBzWVoSQB7TKR9TW+mfD=bxg@mail.gmail.com>
Subject: Re: [PATCH] Add LED pattern trigger
To: David Lang <david@lang.hm>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Joe Xue <lgxue@hotmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 1, 2014 at 3:51 PM, David Lang <david@lang.hm> wrote:
> On Wed, 1 Jan 2014, One Thousand Gnomes wrote:
>
>>> whatever mechanism is created for toggling LEDs should be able to toggle
>>> arbitrary GPIO pins, and there is a problem with the speed of the
>>> standard
>>> access mechanisms in /sysfs. see this post on hackaday for an example
>>>
>>>
>>> http://hackaday.com/2013/12/07/speeding-up-beaglebone-black-gpio-a-thousand-times/
>>
>>
>> The usage described is short human speed flashing patterns for things like
>> "my brain fell out" from devices, not trying to do 1KHz PWM dimming.
>> Dimming might actually be one case you want the kernel interface,
>> although it'll kill your power management.
>
>
> any high speed signalling would probably also need the kernel interface.
>
>
>>> Also, since there are a number of cases where this is hardware
>>> accelerated, it
>>> seems like there should be an abstration that userspace can use that
>>> doesn't
>>> care if or how it's accelerated, setup the output and tell the system to
>>> do it
>>> without worrying about the specific hardware details. Isn't that a large
>>> part of
>>> what the kernel is supposed to be doing?
>>
>>
>> Not usually. The kernel is supposed to be providing a consistent interface
>> to hardware, not emulating bits you don't have. Now and then it does (Eg
>> FPU emulation) but in general the job it does is "make all the network
>> cards look the same" not "make pretend network cards out of string and
>> cups". It's not a hard and fast rule in either direction. There are cases
>> the kernel doesn't try and create a common interface for the hardware
>> because the abstraction that can be done at kernel level would be
>> nonsensical.
>
>
> fair enough, would it make sense to redirect the discussion to focus on what
> a good interface would be for the cases where there is special hardware
> assistance? Then the discussion of if the same interface could/should be
> used to emulate harsdware when it isn't there can be a seprate discussion.
>
> And while this use case the original developer had in mind was the 'I've
> lost my mind' notification to a human, I think it makes sense to consider
> other uses for repeating pattern toggling of GPIO ports.
>
> David Lang

Hi folks,

I probably missed this hot discussion during the holiday in our
linux-leds community. After read all the emails of this topic, I think
this is a good idea to take this pattern drivers as a led trigger.

Actually we will see more new LED chips with hardware acceleration and
most of them support like data pattern operations. (see
drivers/leds/leds-lp55xx-common.c) Having a generic led trigger driver
will be good for those LED chip drivers.

Also for user space application, I think we don't have any user space
LED library, if I'm wrong please correct me. Why there is no such
library, since we don't need it.
led trigger driver can provide most generic led operations and people
don't need to know what's kind of hardware is under neath. If it has
hardware acceleration, LED framework will use it otherwise just use
normal operation. Take a look at other trigger drivers, heartbeat etc.
All of the operations can be done via sysfs.

So for the user space application, we just simply need shell scripts.
1. load LED pattern trigger module
2. setup pattern trigger to LED /sys interface
3. then use it.

IMHO, firstly we should take this trigger into kernel, most time it
works as a module. But we need to define a good interface between
kernel and user space.

Thanks,
-Bryan
