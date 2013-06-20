Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab3FTO7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:59:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43711 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163Ab3FTO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:59:44 -0400
Message-ID: <51C318D6.4090601@gmail.com>
Date: Thu, 20 Jun 2013 22:59:34 +0800
From: Alex Shi <seakeel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lei Wen <adrian.wenl@gmail.com>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [patch v8 4/9] sched: fix slept time double counting in enqueue
 entity
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-5-git-send-email-alex.shi@intel.com> <CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com> <51BF2E37.5040400@intel.com> <CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com> <CALZhoSSFr_HN9ccxNLK7HA-7O9soAU7VZ3njtKf=Ndw=_AbQRw@mail.gmail.com>
In-Reply-To: <CALZhoSSFr_HN9ccxNLK7HA-7O9soAU7VZ3njtKf=Ndw=_AbQRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 10:46 AM, Lei Wen wrote:
> 
> 
> But here I have a question, there is another usage of __synchronzie_entity_decay
> in current kernel, in the switched_from_fair function.
> 
> If task being frequently switched between rt and fair class, would it
> also bring the
> redundant issue? Do we need patch like below?
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b5408e1..9640c66 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5856,7 +5856,7 @@ static void switched_from_fair(struct rq *rq,
> struct task_struct *p)
>         */
>         if (p->se.avg.decay_count) {
>                 struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
> -               se->avg.last_runnable_update +=
> +               p->se.avg.last_runnable_update +=

what tree does this patch base on?
>                                 __synchronize_entity_decay(&p->se);
>                 subtract_blocked_load_contrib(cfs_rq,
>                                 p->se.avg.load_avg_contrib);


-- 
Thanks
    Alex
