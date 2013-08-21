Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3HUOFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:05:05 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46338 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:05:01 -0400
Date: Wed, 21 Aug 2013 10:04:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 07/11] cpuset: use effective cpumask to build sched
 domains
Message-ID: <20130821140457.GG19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FA9.806@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148FA9.806@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:00:09PM +0800, Li Zefan wrote:
> @@ -887,10 +888,17 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
>  
>  		update_tasks_cpumask(cp, heap);
>  
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;
> +
>  		rcu_read_lock();
>  		css_put(&cp->css);
>  	}
>  	rcu_read_unlock();
> +
> +	if (need_rebuild_sched_domains)
> +		rebuild_sched_domains_locked();
>  }
>  
>  /**
> @@ -944,9 +952,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  	update_cpumasks_hier(cs, trialcs, &heap);
>  
>  	heap_free(&heap);
> -
> -	if (is_sched_load_balance(cs))
> -		rebuild_sched_domains_locked();

Hmmm... can we please document what's going on with the above call and
add some comment explaining what it's doing and why it's where it's
at?

Thanks.

-- 
tejun
