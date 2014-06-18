Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaFRQsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:48:47 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54424 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaFRQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:48:46 -0400
Date: Wed, 18 Jun 2014 18:48:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v9
Message-ID: <20140618164841.GA19204@gmail.com>
References: <1402935790-19860-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402935790-19860-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/nohz-irq-work-v7 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-irq-work-v7
> 
> It has been acked by Peterz.
> 
> --- Summary ---
> 
> This set moves the nohz kick, used to notify a full dynticks CPU when
> events require tick rescheduling, out of the scheduler tick to a
> dedicated IPI.
> 
> This debloats a bit the scheduler IPI from off-topic work that was
> abusing that scheduler fast path for its convenient asynchronous
> properties. Now the nohz kick uses irq work for its own needs.
> 
> Of course this implied quite some background infrastructure rework,
> including:
> 
> * Clean up some irq work internals
> * Implement remote irq work
> * Implement nohz kick on top of remote irq work
> * Move full dynticks timer enqueue notification to new kick
> * Move multi-task notification to new kick
> * Remove unecessary barriers on multi-task notification
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       irq_work: Split raised and lazy lists
>       irq_work: Implement remote queueing
>       nohz: Support nohz full remote kick
>       nohz: Switch to nohz full remote kick on timer enqueue
>       nohz: Use nohz own full kick on 2nd task enqueue
>       nohz: Use IPI implicit full barrier against rq->nr_running r/w
> 
> 
>  include/linux/irq_work.h |  5 ++++
>  include/linux/tick.h     |  9 +++++-
>  kernel/irq_work.c        | 76 ++++++++++++++++++++++++++++++------------------
>  kernel/sched/core.c      | 22 ++++++++------
>  kernel/sched/sched.h     | 12 ++++++--
>  kernel/smp.c             |  9 ++++++
>  kernel/time/tick-sched.c | 10 ++++---
>  7 files changed, 97 insertions(+), 46 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
