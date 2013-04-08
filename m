Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936380Ab3DHPBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:01:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936336Ab3DHPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:01:20 -0400
Date: Mon, 8 Apr 2013 17:01:17 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 6/8] memcg: fail to create cgroup if the cgroup id is too
 big
Message-ID: <20130408150117.GN17178@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627E4A.6090807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627E4A.6090807@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 16:22:34, Li Zefan wrote:
> memcg requires the cgroup id to be smaller than 65536.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

But this should be moved up the patch stack as mentioned in the previous
email.

Acked-by: Michal Hocko <mhocko@suse.cz>
Minor nit bellow.

> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c4e0173..947dff1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -492,6 +492,12 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  	return (memcg == root_mem_cgroup);
>  }
>  
> +/*
> + * We restrict the id in the range of [0, 65535], so it can fit into
> + * an unsigned short.
> + */
> +#define MEM_CGROUP_ID_MAX	(65535)

USHRT_MAX ?

> +
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
>  	return memcg->css.cgroup->id;
-- 
Michal Hocko
SUSE Labs
