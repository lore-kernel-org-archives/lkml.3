Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3KMVPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:15:00 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33503 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KMVOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:14:53 -0500
Message-ID: <5283EBCD.9050007@linaro.org>
Date: Wed, 13 Nov 2013 22:14:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520>	<20131106110518.6806.79333.sendpatchset@w520>	<527B790B.4040200@linaro.org>	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>	<527D2EA0.7060605@linaro.org>	<CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com> <CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
In-Reply-To: <CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 09:47 PM, John Stultz wrote:

[ ... ]

>> I think all your goals make sense, and I would like to reach the same
>> place from a usability point of view. I would however like to allow
>> existing power users to select whatever they want enabled on their
>> platform. Ideally I also would like to share Kconfig bits between
>> multiple architectures where appropriate, but it's just a few lines of
>> code so I don't care that much.
>
> And as long as the options for the power-users actually make sense,
> that all sounds fine. But I want to make sure we aren't needlessly
> causing pain to folks building kernels all to save a few lines of
> Kconfig logic.
>
> And again, this is just my pet peeve, I'm not the directory
> submaintainer any more, so Daniel and Thomas are the ones to convince.
> :)

So to summarize:

1. We want to prevent to manually select the drivers, this is painful to 
have the right config. We assume the SoC config will choose the right 
driver config option.

2. We want to disable some drivers because they could conflict. Or for 
kernel builders, it is easier to hack around the options.

3. We want to select a driver as a module because the timer could reside 
on a PCI board.

4. Code size could be an issue if everything is selected.

IMO, John's approach makes totally sense.

I am not worried about the code size because one day or another we will 
have to fix up the code size increasing with the single zImage for ARM, 
and we will probably end up to unload dynamically unneeded drivers from 
the memory after booting (I don't how. Perhaps by some magic with the 
init sections).

Disabling some drivers, or in other words, give more customization 
options to the kernel builders, makes also sense.

It isn't possible to select the driver as we do right now but let them 
optional from the Kconfig ? What if we invert the logic in the Kconfig, 
make each driver depends on a arch_option defaulting to 'yes', so it can 
be manually unselected (similar to drivers/cpuidle/Kconfig.arm).

In any case, consolidating SH and ARM Kconfig is ok but with a change 
which is consistent with the current Kconfig, that is following the 
policy of the Kconfig (on top of the current one or on top of a new one).

   -- Daniel




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

