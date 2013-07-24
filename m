Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3GXOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:20:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab3GXOUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:20:47 -0400
Date: Wed, 24 Jul 2013 16:20:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 4/8] memcg: convert to use cgroup_is_descendant()
Message-ID: <20130724142044.GG2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <51EFA5F5.3020406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA5F5.3020406@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 18:01:25, Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

css_is_ancestor doesn't depend on the depth of the hierarchy while
cgroup_is_descendant does. I do not think this would be an issue though
as __mem_cgroup_same_or_subtree is not called from any hot path.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d12ca6f..626c426 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1434,7 +1434,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  		return true;
>  	if (!root_memcg->use_hierarchy || !memcg)
>  		return false;
> -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> +	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
>  
>  static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> -- 
> 1.8.0.2
> 

-- 
Michal Hocko
SUSE Labs
