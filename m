Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbaEFBXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:23:18 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62815 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432AbaEFBXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:23:17 -0400
Message-ID: <53683962.50705@huawei.com>
Date: Tue, 6 May 2014 09:22:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] kernel/cpuset.c: convert printk to pr_foo()
References: <20140505194900.a0679fd326208e0b56e51f5e@skynet.be>
In-Reply-To: <20140505194900.a0679fd326208e0b56e51f5e@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/6 1:49, Fabian Frederick wrote:
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Li Zefan <lizefan@huawei.com>

> ---
>  kernel/cpuset.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 1d8c047..7c0e8da 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -696,11 +696,8 @@ restart:
>  		if (nslot == ndoms) {
>  			static int warnings = 10;
>  			if (warnings) {
> -				printk(KERN_WARNING
> -				 "rebuild_sched_domains confused:"
> -				  " nslot %d, ndoms %d, csn %d, i %d,"
> -				  " apn %d\n",
> -				  nslot, ndoms, csn, i, apn);
> +				pr_warn("rebuild_sched_domains confused: nslot %d, ndoms %d, csn %d, i %d, apn %d\n",
> +					nslot, ndoms, csn, i, apn);
>  				warnings--;
>  			}
>  			continue;
> @@ -2018,7 +2015,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
>  		parent = parent_cs(parent);
>  
>  	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
> -		printk(KERN_ERR "cpuset: failed to transfer tasks out of empty cpuset ");
> +		pr_err("cpuset: failed to transfer tasks out of empty cpuset ");
>  		pr_cont_cgroup_name(cs->css.cgroup);
>  		pr_cont("\n");
>  	}
> @@ -2555,7 +2552,7 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
>  	cgrp = task_cs(tsk)->css.cgroup;
>  	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
>  			   tsk->mems_allowed);
> -	printk(KERN_INFO "%s cpuset=", tsk->comm);
> +	pr_info("%s cpuset=", tsk->comm);
>  	pr_cont_cgroup_name(cgrp);
>  	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
>  
> 

