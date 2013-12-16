Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3LPQrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:47:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3LPQrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:47:32 -0500
Date: Mon, 16 Dec 2013 17:47:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] memcg: fix memcg_size() calculation
Message-ID: <20131216164730.GD26797@dhcp22.suse.cz>
References: <965cbb70fb55fe50a77382537b9a1b7455deac86.1387007793.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965cbb70fb55fe50a77382537b9a1b7455deac86.1387007793.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 14-12-13 12:15:33, Vladimir Davydov wrote:
> The mem_cgroup structure contains nr_node_ids pointers to
> mem_cgroup_per_node objects, not the objects themselves.

Ouch! This is 2k per node which is wasted. What a shame I haven't
noticed this back then when reviewing 45cf7ebd5a033 (memcg: reduce the
size of struct memcg 244-fold)

> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Glauber Costa <glommer@openvz.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bf5e894..7f1a356 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -338,7 +338,7 @@ struct mem_cgroup {
>  static size_t memcg_size(void)
>  {
>  	return sizeof(struct mem_cgroup) +
> -		nr_node_ids * sizeof(struct mem_cgroup_per_node);
> +		nr_node_ids * sizeof(struct mem_cgroup_per_node *);
>  }
>  
>  /* internal only representation about the status of kmem accounting. */
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
