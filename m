Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3KHIXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:23:36 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60882 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3KHIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:23:34 -0500
MIME-Version: 1.0
In-Reply-To: <527B790B.4040200@linaro.org>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
	<527B790B.4040200@linaro.org>
Date: Fri, 8 Nov 2013 17:23:31 +0900
Message-ID: <CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: Magnus Damm <magnus.damm@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 8:27 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 11/06/2013 12:05 PM, Magnus Damm wrote:
>>
>> From: Magnus Damm <damm@opensource.se>
>>
>> Add Kconfig entries for CMT, MTU2, TMU and STI to
>> drivers/clocksource/Kconfig. This will allow us to
>> get rid of duplicated entires in architecture code
>> such as arch/sh and arch/arm/mach-shmobile.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
>
> Hi Magnus,
>
> we are preventing to have selectable timer from this Kconfig.
>
> You should select the timers from the arch Kconfig option.

Thanks for your reply. In the case of ARM multiplatform this sounds
like a good match, but I wonder what to do in the case of single
platform ARM and the SH architecture. It would be nice to share the
same Kconfig entries for both SH and all ARM variants.

As you can see, in this series the Kconfig is shared between SH and
ARM mach-shmobile. Actually, on those platforms we don't treat the
timers any differently than any other device driver and traditionally
we have been allowing the user to select which timer to use as system
timer via the kernel configuration. What is the reason behind your
suggestion with the arch Kconfig selection? It seems to me that timers
are being treated differently than any other device driver, but I'm
not sure why that is the case.

Changing SH and ARM single/multi to select via the architecture
Kconfig seems like a functional regression for single platforms to me.
It is also not really in line with TWD and architected timers that are
today selectable via the ARM Kconfig. Say that I would like to develop
code for a certain timer on a SoC with multiple timers, how can I make
sure the right timer is used? Perhaps you propose relying on the
clocksource and clockevent ratings?

Cheers,

/ magnus
