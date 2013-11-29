Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3K2Jp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:45:56 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61498 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3K2Jpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:45:52 -0500
Date: Fri, 29 Nov 2013 10:45:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: make memcg_update_cache_sizes() static
Message-ID: <20131129094549.GE25893@dhcp22.suse.cz>
References: <1385567162-14973-1-git-send-email-vdavydov@parallels.com>
 <1385567162-14973-2-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385567162-14973-2-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-11-13 19:46:02, Vladimir Davydov wrote:
> This function is not used outside of memcontrol.c so make it static.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 40efb9d..b20b915 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3084,7 +3084,7 @@ int memcg_cache_id(struct mem_cgroup *memcg)
>   * But when we create a new cache, we can call this as well if its parent
>   * is kmem-limited. That will have to hold set_limit_mutex as well.
>   */
> -int memcg_update_cache_sizes(struct mem_cgroup *memcg)
> +static int memcg_update_cache_sizes(struct mem_cgroup *memcg)
>  {
>  	int num, ret;
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
