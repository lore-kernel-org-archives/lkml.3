Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3CNMAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:00:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20803 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab3CNMAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:00:47 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=g8VO1FjuAB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=184NE7b5fP4A:10 a=0JF42AakBzeabsJhMOkA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363262445.25967.30.camel@gandalf.local.home>
Subject: Re: [PATCH] sched,trace: Allow tracing the preemption decision on
 wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Mar 2013 08:00:45 -0400
In-Reply-To: <1363254519.26965.9.camel@laptop>
References: <1363254519.26965.9.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 10:48 +0100, Peter Zijlstra wrote:
> Thomas noted that we do the wakeup preemption check after the wakeup
> trace point, this means the tracepoint cannot test/report this decision;
> which is rather important for latency sensitive workloads. Therefore
> move the tracepoint after doing the preemption check.
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b36635e..849deb9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1288,8 +1288,8 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>  static void
>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  {
> -	trace_sched_wakeup(p, true);
>  	check_preempt_curr(rq, p, wake_flags);
> +	trace_sched_wakeup(p, true);
>  
>  	p->state = TASK_RUNNING;
>  #ifdef CONFIG_SMP
> 


