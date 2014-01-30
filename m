Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaA3KwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:52:23 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42846 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaA3KwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140128171948.351282894@infradead.org>
References: <20140128171634.974847076@infradead.org> <20140128171948.351282894@infradead.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 30 Jan 2014 11:52:01 +0100
Message-ID: <CAKfTPtDv19H2EpjPRC1xuJU6CkDzddBe_VETRTtxKFXshkhSQg@mail.gmail.com>
Subject: Re: [PATCH 8/9] sched: Clean up idle task SMP logic
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Acked-by: Vincent Guittot <vincent.guittot@linaro.org>

Vincent

On 28 January 2014 18:16, Peter Zijlstra <peterz@infradead.org> wrote:
> The idle post_schedule hook is just a vile waste of time, furthermore
> it appears unneeded, move the idle_enter_fair() call into
> pick_next_task_idle().
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: alex.shi@linaro.org
> Cc: mingo@kernel.org
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/idle_task.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -19,11 +19,6 @@ static void pre_schedule_idle(struct rq
>         idle_exit_fair(rq);
>         rq_last_tick_reset(rq);
>  }
> -
> -static void post_schedule_idle(struct rq *rq)
> -{
> -       idle_enter_fair(rq);
> -}
>  #endif /* CONFIG_SMP */
>  /*
>   * Idle tasks are unconditionally rescheduled:
> @@ -40,8 +35,7 @@ pick_next_task_idle(struct rq *rq, struc
>
>         schedstat_inc(rq, sched_goidle);
>  #ifdef CONFIG_SMP
> -       /* Trigger the post schedule to do an idle_enter for CFS */
> -       rq->post_schedule = 1;
> +       idle_enter_fair(rq);
>  #endif
>         return rq->idle;
>  }
> @@ -105,7 +99,6 @@ const struct sched_class idle_sched_clas
>  #ifdef CONFIG_SMP
>         .select_task_rq         = select_task_rq_idle,
>         .pre_schedule           = pre_schedule_idle,
> -       .post_schedule          = post_schedule_idle,
>  #endif
>
>         .set_curr_task          = set_curr_task_idle,
>
>
