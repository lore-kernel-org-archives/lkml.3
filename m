Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3BMGPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:15:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48277 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3BMGPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:15:50 -0500
X-AuditID: 9c930179-b7c24ae00000119c-7d-511b2f93e9b2
From: Namhyung Kim <namhyung@kernel.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]sched/stop_task: Do not account zero delta_exec in put_prev_task_stop
References: <180751360618804@web6d.yandex.ru>
Date: Wed, 13 Feb 2013 15:15:47 +0900
In-Reply-To: <180751360618804@web6d.yandex.ru> (Kirill Tkhai's message of
	"Tue, 12 Feb 2013 01:40:04 +0400")
Message-ID: <878v6spwmk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

On Tue, 12 Feb 2013 01:40:04 +0400, Kirill Tkhai wrote:
> Simple return
>
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

It seems it needs to update curr->se.exec_start then.

Thanks,
Namhyung

>  
>  	schedstat_set(curr->se.statistics.exec_max,
>  			max(curr->se.statistics.exec_max, delta_exec));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
