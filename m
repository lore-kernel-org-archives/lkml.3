Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbaJ2W7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:59:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55480 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbaJ2W7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:59:20 -0400
Message-ID: <54517143.6010801@gmail.com>
Date: Thu, 30 Oct 2014 06:59:15 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] sched/dl: reschedule if successfully pull earlier
 deadline task
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-5-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-5-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri, could you review 5/6 and 6/6? 5/6 is the same behavior as rt 
class. ;-)
2014/10/27 9:41, Wanpeng Li:
> Reschedule if successfully pull earlier deadline task.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>   kernel/sched/deadline.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 97141e2..21de865 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1583,8 +1583,8 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>   	 * this is the right place to try to pull some other one
>   	 * from an overloaded cpu, if any.
>   	 */
> -	if (!rq->dl.dl_nr_running)
> -		pull_dl_task(rq);
> +	if (!rq->dl.dl_nr_running && pull_dl_task(rq))
> +			resched_curr(rq);
>   #endif
>   }
>   

