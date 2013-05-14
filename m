Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3ENJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:35:25 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58384 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3ENJfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:35:23 -0400
MIME-Version: 1.0
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 14 May 2013 02:34:51 -0700
Message-ID: <CAPM31RLwbrfGT8UUajmuUYVu6VmtQwr6fjAc8MJqvAWE2N_F8Q@mail.gmail.com>
Subject: Re: [patch 0/8]: use runnable load avg in balance
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 8:17 AM, Alex Shi <alex.shi@intel.com> wrote:
> This patchset bases on tip/sched/core.
>
> This version changed the runnable load avg value setting for new task
> in patch 3rd.
>
> We also tried to include blocked load avg in balance. but find many benchmark
> performance dropping. Guess the too bigger cpu load drive task to be waken
> on remote CPU, and cause wrong decision in periodic balance.

Fundamentally, I think we should be exploring this space.

While it's perhaps not surprising that it's not a drop-in, since the
current code was tuned always considering the instaneous balance, it
seems the likely path to increased balance stability.

Although, if the code is yielding substantive benefits in its current
form we should consider merging it in the interim.

> I retested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
> benchmark kbuild, aim7, dbench, tbench, hackbench, oltp, and netperf loopback
> etc. The performance is better now.
>
> On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
> become stable. on other machines, hackbench increased about 2~10%.
> oltp increased about 30% in NHM EX box.
> netperf loopback also increased on SNB EP 4 sockets box.
> no clear changes on other benchmarks.
>
> Michael Wang had tested previous version on pgbench on his box:
> https://lkml.org/lkml/2013/4/2/1022
>
> And Morten tested previous version too.
> http://comments.gmane.org/gmane.linux.kernel/1463371
>
> Thanks comments from Peter, Paul, Morten, Miacheal and Preeti.
> And more comments are appreciated!
>
> Regards
> Alex
>
> [patch v6 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v6 2/8] sched: move few runnable tg variables into CONFIG_SMP
> [patch v6 3/8] sched: set initial value of runnable avg for new
> [patch v6 4/8] sched: fix slept time double counting in enqueue
> [patch v6 5/8] sched: update cpu load after task_tick.
> [patch v6 6/8] sched: compute runnable load avg in cpu_load and
> [patch v6 7/8] sched: consider runnable load average in move_tasks
> [patch v6 8/8] sched: remove blocked_load_avg in tg
