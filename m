Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab3DAJjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:39:32 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59693 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660Ab3DAJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:39:31 -0400
Date: Mon, 1 Apr 2013 11:39:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: avoid accessing memcg after releasing reference
Message-ID: <20130401093927.GB30749@dhcp22.suse.cz>
References: <5158F344.9020509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5158F344.9020509@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-04-13 10:39:00, Li Zefan wrote:
> This might cause use-after-free bug.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
> 
> found when reading the code.
> 
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8ec501c..6391046 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3186,12 +3186,12 @@ void memcg_release_cache(struct kmem_cache *s)
>  
>  	root = s->memcg_params->root_cache;
>  	root->memcg_params->memcg_caches[id] = NULL;
> -	mem_cgroup_put(memcg);
>  
>  	mutex_lock(&memcg->slab_caches_mutex);
>  	list_del(&s->memcg_params->list);
>  	mutex_unlock(&memcg->slab_caches_mutex);
>  
> +	mem_cgroup_put(memcg);
>  out:
>  	kfree(s->memcg_params);
>  }
> -- 
> 1.8.0.2

-- 
Michal Hocko
SUSE Labs
