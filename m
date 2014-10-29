Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934512AbaJ2RIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:08:46 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40310 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaJ2RIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:08:44 -0400
Message-ID: <54511F21.5090506@arm.com>
Date: Wed, 29 Oct 2014 17:08:49 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 4/6] sched/dl: push task away if the deadline is equal
 to curr during wakeup
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-4-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-4-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 29 Oct 2014 17:08:42.0444 (UTC) FILETIME=[FDBB08C0:01CFF39A]
X-MC-Unique: 114102917084201301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/10/14 01:41, Wanpeng Li wrote:
> This patch pushes task away if the dealine of the task is equal 
> to current during wake up. The same behavior as rt class.
> 

Right.

Thanks,

- Juri

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index aa7c27f..97141e2 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1492,7 +1492,7 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
>  	    p->nr_cpus_allowed > 1 &&
>  	    dl_task(rq->curr) &&
>  	    (rq->curr->nr_cpus_allowed < 2 ||
> -	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
> +	     !dl_entity_preempt(&p->dl, &rq->curr->dl))) {
>  		push_dl_tasks(rq);
>  	}
>  }
> 

