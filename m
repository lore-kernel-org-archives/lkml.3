Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3GXO1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:27:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3GXO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:27:53 -0400
Date: Wed, 24 Jul 2013 16:27:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 6/8] memcg: fail to create cgroup if the cgroup id is
 too big
Message-ID: <20130724142751.GI2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <51EFA62B.3020508@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA62B.3020508@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 18:02:19, Li Zefan wrote:
> memcg requires the cgroup id to be smaller than 65536.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

One suggestion bellow

> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 35d8286..403c8d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -512,6 +512,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  	return (memcg == root_mem_cgroup);
>  }
>  
> +/*
> + * We restrict the id in the range of [1, 65535], so it can fit into
> + * an unsigned short.
> + */
> +#define MEM_CGROUP_ID_MAX	(65535)

USHRT_MAX

> +
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
>  	/*
> @@ -6243,6 +6249,9 @@ mem_cgroup_css_alloc(struct cgroup *cont)
>  	long error = -ENOMEM;
>  	int node;
>  
> +	if (cont->id > MEM_CGROUP_ID_MAX)
> +		return ERR_PTR(-ENOSPC);
> +
>  	memcg = mem_cgroup_alloc();
>  	if (!memcg)
>  		return ERR_PTR(error);
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
