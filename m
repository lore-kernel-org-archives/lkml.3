Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3GXOHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:07:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab3GXOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:52 -0400
Date: Wed, 24 Jul 2013 16:07:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/8] cgroup: document how cgroup IDs are assigned
Message-ID: <20130724140751.GE2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <51EFA59B.9070409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA59B.9070409@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 17:59:55, Li Zefan wrote:
> As cgroup id has been used in netprio cgroup and will be used in memcg,
> it's important to make it clear how a cgroup id is allocated.
> 
> For example, in netprio cgroup, the id is used as index of an array.
> 
> Signed-off-by: Li Zefan <lizefan@huwei.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/cgroup.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2bd052d..8c107e9 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -161,7 +161,13 @@ struct cgroup_name {
>  struct cgroup {
>  	unsigned long flags;		/* "unsigned long" so bitops work */
>  
> -	int id;				/* idr allocated in-hierarchy ID */
> +	/*
> +	 * idr allocated in-hierarchy ID.
> +	 *
> +	 * The ID of the root cgroup is always 0, and a new cgroup
> +	 * will be assigned with a smallest available ID.
> +	 */
> +	int id;
>  
>  	/*
>  	 * We link our 'sibling' struct into our parent's 'children'.
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
