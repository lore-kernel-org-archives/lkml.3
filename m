Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaLCPWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:22:41 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51386 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaLCPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:22:39 -0500
Date: Wed, 3 Dec 2014 10:22:31 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Message-ID: <20141203152231.GA2822@phnom.home.cmpxchg.org>
References: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 11:41:23PM +0100, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  mm/memcontrol.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d6ac0e3..5edd1fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  }
>  #endif /* CONFIG_NUMA */
>  
> -static inline void mem_cgroup_lru_names_not_uptodate(void)
> -{
> -	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> -}

That assertion doesn't work in an unused function, but we still want
this check.  Please move the BUILD_BUG_ON() to the beginning of
memcg_stat_show() instead.
