Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3JOPgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:36:07 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33762 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3JOPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:36:05 -0400
Date: Tue, 15 Oct 2013 11:36:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 11/12] cpuset: allow writing offlined masks to
 cpuset.cpus/mems
Message-ID: <20131015153601.GM3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257CA3A.2040705@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5257CA3A.2040705@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:51:54PM +0800, Li Zefan wrote:
> As the configured masks won't be limited by its parent, and the top
> cpuset's masks won't change when hotplug happens, it's natural to
> allow writing offlined masks to the configured masks.
> 
> Signed-off-by; Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index e71c04f..a98723d 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -960,7 +960,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  		if (retval < 0)
>  			return retval;
>  
> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
> +		if (!cpumask_subset(trialcs->cpus_allowed,
> +				    top_cpuset.cpus_allowed))

Shouldn't this gated by sane_behavior?

>  
> @@ -1238,8 +1239,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
>  			goto done;
>  
>  		if (!nodes_subset(trialcs->mems_allowed,
> -				node_states[N_MEMORY])) {
> -			retval =  -EINVAL;
> +				  top_cpuset.mems_allowed)) {
> +			retval = -EINVAL;

Ditto.

Thanks.

-- 
tejun
