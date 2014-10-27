Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaJ0IFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:05:31 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34105 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0IF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:05:29 -0400
Date: Mon, 27 Oct 2014 13:34:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched:skip loop non-idle cpus after find an idle cpu
 while find_idlest_cpu
Message-ID: <20141027080422.GB10867@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <544DB84D.1030504@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <544DB84D.1030504@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102708-1618-0000-0000-00000124EF8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yao Dongdong <yaodongdong@huawei.com> [2014-10-27 11:13:17]:

> Idle cpu is idler than non-idle cpu, so we needn't loop non-idle cpus after find an idle cpu.
> 

While this check looks good,
I dont see how we are avoiding a loop?

Are you suggesting that we break of the for loop once we set
shallowest_idle_cpu?

-- 
Thanks and Regards
Srikar


> Signed-off-by:yaodongdong@huawei.com
> 
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0b069bf..2445a23 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4446,7 +4446,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>                                 latest_idle_timestamp = rq->idle_stamp;
>                                 shallowest_idle_cpu = i;
>                         }
> -               } else {
> +               } else if (shallowest_idle_cpu == -1) {
>                         load = weighted_cpuload(i);
>                         if (load < min_load || (load == min_load && i == this_cpu)) {
>                                 min_load = load;
> --
> 1.8.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks and Regards
Srikar Dronamraju

