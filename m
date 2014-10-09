Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaJIJjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:39:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaJIJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:39:32 -0400
Date: Thu, 9 Oct 2014 11:39:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 2/2] tracing: Clean up scheduling in
 trace_wakeup_test_thread()
Message-ID: <20141009093921.GT10832@worktop.programming.kicks-ass.net>
References: <20141009011010.446507073@goodmis.org>
 <20141009011057.316310917@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009011057.316310917@goodmis.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 09:10:12PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Peter's new debugging tool triggers when tasks exit with !TASK_RUNNING.
> The code in trace_wakeup_test_thread() also has a single schedule() call
> that should be encompassed by a loop.
> 
> This cleans up the code a little to make it a bit more robust and
> also makes the return exit properly with TASK_RUNNING.
> 
> Link: http://lkml.kernel.org/p/20141008135216.76142204@gandalf.local.home
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Peter Zijlstra <peterz@infreadead.org>

> ---
>  kernel/trace/trace_selftest.c | 47 +++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 5ef60499dc8e..593f52b73551 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -1025,6 +1025,12 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
>  #endif
>  
>  #ifdef CONFIG_SCHED_TRACER
> +
> +struct wakeup_test_data {
> +	struct completion	is_ready;
> +	int			go;
> +};

Yeah that works.. 
