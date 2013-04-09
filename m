Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935345Ab3DIGtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:49:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934715Ab3DIGtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:49:35 -0400
Date: Tue, 9 Apr 2013 08:49:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/8] memcg: convert to use cgroup_is_ancestor()
Message-ID: <20130409064934.GA30386@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627DFA.9050007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627DFA.9050007@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 16:21:14, Li Zefan wrote:
> This is a preparation to kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5aa6e91..14f1375 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1383,7 +1383,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  		return true;
>  	if (!root_memcg->use_hierarchy || !memcg)
>  		return false;
> -	return css_is_ancestor(&memcg->css, &root_memcg->css);
> +	return cgroup_is_ancestor(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
>  
>  static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
