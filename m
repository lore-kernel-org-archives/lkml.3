Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab3DHOxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:53:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310Ab3DHOxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:53:36 -0400
Date: Mon, 8 Apr 2013 16:53:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/8] memcg: convert to use cgroup_from_id()
Message-ID: <20130408145333.GL17178@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627E09.5010605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627E09.5010605@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 16:21:29, Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

I would be tempted to stuff this into the same patch which introduces
cgroup_from_id but this is just a minor thing.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 14f1375..3561d0b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2769,15 +2769,15 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
>   */
>  static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
>  {
> -	struct cgroup_subsys_state *css;
> +	struct cgroup *cgrp;
>  
>  	/* ID 0 is unused ID */
>  	if (!id)
>  		return NULL;
> -	css = css_lookup(&mem_cgroup_subsys, id);
> -	if (!css)
> +	cgrp = cgroup_from_id(&mem_cgroup_subsys, id);
> +	if (!cgrp)
>  		return NULL;
> -	return mem_cgroup_from_css(css);
> +	return mem_cgroup_from_cont(cgrp);
>  }
>  
>  struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
