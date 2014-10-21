Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaJUMTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:19:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40186 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaJUMTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:19:04 -0400
Message-ID: <54464F30.9000706@gmail.com>
Date: Tue, 21 Oct 2014 20:18:56 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>
Subject: Re: [PATCH 1/2] sched/deadline: don't need to check SD_BALANCE_FORK
References: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Juri,

ÓÚ 10/14/14, 10:22 AM, Wanpeng Li Ð´µÀ:
> There is no need to do balance during fork since SCHED_DEADLINE 
> tasks can't fork. This patch avoid the SD_BALANCE_FORK check.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index abfaf3d..f46b7f1 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -914,7 +914,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	struct task_struct *curr;
>  	struct rq *rq;
>  
> -	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
> +	if (sd_flag != SD_BALANCE_WAKE)
>  		goto out;
>  
>  	rq = cpu_rq(cpu);

