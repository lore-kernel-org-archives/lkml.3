Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3JJEay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:30:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48024 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3JJEax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:30:53 -0400
Date: Thu, 10 Oct 2013 06:30:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] More timekeeping items for 3.13
Message-ID: <20131010043049.GA22519@gmail.com>
References: <5256285F.7060705@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5256285F.7060705@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> Hey Thomas,
>     Just wanted to send along the few minor time related items I've got
> left for 3.13.
> 
> * Small cleanup in the clocksource code.
> 
> * Fix for rtc-pl031 to let it work with alarmtimers
> 
> * Move arm64 to using the generic sched_clock framework & resulting
> cleanup in the generic sched_clock code.
> 
> 
> thanks
> -john
> 
> 
> The following changes since commit 389e067032fbb96e439abafae848dd447e4cafb4:
> 
>   Merge branch 'fortglx/3.12/time' into fortglx/3.13/time (2013-09-16
> 18:54:07 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.linaro.org/people/jstultz/linux.git fortglx/3.13/time
> 
> for you to fetch changes up to b4042ceaabbd913bc5b397ddd1e396eeb312d72f:
> 
>   sched_clock: Remove sched_clock_func() hook (2013-10-09 16:54:39 -0700)
> 
> ----------------------------------------------------------------
> Elad Wexler (1):
>       clocksource: Fix 'ret' data type of sysfs_override_clocksource()
> and sysfs_unbind_clocksource()
> 
> John Stultz (1):
>       rtc: rtc-pl031: Set wakeup flag prior to registering rtcdev
> 
> Stephen Boyd (2):
>       arch_timer: Move to generic sched_clock framework
>       sched_clock: Remove sched_clock_func() hook
> 
>  arch/arm/kernel/arch_timer.c         | 14 --------------
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/kernel/time.c             | 10 ----------
>  drivers/clocksource/arm_arch_timer.c | 10 ++++++++++
>  drivers/rtc/rtc-pl031.c              |  3 +--
>  include/linux/sched_clock.h          |  2 --
>  kernel/time/clocksource.c            |  4 ++--
>  kernel/time/sched_clock.c            |  9 +--------
>  8 files changed, 15 insertions(+), 38 deletions(-)

Pulled into tip:timers/core, thanks John!

One small detail I noticed, in commit 07783397c:

    Cc: Linus Walleij <linus.walleij@linaro.org>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>

Please remove the Cc: line in such cases in the future.

Thanks,

	Ingo
