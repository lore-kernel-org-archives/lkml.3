Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3KLM0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:26:08 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:64597 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3KLM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:26:04 -0500
MIME-Version: 1.0
In-Reply-To: <527D2EA0.7060605@linaro.org>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
	<527B790B.4040200@linaro.org>
	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
	<527D2EA0.7060605@linaro.org>
Date: Tue, 12 Nov 2013 21:26:01 +0900
Message-ID: <CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com>
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

On Sat, Nov 9, 2013 at 3:34 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 11/08/2013 12:23 AM, Magnus Damm wrote:
>> On Thu, Nov 7, 2013 at 8:27 PM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> On 11/06/2013 12:05 PM, Magnus Damm wrote:
>>>> From: Magnus Damm <damm@opensource.se>
>>>>
>>>> Add Kconfig entries for CMT, MTU2, TMU and STI to
>>>> drivers/clocksource/Kconfig. This will allow us to
>>>> get rid of duplicated entires in architecture code
>>>> such as arch/sh and arch/arm/mach-shmobile.
>>>>
>>>> Signed-off-by: Magnus Damm <damm@opensource.se>
>>>
>>> Hi Magnus,
>>>
>>> we are preventing to have selectable timer from this Kconfig.
>>>
>>> You should select the timers from the arch Kconfig option.
>> Thanks for your reply. In the case of ARM multiplatform this sounds
>> like a good match, but I wonder what to do in the case of single
>> platform ARM and the SH architecture. It would be nice to share the
>> same Kconfig entries for both SH and all ARM variants.
>>
>> As you can see, in this series the Kconfig is shared between SH and
>> ARM mach-shmobile. Actually, on those platforms we don't treat the
>> timers any differently than any other device driver and traditionally
>> we have been allowing the user to select which timer to use as system
>> timer via the kernel configuration. What is the reason behind your
>> suggestion with the arch Kconfig selection? It seems to me that timers
>> are being treated differently than any other device driver, but I'm
>> not sure why that is the case.
>
> So to me clocksources/clockevents are different from any other device
> driver, because they are *almost* always baked into the system, rather
> then being like pci or usb devices, which cannot be assumed to exist. In
> almost all cases the kernel builder has to enable some sort of board
> specific config option which implies which clocksource/clockevent driver
> should be enabled, so having a secondary config option (somewhere deeply
> nested in the drivers menus, that really just frustrates folks trying to
> get a board running) is unnecessary.

Hi Jonh,

Thanks for your reply, nice to hear your point of view!

I can see where you are coming from and I agree that it is a good idea
to keep frustration at a minimum. I'm not sure if I agree that having
nested menus with settings is necessarily a bad thing. Most drivers
are kept like that. IMO, what is bad is if the defconfig doesn't work.

> I know for some SoC maintainers, there's a desire to have config options
> be this abstract "buckets of parts", which folks can put together some
> random configuration and out will pop a kernel that supports some new
> board wihtout any code change. And while I think this is easier to
> manage from a developers point of view, I see it as really painful to
> the folks trying to build kernels.

I can somehow imagine that people may do that, but that's not really
what I'm trying to here. I too would like a single defconfig that will
work across a wide range of SoCs and their boards. At the same time I
want to give people the ability to chose what they want to enable.

> The vast majority of clocksource/clockevent hardware are architecture
> specific, and this is why I originally objected to moving all the
> clocksources (and then clockevents) out of arch/arm and into into
> drivers/clocksource. And what I'd really like to avoid is having
> something like the drivers/rtc directory, where it approaches something
> like a collection of rtc-<sha1>.c files, and the kernel builder has to
> go through a menu page of configuration options where almost none of
> them apply to the architecture they're using.

Regarding making timers into something that is really difficult for
kernel builders, I too would like to avoid that. But having a
reasonable defconfig will solve that, no?

My experience is that many kinds of timer hardware is far from
architecture specific. Most of the Renesas timer drivers can be used
on both SH and ARM. I've seen similar things between 68k and PPC. I
suspect that the x86 PIT is used pretty much everywhere. Those are all
rather simple timers, when it comes to local timers for SMP then it of
course starts getting more complicated.. In such case you probably
want in in the arch directory, yes..

> So while I've given up sub-maintainership of the drivers/clocksource
> directory to Daniel, I tried to impress that there should really be an
> *outstanding* reason for any user-selectable clocksource/clockevent
> configuration options that pop up under the drivers directory.

I see. So I don't mind that much either way, I was asked to
consolidate the kconfig and that's what I'm doing. I felt it was kind
of natural to share the Kconfig entries for SH and ARM since the same
drivers are used.

One thing that I mind is that I'd like the timer configuration to be
consistent. I'd like to know what should be selected by the SoC and
what is optional.

Let me get back to the kernel configuration. Of course, it would be
really nice if the kernel configuration was 100% fool proof, but what
happens if the user doesn't compile-in certain parts? That hardware
won't be used. What happens if wrong console device is passed on the
kernel command line? The friendly answer is usually "don't do that".

So in case of the serial console, no driver - no output. You can still
use the network. If you have no timer then there won't be any timer
ticks. You can still get to user space though, but don't try to rely
on the timer. This CONFIG_TIMER=y/n case is pretty clear, but isn't
there a grey zone too?

Regarding this grey timer area, for example have a look at the flag
CLOCK_EVT_FEAT_C3STOP. The arch timer driver sets this flag, which
means that with only arch timer the system can function as expected
for most of the time. But if we try to use the high resolution timer
with cyclictest then we get the error "WARNING: High resolution timers
not available" unless another timer is installed as well. So for some
parts of the kernel we need more than one timer. Where do you draw the
line with select?

Also, like I mentioned before, some shared timers can already be
controlled via the kernel configuration today. For instance, it is
possible to control arch timer and TWD via the kernel configuration.
How about them? I'd like to be able to control them via the kernel
configuration since this makes it possible to test all parts of the
system.

>> Changing SH and ARM single/multi to select via the architecture
>> Kconfig seems like a functional regression for single platforms to me.
>
> Not sure I understand how this is a regression. Could you expand on this?

On SH we have platform devices pointing out several different timer
channels using different drivers. Basically different timer channels
that may be used are listed for each SoC. Zero or more of these timer
drivers can be selected via kernel configuration. If you prefer low
power operation then select a timer that operates on a 32Khz timer. If
not, go with a MHz-range timer. How can this be selected without the
kernel configuration?

>> It is also not really in line with TWD and architected timers that are
>> today selectable via the ARM Kconfig. Say that I would like to develop
>> code for a certain timer on a SoC with multiple timers, how can I make
>> sure the right timer is used? Perhaps you propose relying on the
>> clocksource and clockevent ratings?
>
> So if there is a SoC with multiple timers, and there isn't a obviously
> preferred one (which can be selected either statically or via the
> ratings values), then I think it may be reasonable to have a
> user-selected config, but I'd much prefer that config to live in the
> architecture Kconfig, close to the other SoC specific options, where the
> tradeoffs of the choice can be properly documented so the user has maybe
> a chance to be able to make the right choice for their needs (rather
> then telling them to dig through nested driver config menus and having
> them select the right one of seven poorly documented options, where
> really only 2 actually apply to the board).

I think one underlying problem why we're not expressing all
dependencies in Kconfig lingo is that it would be too verbose and
heavy to point out in detail exactly which config options that apply
on each platform. Now if there was some kind of tool available that
could generate the kernel configuration based on one or more DT
files.. Or generate dependencies for Kconfig based on DT.

If I understand you correctly then your preferred choice here would be
for us to move in the direction of using select for timers in case on
ARM mach-shmobile. I think being standard is important, so following
common practise in case of ARM makes sense.

> This is starting to sound like a rant, and its all my personal opinion,
> and I'm no longer maintining the directory, so I should probably stop
> here. :)

Well, without opinions we can't find a sensible direction, can we?

> But am I making any sense? Maybe there's a more clear way to express the
> goal of the policy?

I think all your goals make sense, and I would like to reach the same
place from a usability point of view. I would however like to allow
existing power users to select whatever they want enabled on their
platform. Ideally I also would like to share Kconfig bits between
multiple architectures where appropriate, but it's just a few lines of
code so I don't care that much.

So I guess it boils down to a question if the turn-key experience
should be controlled via Kconfig dependencies or the defconfig.
Perhaps it is sane for an architecture to default to yes but allow
power users to opt-out?

Thanks,

/ magnus
