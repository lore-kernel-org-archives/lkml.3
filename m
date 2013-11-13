Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3KMV0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:26:06 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44327 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3KMV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:26:00 -0500
Message-ID: <5283EE64.20407@linaro.org>
Date: Wed, 13 Nov 2013 13:25:56 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520>	<20131106110518.6806.79333.sendpatchset@w520>	<527B790B.4040200@linaro.org>	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>	<527D2EA0.7060605@linaro.org>	<CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com> <CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com> <5283EBCD.9050007@linaro.org>
In-Reply-To: <5283EBCD.9050007@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 01:14 PM, Daniel Lezcano wrote:
> On 11/12/2013 09:47 PM, John Stultz wrote:
>
> [ ... ]
>
>>> I think all your goals make sense, and I would like to reach the same
>>> place from a usability point of view. I would however like to allow
>>> existing power users to select whatever they want enabled on their
>>> platform. Ideally I also would like to share Kconfig bits between
>>> multiple architectures where appropriate, but it's just a few lines of
>>> code so I don't care that much.
>>
>> And as long as the options for the power-users actually make sense,
>> that all sounds fine. But I want to make sure we aren't needlessly
>> causing pain to folks building kernels all to save a few lines of
>> Kconfig logic.
>>
>> And again, this is just my pet peeve, I'm not the directory
>> submaintainer any more, so Daniel and Thomas are the ones to convince.
>> :)
>
> So to summarize:
>
> 1. We want to prevent to manually select the drivers, this is painful
> to have the right config. We assume the SoC config will choose the
> right driver config option.
>
> 2. We want to disable some drivers because they could conflict. Or for
> kernel builders, it is easier to hack around the options.

This one I'm not sure I agree with completely. Basically I think
exceptions are reasonable, but we ought to keep the bar fairly high for
adding a user-visible config option.


> 3. We want to select a driver as a module because the timer could
> reside on a PCI board.
>
> 4. Code size could be an issue if everything is selected.
>
> IMO, John's approach makes totally sense.
>
> I am not worried about the code size because one day or another we
> will have to fix up the code size increasing with the single zImage
> for ARM, and we will probably end up to unload dynamically unneeded
> drivers from the memory after booting (I don't how. Perhaps by some
> magic with the init sections).
>
> Disabling some drivers, or in other words, give more customization
> options to the kernel builders, makes also sense.
>
> It isn't possible to select the driver as we do right now but let them
> optional from the Kconfig ? What if we invert the logic in the
> Kconfig, make each driver depends on a arch_option defaulting to
> 'yes', so it can be manually unselected (similar to
> drivers/cpuidle/Kconfig.arm).

Again, the main point for me is I don't even want the options to be
visible unless there is a real need. There may be reasonable exceptions,
but for the most part we shouldn't see these.

I'll go back to Magnus' original mail and reply with the sort of
questions I think we should answer before adding user visible configs.

thanks
-john

