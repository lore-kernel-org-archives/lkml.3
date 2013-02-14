Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873Ab3BNTXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:23:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab3BNTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:23:09 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ThT10dvzlIIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=cbgMe-uw_AwA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=mAuMXJg8gePbUODV9EIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360869787.23152.49.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/stop_task: Do not account zero delta_exec in
 put_prev_task_stop
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 14 Feb 2013 14:23:07 -0500
In-Reply-To: <180751360618804@web6d.yandex.ru>
References: <180751360618804@web6d.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 01:40 +0400, Kirill Tkhai wrote:
> Simple return
> 

I'll ack the patch, but I nack the change log. Please write something up
that's a little more descriptive.

Thanks,

-- Steve

> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/stop_task.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
> index da5eb5b..78d0458 100644
> --- a/kernel/sched/stop_task.c
> +++ b/kernel/sched/stop_task.c
> @@ -58,8 +58,8 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
>  	u64 delta_exec;
>  
>  	delta_exec = rq->clock_task - curr->se.exec_start;
> -	if (unlikely((s64)delta_exec < 0))
> -		delta_exec = 0;
> +	if (unlikely((s64)delta_exec <= 0))
> +		return;
>  
>  	schedstat_set(curr->se.statistics.exec_max,
>  			max(curr->se.statistics.exec_max, delta_exec));


