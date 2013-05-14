Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3ENJFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:05:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:37677 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3ENJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:05:49 -0400
MIME-Version: 1.0
In-Reply-To: <1368199049-2798-9-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-9-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 14 May 2013 02:05:18 -0700
Message-ID: <CAPM31RJFrKm1uqHEEYEPsOsT9F2VVQDjt==yCae_OrwV_t9Nyg@mail.gmail.com>
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
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
> blocked_load_avg sometime is too heavy and far bigger than runnable load
> avg. that make balance make wrong decision. So better don't consider it.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 91e60ac..75c200c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1339,7 +1339,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>         struct task_group *tg = cfs_rq->tg;
>         s64 tg_contrib;
>
> -       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;

Nack -- This is necessary for correct shares distribution.
T
> +       tg_contrib = cfs_rq->runnable_load_avg;
>         tg_contrib -= cfs_rq->tg_load_contrib;
>
>         if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> --
> 1.7.5.4
>
