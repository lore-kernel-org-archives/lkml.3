Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3BDH5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:57:38 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:54782 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3BDH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:57:37 -0500
Date: Mon, 4 Feb 2013 08:57:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: stop warning on memcg_propagate_kmem
Message-ID: <20130204075732.GA2556@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302032023280.4611@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-13 20:29:01, Hugh Dickins wrote:
> Whilst I run the risk of a flogging for disloyalty to the Lord of Sealand,
> I do have CONFIG_MEMCG=y CONFIG_MEMCG_KMEM not set, and grow tired of the
> "mm/memcontrol.c:4972:12: warning: `memcg_propagate_kmem' defined but not
> used [-Wunused-function]" seen in 3.8-rc: move the #ifdef outwards.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Hmm, if you are not too tired then moving the function downwards to
where it is called (memcg_init_kmem) will reduce the number of ifdefs.
But this can wait for a bigger clean up which is getting due:
git grep "def.*CONFIG_MEMCG_KMEM" mm/memcontrol.c | wc -l
12

Thanks
> ---
> 
>  mm/memcontrol.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 3.8-rc6/mm/memcontrol.c	2012-12-22 09:43:27.628015582 -0800
> +++ linux/mm/memcontrol.c	2013-02-02 16:56:06.188325771 -0800
> @@ -4969,6 +4969,7 @@ out:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  static int memcg_propagate_kmem(struct mem_cgroup *memcg)
>  {
>  	int ret = 0;
> @@ -4977,7 +4978,6 @@ static int memcg_propagate_kmem(struct m
>  		goto out;
>  
>  	memcg->kmem_account_flags = parent->kmem_account_flags;
> -#ifdef CONFIG_MEMCG_KMEM
>  	/*
>  	 * When that happen, we need to disable the static branch only on those
>  	 * memcgs that enabled it. To achieve this, we would be forced to
> @@ -5003,10 +5003,10 @@ static int memcg_propagate_kmem(struct m
>  	mutex_lock(&set_limit_mutex);
>  	ret = memcg_update_cache_sizes(memcg);
>  	mutex_unlock(&set_limit_mutex);
> -#endif
>  out:
>  	return ret;
>  }
> +#endif /* CONFIG_MEMCG_KMEM */
>  
>  /*
>   * The user of this function is...

-- 
Michal Hocko
SUSE Labs
