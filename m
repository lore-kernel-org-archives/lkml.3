Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3K1Fm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 00:42:26 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61159 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3K1FmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 00:42:25 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
	<527B790B.4040200@linaro.org>
	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
	<527D2EA0.7060605@linaro.org>
	<CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com>
	<CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
Date: Thu, 28 Nov 2013 14:42:24 +0900
Message-ID: <CANqRtoSC7EcJqjL9ockoHUS+vwVrurSD-EhnK1tV8SSr_baJSg@mail.gmail.com>
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

Hi John, everyone,

Let me get back to you all in a little while together with some code,
but before that let me just clarify this:

On Wed, Nov 13, 2013 at 5:47 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Tue, Nov 12, 2013 at 4:26 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> On Sat, Nov 9, 2013 at 3:34 AM, John Stultz <john.stultz@linaro.org> wrote:

>> Let me get back to the kernel configuration. Of course, it would be
>> really nice if the kernel configuration was 100% fool proof, but what
>> happens if the user doesn't compile-in certain parts? That hardware
>> won't be used. What happens if wrong console device is passed on the
>> kernel command line? The friendly answer is usually "don't do that".
>>
>> So in case of the serial console, no driver - no output. You can still
>> use the network. If you have no timer then there won't be any timer
>> ticks. You can still get to user space though, but don't try to rely
>> on the timer. This CONFIG_TIMER=y/n case is pretty clear, but isn't
>> there a grey zone too?
>
> And on every new board, I have to fumble around with exactly those
> sorts of no-serial output issues. Its never something I consider a
> great use of my time :)
>
> And your example is a little flawed have no timer ticks, you're not
> getting to userspace. The system won't boot.

Correct me if I'm wrong here but I don't think so!

On some platforms that may very well be the case, but on mach-shmobile
we get to user space without any timers. If the timers are enabled
then they are regular platform devices these days. From my experience
the main blocker for going to user space without timer is on ARM
usually the udelay() calculation and/or the TWD delay, but those can
be handled with preset worst-case values for udelay() and getting the
rate via CCF for the TWD.

Also it of course depends on if some compiled-in driver needs to use
the timer. If we just enable the serial console then all our platforms
make it to initramfs-based user space without any clock source or
clock event.

I'd be happy to give you remote access to a board if you'd like to play. =)

Cheers,

/ magnus
