Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaDONtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:49:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54970 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDONtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:49:31 -0400
Date: Tue, 15 Apr 2014 15:49:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sched & trace: Add a trace event for wait.
Message-ID: <20140415134916.GT11096@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <6d3aa5da995cfdb74b1d1c349c74a8c01ba9cdf6.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d3aa5da995cfdb74b1d1c349c74a8c01ba9cdf6.1397562542.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:32:50PM +0900, Dongsheng Yang wrote:
> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
> 

No changelog, and the tracepoint seems useless to me.

> Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
> ---
>  include/trace/events/sched.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 67e1bbf..7aa7d43a 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -51,6 +51,26 @@ TRACE_EVENT(sched_kthread_stop_ret,
>  );
>  
>  /*
> + * Tracepoint for wait:
> + */
> +TRACE_EVENT(sched_wait,
> +
> +	TP_PROTO(struct task_struct *p),
> +
> +	TP_ARGS(p),
> +
> +	TP_STRUCT__entry(
> +		__field(	pid_t,	pid	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pid	= p->pid;
> +	),
> +
> +	TP_printk("pid=%d", __entry->pid)
> +);
> +
> +/*
>   * Tracepoint for waking up a task:
>   */
>  DECLARE_EVENT_CLASS(sched_wakeup_template,
> -- 
> 1.8.2.1
> 
