Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3GXOKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3GXOKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:10:47 -0400
Date: Wed, 24 Jul 2013 16:10:45 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 3/8] cgroup: implement cgroup_from_id()
Message-ID: <20130724141045.GF2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
 <51EFA5C7.40504@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EFA5C7.40504@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 18:00:39, Li Zefan wrote:
> This will be used as a replacement for css_lookup().
> 
> There's a difference with cgroup id and css id. cgroup id starts with 0,
> while css id starts with 1.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Typo fix bellow
[...]
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ee3c02e..9b27775 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -5536,6 +5536,22 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
>  	return css ? css : ERR_PTR(-ENOENT);
>  }
>  
> +/**
> + * cgroup_from_id - lookup cgroup by id
> + * @ss: cgroup subsys to be looked into
> + * @id: the cgroup id
> + *
> + * Returns the cgroup is there's valid one with @id, otherwise returns Null.

s/ is / if /

> + * Should be called under rcu_readlock().
> + */
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
> +{
> +	rcu_lockdep_assert(rcu_read_lock_held(),
> +			   "cgroup_from_id() needs rcu_read_lock()"
> +			   " protection");
> +	return idr_find(&ss->root->cgroup_idr, id);
> +}
> +
>  #ifdef CONFIG_CGROUP_DEBUG
>  static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cgrp)
>  {
> -- 
> 1.8.0.2

-- 
Michal Hocko
SUSE Labs
