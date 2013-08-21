Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3HUNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:22:19 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:49803 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3HUNWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:22:18 -0400
Date: Wed, 21 Aug 2013 09:22:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 02/11] cpuset: add cs->real_cpus_allowed and
 cs->real_mems_allowed
Message-ID: <20130821132214.GC19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F6F.4070507@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148F6F.4070507@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:59:11PM +0800, Li Zefan wrote:
> We're going to have separate user-configured masks and effective ones.
> 
> At last configured masks can only be changed by writing cpuset.cpus

I suppose you mean "eventually" by "at last"?

> and cpuset.mems, and they won't be restricted by parent cpuset. While
> effective masks reflect cpu/memory hotplug and hierachical restriction.
> 
> This patch adds and initializes the effective masks. The effective
> masks of the top cpuset is the same with configured masks, and a child
> cpuset inherites its parent's effective masks.
> 
> This won't introduce behavior change.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 70ab3fd..404fea5 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -81,8 +81,14 @@ struct cpuset {
>  	struct cgroup_subsys_state css;
>  
>  	unsigned long flags;		/* "unsigned long" so bitops work */
> -	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
> -	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
> +
> +	/* user-configured CPUs and Memory Nodes allow to tasks */
> +	cpumask_var_t cpus_allowed;
> +	nodemask_t mems_allowed;
> +
> +	/* effective CPUs and Memory Nodes allow to tasks */
> +	cpumask_var_t real_cpus_allowed;
> +	nodemask_t real_mems_allowed;

Can we stick to the term "effective"?  If it's too long, we can drop
the "allowed" postfix, which is pretty superflous.  effective_cpus and
effective_mems should work, right?  For local vars, ecpus and emems
should do.

Thanks.

-- 
tejun
