Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3AaQME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:12:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3AaQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:12:03 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PC7jPR3bWXgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=WwiYS7LA3pYA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=kP9dU5QI9aZcyQCGJkgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359648721.17639.108.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt: Simplify pick_rt_task: remove next_prio()
 inheritance
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 31 Jan 2013 11:12:01 -0500
In-Reply-To: <70871359644177@web16d.yandex.ru>
References: <70871359644177@web16d.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-31 at 18:56 +0400, Kirill Tkhai wrote:
> Function next_prio() has been removed and pull_rt_task() is the only
> user of pick_next_highest_task_rt() at the moment.
> 
> pull_rt_task is not interested in p->nr_cpus_allowed, its only interest
> is the fact that cpu is allowed to execute p. If nr_cpus_allowed == 1,
> cpu != task_cpu(p) and cpu is allowed then it means that task p is in
> the middle of the migration techniques; the task waits until it is moved
> by migration thread. So, lets pull it earlier.
> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/rt.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 4e8f0f4..9aa2921 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1427,8 +1427,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>  static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
>  {
>  	if (!task_running(rq, p) &&
> -	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
> -	    (p->nr_cpus_allowed > 1))
> +	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
>  		return 1;
>  	return 0;
>  }


