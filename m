Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbaJ3K3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:29:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39637 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaJ3K3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:29:51 -0400
Message-ID: <54521324.8070007@arm.com>
Date: Thu, 30 Oct 2014 10:29:56 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 6/6] sched/dl: don't check CONFIG_SMP in switched_from_dl
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-6-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-6-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 30 Oct 2014 10:29:48.0505 (UTC) FILETIME=[6E678490:01CFF42C]
X-MC-Unique: 114103010294905501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/10/14 01:41, Wanpeng Li wrote:
> There are both UP and SMP version of pull_dl_task(), so don't need 
> to check CONFIG_SMP in switched_from_dl();
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 21de865..35d6dd5 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1577,7 +1577,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>  
>  	__dl_clear_params(p);
>  
> -#ifdef CONFIG_SMP
>  	/*
>  	 * Since this might be the only -deadline task on the rq,
>  	 * this is the right place to try to pull some other one
> @@ -1585,7 +1584,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
>  	 */
>  	if (!rq->dl.dl_nr_running && pull_dl_task(rq))
>  			resched_curr(rq);
> -#endif
>  }
>  
>  /*
> 

Yes, we can remove it.

Thanks,

- Juri

