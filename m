Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3FQLyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:54:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44668 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3FQLye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-6-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-6-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 04:54:02 -0700
Message-ID: <CAPM31RKkBHkL69K4AnEmmQcMaj2rfs6cWbc2WksT9G8=btjsQw@mail.gmail.com>
Subject: Re: [patch v8 5/9] sched: update cpu load after task_tick.
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
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> To get the latest runnable info, we need do this cpuload update after
> task_tick.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Reviewed-by: Paul Turner <pjt@google.com>

> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 6f226c2..05176b8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2152,8 +2152,8 @@ void scheduler_tick(void)
>
>         raw_spin_lock(&rq->lock);
>         update_rq_clock(rq);
> -       update_cpu_load_active(rq);
>         curr->sched_class->task_tick(rq, curr, 0);
> +       update_cpu_load_active(rq);
>         raw_spin_unlock(&rq->lock);
>
>         perf_event_task_tick();
> --
> 1.7.12
>
