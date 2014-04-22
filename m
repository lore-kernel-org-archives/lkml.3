Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaDVJZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:25:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbaDVJZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:25:13 -0400
Date: Tue, 22 Apr 2014 11:25:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] Documentation/memcg: warn about incomplete kmemcg state
Message-ID: <20140422092508.GA29311@dhcp22.suse.cz>
References: <1398066420-30707-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398066420-30707-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-04-14 11:47:00, Vladimir Davydov wrote:
> Kmemcg is currently under development and lacks some important features.
> In particular, it does not have support of kmem reclaim on memory
> pressure inside cgroup, which practically makes it unusable in real
> life. Let's warn about it in both Kconfig and Documentation to prevent
> complaints arising.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Thanks! This should have been merged log time ago...

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  Documentation/cgroups/memory.txt |    5 +++++
>  init/Kconfig                     |    6 ++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 2622115276aa..af3cdfa3c07a 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -270,6 +270,11 @@ When oom event notifier is registered, event will be delivered.
>  
>  2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
>  
> +WARNING: Current implementation lacks reclaim support. That means allocation
> +	 attempts will fail when close to the limit even if there are plenty of
> +	 kmem available for reclaim. That makes this option unusable in real
> +	 life so DO NOT SELECT IT unless for development purposes.
> +
>  With the Kernel memory extension, the Memory Controller is able to limit
>  the amount of kernel memory used by the system. Kernel memory is fundamentally
>  different than user memory, since it can't be swapped out, which makes it
> diff --git a/init/Kconfig b/init/Kconfig
> index 427ba60d638f..4d6e645c8ad4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -993,6 +993,12 @@ config MEMCG_KMEM
>  	  the kmem extension can use it to guarantee that no group of processes
>  	  will ever exhaust kernel resources alone.
>  
> +	  WARNING: Current implementation lacks reclaim support. That means
> +	  allocation attempts will fail when close to the limit even if there
> +	  are plenty of kmem available for reclaim. That makes this option
> +	  unusable in real life so DO NOT SELECT IT unless for development
> +	  purposes.
> +
>  config CGROUP_HUGETLB
>  	bool "HugeTLB Resource Controller for Control Groups"
>  	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
