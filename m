Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbaJ2Qwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:52:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41455 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051AbaJ2Qwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:52:40 -0400
Message-ID: <54511B5D.1030208@arm.com>
Date: Wed, 29 Oct 2014 16:52:45 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 3/6] sched/dl: add deadline rq status print
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-3-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1414374067-7209-3-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 29 Oct 2014 16:52:38.0663 (UTC) FILETIME=[BF45B970:01CFF398]
X-MC-Unique: 114102916523802601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/10/14 01:41, Wanpeng Li wrote:
> This patch add deadline rq status print.
> 

Don't know if useful, but we could add this, just to be consistent.

Thanks,

- Juri

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 9 +++++++++
>  kernel/sched/debug.c    | 7 +++++++
>  kernel/sched/sched.h    | 1 +
>  3 files changed, 17 insertions(+)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index d4ffc1e..aa7c27f 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1682,3 +1682,12 @@ const struct sched_class dl_sched_class = {
>  	.switched_from		= switched_from_dl,
>  	.switched_to		= switched_to_dl,
>  };
> +
> +#ifdef CONFIG_SCHED_DEBUG
> +extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
> +
> +void print_dl_stats(struct seq_file *m, int cpu)
> +{
> +	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
> +}
> +#endif /* CONFIG_SCHED_DEBUG */
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index ce33780..eeb6046 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -261,6 +261,12 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>  #undef P
>  }
>  
> +void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
> +{
> +	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
> +	SEQ_printf(m, "  .%-30s: %ld\n", "dl_nr_running", dl_rq->dl_nr_running);
> +}
> +
>  extern __read_mostly int sched_clock_running;
>  
>  static void print_cpu(struct seq_file *m, int cpu)
> @@ -329,6 +335,7 @@ do {									\
>  	spin_lock_irqsave(&sched_debug_lock, flags);
>  	print_cfs_stats(m, cpu);
>  	print_rt_stats(m, cpu);
> +	print_dl_stats(m, cpu);
>  
>  	print_rq(m, rq, cpu);
>  	spin_unlock_irqrestore(&sched_debug_lock, flags);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 6130251..2c2ef3c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1502,6 +1502,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
>  extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
>  extern void print_cfs_stats(struct seq_file *m, int cpu);
>  extern void print_rt_stats(struct seq_file *m, int cpu);
> +extern void print_dl_stats(struct seq_file *m, int cpu);
>  
>  extern void init_cfs_rq(struct cfs_rq *cfs_rq);
>  extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
> 

