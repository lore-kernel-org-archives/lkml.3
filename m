Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3LDNak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:30:40 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52943 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3LDNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:30:38 -0500
MIME-Version: 1.0
In-Reply-To: <529D12DC.2000303@linaro.org>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
	<527B790B.4040200@linaro.org>
	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
	<527D2EA0.7060605@linaro.org>
	<CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com>
	<CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
	<CANqRtoSC7EcJqjL9ockoHUS+vwVrurSD-EhnK1tV8SSr_baJSg@mail.gmail.com>
	<529D12DC.2000303@linaro.org>
Date: Wed, 4 Dec 2013 14:30:37 +0100
Message-ID: <CANqRtoR3f+j65F3cX50CASMhzj_nRQ9ZQXTqjarO5PNp0m342w@mail.gmail.com>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: Magnus Damm <magnus.damm@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 12:08 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 11/27/2013 09:42 PM, Magnus Damm wrote:
>> Hi John, everyone,
>>
>> Let me get back to you all in a little while together with some code,
>> but before that let me just clarify this:
>>
>> On Wed, Nov 13, 2013 at 5:47 AM, John Stultz <john.stultz@linaro.org> wrote:
>>> On Tue, Nov 12, 2013 at 4:26 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>>>> On Sat, Nov 9, 2013 at 3:34 AM, John Stultz <john.stultz@linaro.org> wrote:
>>>> Let me get back to the kernel configuration. Of course, it would be
>>>> really nice if the kernel configuration was 100% fool proof, but what
>>>> happens if the user doesn't compile-in certain parts? That hardware
>>>> won't be used. What happens if wrong console device is passed on the
>>>> kernel command line? The friendly answer is usually "don't do that".
>>>>
>>>> So in case of the serial console, no driver - no output. You can still
>>>> use the network. If you have no timer then there won't be any timer
>>>> ticks. You can still get to user space though, but don't try to rely
>>>> on the timer. This CONFIG_TIMER=y/n case is pretty clear, but isn't
>>>> there a grey zone too?
>>> And on every new board, I have to fumble around with exactly those
>>> sorts of no-serial output issues. Its never something I consider a
>>> great use of my time :)
>>>
>>> And your example is a little flawed have no timer ticks, you're not
>>> getting to userspace. The system won't boot.
>> Correct me if I'm wrong here but I don't think so!
>>
>> On some platforms that may very well be the case, but on mach-shmobile
>> we get to user space without any timers. If the timers are enabled
>> then they are regular platform devices these days. From my experience
>> the main blocker for going to user space without timer is on ARM
>> usually the udelay() calculation and/or the TWD delay, but those can
>> be handled with preset worst-case values for udelay() and getting the
>> rate via CCF for the TWD.
>>
>> Also it of course depends on if some compiled-in driver needs to use
>> the timer. If we just enable the serial console then all our platforms
>> make it to initramfs-based user space without any clock source or
>> clock event.
> So something still triggers basic HZ timer functionality, and you get by
> with the jiffies clocksource?

No clock event driver is registered, so no interrupts are coming. As
for clock source, simple jiffy is used selected by default I'm
mistaken

> Ok, so thanks for the correction. But I still think booting in a
> degraded mode isn't ideal when the user has already provided enough info
> via config options that we could have sorted it out for them.

The timer subsystem is complex, so if your goal is to make things
simpler then I'm all for it!

Booting in what you call degraded mode is only useful in one case IMO:
If the user has decided to configure the kernel with some drivers
disabled. Perhaps to save space. For instance, if the user doesn't
care about power management then only using arch timer is a valid way
to use the kernel IMO. In that case other timer drivers may be
deselected.

I'm not so sure why we want to set policy to forcibly compile in bits
that are not really mandatory for basic operation?

My view is that it is just natural for users to not compile in various
drivers. No serial console driver - no serial output, no timer driver
- no timer ticks. Having a working default is of course useful, but as
I mentioned earlier, I find that defconfigs is the way to go there. Of
course, how to deal with multiplatform in such case is a bit trickier,
so Kconfig may come in handy there.

> But yea, I look forward to your next patch so we can discuss things more
> concretely, rather then in my more abstract handwaving rants ;)

Thanks, hopefully the next version will be one step in the right direction!

Cheers,

/ magnus
