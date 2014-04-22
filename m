Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaDVKBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:01:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbaDVKBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:01:06 -0400
Date: Tue, 22 Apr 2014 12:01:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
Message-ID: <20140422100103.GE29311@dhcp22.suse.cz>
References: <cover.1398147734.git.nasa4836@gmail.com>
 <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 14:30:41, Jianyu Zhan wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
> 
> We should not access per-cgroup id directly, since this is implemetation
> detail. Use the accessor css_from_id() instead.
> 
> This patch has no functional change.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.cz>
Thanks!

> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 80d9e38..46333cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -528,10 +528,10 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
>  	/*
> -	 * The ID of the root cgroup is 0, but memcg treat 0 as an
> -	 * invalid ID, so we return (cgroup_id + 1).
> +	 * The ID of css for the root cgroup is 0, but memcg treat 0 as an
> +	 * invalid ID, so we return (id + 1).
>  	 */
> -	return memcg->css.cgroup->id + 1;
> +	return css_to_id(&memcg->css) + 1;
>  }
>  
>  static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> @@ -6407,7 +6407,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
>  
> -	if (css->cgroup->id > MEM_CGROUP_ID_MAX)
> +	if (css_to_id(css) > MEM_CGROUP_ID_MAX)
>  		return -ENOSPC;
>  
>  	if (!parent)
> -- 
> 2.0.0-rc0
> 

-- 
Michal Hocko
SUSE Labs
