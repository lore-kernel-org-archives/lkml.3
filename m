Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab3LJTs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:48:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56939 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3LJTsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:48:55 -0500
Date: Tue, 10 Dec 2013 20:48:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL RESEND2] clocksource/clockevents fixes for 3.13
Message-ID: <20131210194852.GB21814@gmail.com>
References: <52A767CB.3010501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A767CB.3010501@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> 
> Hi Thomas, Ingo,
> 
> here are the fixes for 3.13 based on timers/urgent
> 
>  * Axel Lin added a missing dependency on CLKSRC_MMIO in the Kconfig
> for the time-efm32
> 
>  * Dinh Nguyen fixed read_sched_clock to return the right value and
> added the clksrc-of missing definition for the dw_apb_timer
> 
>  * Ezequiel Garcia registered the sched clock after the counter,
> thus preventing time jump in the traces for the armada-370-xp
> 
>  * Marc Zyngier stopped the timer before enabling the irq in order
> to prevent it to be fired before the clockevent is registered for
> the sunxi
> 
>  * Thierry Reding removed a of_node_put in clksrc-of because the
> reference is not held
> 
> Thanks
>   -- Daniel
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 0e576acbc1d9600cf2d9b4a141a2554639959d50:
> 
>   nohz: Fix another inconsistency between CONFIG_NO_HZ=n and
> nohz=off (2013-11-29 12:23:03 +0100)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/fixes
> 
> for you to fetch changes up to 9ab4727c1d41e50b67aecde4bf11879560a3ca78:
> 
>   clocksource: dw_apb_timer_of: Fix support for dts binding
> "snps,dw-apb-timer" (2013-12-10 19:49:18 +0100)
> 
> ----------------------------------------------------------------
> Axel Lin (1):
>       clocksource: time-efm32: Select CLKSRC_MMIO
> 
> Dinh Nguyen (2):
>       clocksource: dw_apb_timer_of: Fix read_sched_clock
>       clocksource: dw_apb_timer_of: Fix support for dts binding
> "snps,dw-apb-timer"
> 
> Ezequiel Garcia (1):
>       clocksource: armada-370-xp: Register sched_clock after the
> counter reset
> 
> Marc Zyngier (1):
>       clocksource: sunxi: Stop timer from ticking before enabling
> interrupts
> 
> Thierry Reding (1):
>       clocksource: clksrc-of: Do not drop unheld reference on device node
> 
>  drivers/clocksource/Kconfig              |    1 +
>  drivers/clocksource/clksrc-of.c          |    1 -
>  drivers/clocksource/dw_apb_timer_of.c    |    7 ++++---
>  drivers/clocksource/sun4i_timer.c        |    3 +++
>  drivers/clocksource/time-armada-370-xp.c |   10 +++++-----
>  5 files changed, 13 insertions(+), 9 deletions(-)

Pulled into tip:timers/urgent, thanks a lot Daniel!

	Ingo
