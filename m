Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaDVOpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:45:11 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63151 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbaDVOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:45:08 -0400
Date: Tue, 22 Apr 2014 16:45:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Drew Richardson <drew.richardson@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] Export sched tracepoints for use by kernel modules
Message-ID: <20140422144503.GA15892@gmail.com>
References: <20140422142313.GB21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142313.GB21121@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Drew Richardson <drew.richardson@arm.com> wrote:

> After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
> Use struct pointer instead of name hash for reg/unreg tracepoints"),
> any tracepoints used in a kernel module must be exported.
> 
> Signed-off-by: Drew Richardson <drew.richardson@arm.com>
> Acked-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  kernel/sched/core.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45ea238c..cdb8e92ff24a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -90,6 +90,31 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
>  
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_kthread_stop);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_kthread_stop_ret);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_wakeup);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_wakeup_new);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_switch);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_migrate_task);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_free);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_wait_task);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_wait);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_fork);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_exec);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_wait);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_sleep);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_iowait);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_blocked);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_runtime);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_pi_setprio);
> +#ifdef CONFIG_DETECT_HUNG_TASK
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_hang);
> +#endif /* CONFIG_DETECT_HUNG_TASK */
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_move_numa);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stick_numa);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_swap_numa);

Which in-tree kernel module is using these?

Thanks,

	Ingo
