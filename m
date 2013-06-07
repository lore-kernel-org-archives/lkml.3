Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3FGJHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:07:34 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58741 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3FGJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <1370590169-24804-2-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
	<1370590169-24804-2-git-send-email-alex.shi@intel.com>
Date: Fri, 7 Jun 2013 11:07:28 +0200
Message-ID: <CAKfTPtA=pVQ69pfv97kgcdawgHbQbkbXW4sFGN6_bAzZcD9b9Q@mail.gmail.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 June 2013 09:29, Alex Shi <alex.shi@intel.com> wrote:
> Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
> smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
> vaiables to describe them. unsigned long is more efficient and convenience.
>

Hi Alex,

I just want to point out that we can't have more than 48388 tasks with
highest priority on a runqueue with an unsigned long on a 32 bits
system.  I don't know if we can reach such kind of limit on a 32bits
machine ? For sure, not on an embedded system.

Regards,
Vincent

> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/debug.c | 4 ++--
>  kernel/sched/sched.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 75024a6..160afdc 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -211,9 +211,9 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>         SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  #ifdef CONFIG_SMP
> -       SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
> +       SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
>                         cfs_rq->runnable_load_avg);
> -       SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
> +       SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
>                         cfs_rq->blocked_load_avg);
>         SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
>                         (unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 8bc66c6..5a80943 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -277,7 +277,7 @@ struct cfs_rq {
>          * This allows for the description of both thread and group usage (in
>          * the FAIR_GROUP_SCHED case).
>          */
> -       u64 runnable_load_avg, blocked_load_avg;
> +       unsigned long runnable_load_avg, blocked_load_avg;
>         atomic64_t decay_counter, removed_load;
>         u64 last_decay;
>
> --
> 1.7.12
>
