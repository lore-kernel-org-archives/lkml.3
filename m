Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaL2IWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:22:36 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53168 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaL2IWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:22:33 -0500
Date: Mon, 29 Dec 2014 09:22:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: switch soft limit default back to
 infinity
Message-ID: <20141229082229.GA32618@dhcp22.suse.cz>
References: <1419792468-9278-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419792468-9278-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 28-12-14 13:47:48, Johannes Weiner wrote:
> 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") accidentally
> switched the soft limit default from infinity to zero, which turns all

Should have noticed that during the review :/

> memcgs with even a single page into soft limit excessors and engages
> soft limit reclaim on all of them during global memory pressure.  This
> makes global reclaim generally more aggressive, but also inverts the
> meaning of existing soft limit configurations where unset soft limits
> are usually more generous than set ones.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
>  mm/memcontrol.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ef91e856c7e4..b7104a55ae64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4679,6 +4679,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  	if (parent_css == NULL) {
>  		root_mem_cgroup = memcg;
>  		page_counter_init(&memcg->memory, NULL);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, NULL);
>  		page_counter_init(&memcg->kmem, NULL);
>  	}
> @@ -4724,6 +4725,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  
>  	if (parent->use_hierarchy) {
>  		page_counter_init(&memcg->memory, &parent->memory);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, &parent->memsw);
>  		page_counter_init(&memcg->kmem, &parent->kmem);
>  
> @@ -4733,6 +4735,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  		 */
>  	} else {
>  		page_counter_init(&memcg->memory, NULL);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, NULL);
>  		page_counter_init(&memcg->kmem, NULL);
>  		/*
> @@ -4807,7 +4810,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
>  	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
>  	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
> -	memcg->soft_limit = 0;
> +	memcg->soft_limit = PAGE_COUNTER_MAX;
>  }
>  
>  #ifdef CONFIG_MMU
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs
