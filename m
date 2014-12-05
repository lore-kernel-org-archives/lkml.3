Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaLEGi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:38:57 -0500
Received: from out4133-146.mail.aliyun.com ([42.120.133.146]:35586 "EHLO
	out4133-146.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaLEGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:38:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08150;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=9;RT=9;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: <jun.zhang@intel.com>, <mingo@redhat.com>, <peterz@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "'Chuansheng Liu'" <chuansheng.liu@intel.com>,
        "'Changcheng Liu'" <changcheng.liu@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        <pang.xunlei@zte.com.cn>
References: <1417759082-28385-1-git-send-email-jun.zhang@intel.com>
In-Reply-To: <1417759082-28385-1-git-send-email-jun.zhang@intel.com>
Subject: Re: [PATCH] sched/fair: fix find_idlest_cpu return -1
Date: Fri, 05 Dec 2014 14:38:36 +0800
Message-ID: <012601d01056$1965d3c0$4c317b40$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFWNYHfbOOkCJpjduiTEsk24TCgO510QGZA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: pang.xunlei@zte.com.cn
> 
> From: zhang jun <jun.zhang@intel.com>
> 
> find_idlest_cpu return -1 is not reasonable, set default value to this_cpu.
> 
> Signed-off-by: zhang jun <jun.zhang@intel.com>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>
> Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: <stable@vger.kernel.org> # 3.14.25
> ---
>  kernel/sched/fair.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9b4c4f3..9d18887 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4151,7 +4151,7 @@ static int
>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>  {
>  	unsigned long load, min_load = ULONG_MAX;
> -	int idlest = -1;
> +	int idlest = this_cpu;
>  	int i;
> 
>  	/* Traverse only the allowed CPUs */
> @@ -4284,7 +4284,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
>  		}
> 
>  		new_cpu = find_idlest_cpu(group, p, cpu);
> -		if (new_cpu == -1 || new_cpu == cpu) {
> +		if (new_cpu == cpu) {
>  			/* Now try balancing at a lower domain level of cpu */
>  			sd = sd->child;
>  			continue;
> --
> 1.7.9.5

