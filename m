Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3FUI5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:57:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48161 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3FUI5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:57:17 -0400
Message-ID: <51C4152E.60906@gmail.com>
Date: Fri, 21 Jun 2013 16:56:14 +0800
From: Alex Shi <seakeel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-5-git-send-email-alex.shi@intel.com> <CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com> <51BF2E37.5040400@intel.com> <CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com> <CALZhoSSFr_HN9ccxNLK7HA-7O9soAU7VZ3njtKf=Ndw=_AbQRw@mail.gmail.com> <51C318D6.4090601@gmail.com> <CALZhoSQgO-V-vkOy+urL_H4cjcCE8YY3w+K=mS8hptWteKGcFw@mail.gmail.com> <51C3BCE1.1080405@gmail.com> <CALZhoSR8pLfqO+XfEfHB3-UuV5_xu=AV2mCf2BQgaaQoWd-tbw@mail.gmail.com>
In-Reply-To: <CALZhoSR8pLfqO+XfEfHB3-UuV5_xu=AV2mCf2BQgaaQoWd-tbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 10:50 AM, Lei Wen wrote:
> I see your point... I made the mistake that update the wrong patch...
> Please help check this one.
> 
> commit 5fc3d5c74f8359ef382d9a20ffe657ffc237c109
> Author: Lei Wen <leiwen@marvell.com>
> Date:   Thu Jun 20 10:43:59 2013 +0800
> 
>     sched: fix potential twice decay issue
> 
>     Signed-off-by: Lei Wen <leiwen@marvell.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c61a614..9640c66 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5856,7 +5856,8 @@ static void switched_from_fair(struct rq *rq,
> struct task_struct *p)
>         */
>         if (p->se.avg.decay_count) {
>                 struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
> -               __synchronize_entity_decay(&p->se);
> +               p->se.avg.last_runnable_update +=
> +                               __synchronize_entity_decay(&p->se);

it is not needed, since the last_runnable_update will be reset if it
will be switched to fair.

-- 
Thanks
    Alex
