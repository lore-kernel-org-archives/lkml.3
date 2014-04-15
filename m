Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaDONxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:53:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54992 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaDONxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:53:39 -0400
Date: Tue, 15 Apr 2014 15:53:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
Message-ID: <20140415135326.GV11096@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:32:53PM +0900, Dongsheng Yang wrote:
> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
> 
> It is pointless to wake up a running task. Currently, we can
> see it in perf sched latency.
> 
> Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..fc6b644 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1416,6 +1416,9 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>  static void
>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  {
> +	if (p->state == TASK_RUNNING)
> +		return;
> +
>  	check_preempt_curr(rq, p, wake_flags);
>  	trace_sched_wakeup(p, true);
>  


How can you get there with ->state == RUNNING? try_to_wake_up*() bail
when !(->state & state).
