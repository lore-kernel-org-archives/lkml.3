Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaKMJbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:31:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40500 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaKMJbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:31:01 -0500
Message-ID: <54647A66.6020708@arm.com>
Date: Thu, 13 Nov 2014 09:31:18 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/deadline: introduce start_hrtick_dl for !CONFIG_SCHED_HRTICK
References: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1415670747-58726-1-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 13 Nov 2014 09:30:58.0311 (UTC) FILETIME=[88072970:01CFFF24]
X-MC-Unique: 114111309305906701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/11/14 01:52, Wanpeng Li wrote:
> Introduce start_hrtick_dl for !CONFIG_SCHED_HRTICK to align with
> fair class.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 04c2cbb..56674f6 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1013,6 +1013,10 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>  {
>  	hrtick_start(rq, p->dl.runtime);
>  }
> +#else /* !CONFIG_SCHED_HRTICK */
> +static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
> +{
> +}
>  #endif
>  
>  static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
> @@ -1066,10 +1070,8 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
>  	/* Running task will never be pushed. */
>         dequeue_pushable_dl_task(rq, p);
>  
> -#ifdef CONFIG_SCHED_HRTICK
>  	if (hrtick_enabled(rq))
>  		start_hrtick_dl(rq, p);
> -#endif
>  
>  	set_post_schedule(rq);
>  
> @@ -1088,10 +1090,8 @@ static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
>  {
>  	update_curr_dl(rq);
>  
> -#ifdef CONFIG_SCHED_HRTICK
>  	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
>  		start_hrtick_dl(rq, p);
> -#endif
>  }
>  
>  static void task_fork_dl(struct task_struct *p)
> 

Looks good!

Acked-by: Juri Lelli <juri.lelli@arm.com>

Thanks,

- Juri

