Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaJUMTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:19:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64461 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:19:44 -0400
Message-ID: <54464F59.3000100@gmail.com>
Date: Tue, 21 Oct 2014 20:19:37 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>
Subject: Re: [PATCH 2/2] sched/deadline: don't need to balance during wakeup
 if wakee is pinned
References: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com> <1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Juri,

ÓÚ 10/14/14, 10:22 AM, Wanpeng Li Ð´µÀ:
> Use nr_cpus_allowed to bail from select_task_rq() when only one cpu 
> can be used, and saves some cycles for pinned tasks.
>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index f46b7f1..5874bf8 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -914,6 +914,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
>  	struct task_struct *curr;
>  	struct rq *rq;
>  
> +	if (p->nr_cpus_allowed == 1)
> +		goto out;
> +
>  	if (sd_flag != SD_BALANCE_WAKE)
>  		goto out;
>  

