Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaAWA4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:56:31 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53179 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaAWA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:56:30 -0500
Date: Thu, 23 Jan 2014 01:56:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [GIT PULL] tick: A few more cleanups
Message-ID: <20140123005624.GC24093@localhost.localdomain>
References: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:41:48PM +0100, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the timers/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/core
> 
> HEAD: 8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1
> 
> ----
> Nothing very exiting, just a bunch of non-critical cleanups for the next merge window:
> 
> 1) Make the IRQ tick APIs naming more symetric
> 
> 2) Optimize a bit jiffies_lock code coverage
> 
> 3) Whitespace fixes from Alex Shi
> 
> 4) Fix overflow in scheduler tick max deferment calculation. Given the
> current 1 second max limitation, this bug shouldn't happen in mainline.
> It's rather to prepare for making this value tunable. Or simply in case
> we change the current constant.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       tick: Rename tick_check_idle() to tick_irq_enter()
>       nohz: Get timekeeping max deferment outside jiffies_lock
> 
> Alex Shi (1):
>       nohz_full: fix code style issue of tick_nohz_full_stop_tick
> 
> Kevin Hilman (1):
>       sched/nohz: Fix overflow error in scheduler_tick_max_deferment()
> 

Ping.

> 
>  include/linux/jiffies.h  |  6 ++++++
>  include/linux/tick.h     |  6 +++---
>  kernel/sched/core.c      |  2 +-
>  kernel/softirq.c         |  2 +-
>  kernel/time/tick-sched.c | 27 ++++++++++++++-------------
>  5 files changed, 25 insertions(+), 18 deletions(-)
