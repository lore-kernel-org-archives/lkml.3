Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3CKHkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:40:42 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60215 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3CKHkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:40:41 -0400
Date: Mon, 11 Mar 2013 08:40:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] context tracking updates for 3.10
Message-ID: <20130311074036.GA10161@gmail.com>
References: <1362682201-612-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362682201-612-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest context tracking and cputime updates that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	sched/cputime
> 
> HEAD is 8b43876643a737bb74a0e1e557f634eb2453948b (in case you still get the
> cache of the previous branch there).
> 
> Thanks.
> 
> ---
> Changes include:
> 
> * Generalize exception handling
> 
> * Fix race in context tracking state restore on return from exception
> and irq exit kernel preemption
> 
> * Fix cputime scaling in full dynticks accounting dynamic off-case
> 
> * Fix default Kconfig value
> 
> ---
> Frederic Weisbecker (5):
>   context_tracking: Move exception handling to generic code
>   context_tracking: Restore correct previous context state on exception
>     exit
>   context_tracking: Restore preempted context state after
>     preempt_schedule_irq()
>   cputime: Dynamically scale cputime for full dynticks accounting
>   context_tracking: Enable probes by default for selftesting
> 
>  arch/x86/include/asm/context_tracking.h |   21 ----
>  arch/x86/kernel/kvm.c                   |    8 +-
>  arch/x86/kernel/traps.c                 |   68 +++++++++-----
>  arch/x86/mm/fault.c                     |    8 +-
>  include/linux/context_tracking.h        |   24 +++++-
>  include/linux/sched.h                   |    4 +-
>  init/Kconfig                            |    1 +
>  kernel/fork.c                           |    2 +-
>  kernel/sched/core.c                     |    6 +-
>  kernel/sched/cputime.c                  |  154 ++++++++++++++++---------------
>  10 files changed, 163 insertions(+), 133 deletions(-)

Pulled, thanks Frederic!

	Ingo
