Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaAPNNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:13:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54700 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPNNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:13:33 -0500
Message-ID: <52D7DAF5.4020506@linaro.org>
Date: Thu, 16 Jan 2014 21:13:25 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org
CC: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Mike Galbraith.

Any one like to give some comments?

On 01/15/2014 10:23 PM, Alex Shi wrote:
> If the sd domain just has one group, then we must be caught the
> 	i == target later, and then goes to deeper level domain.
> So just skip this domain checking to save some instructions.
> 
> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>  kernel/sched/fair.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c7395d9..3265fbc 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4196,6 +4196,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  	sd = rcu_dereference(per_cpu(sd_llc, target));
>  	for_each_lower_domain(sd) {
>  		sg = sd->groups;
> +
> +		/* skip single group domain */
> +		if (sg == sg->next)
> +			continue;
> +
>  		do {
>  			if (!cpumask_intersects(sched_group_cpus(sg),
>  						tsk_cpus_allowed(p)))
> 


-- 
Thanks
    Alex
