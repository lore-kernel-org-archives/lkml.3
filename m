Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaFCNQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:16:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaFCNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:16:39 -0400
Date: Tue, 3 Jun 2014 15:16:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/10] mm: memcontrol: reclaim at least once for
 __GFP_NORETRY
Message-ID: <20140603131635.GH1321@dhcp22.suse.cz>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
 <1401380162-24121-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401380162-24121-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29-05-14 12:15:56, Johannes Weiner wrote:
> Currently, __GFP_NORETRY tries charging once and gives up before even
> trying to reclaim.  Bring the behavior on par with the page allocator
> and reclaim at least once before giving up.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8d5075c081f..8957d6c945b8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2614,13 +2614,13 @@ retry:
>  	if (!(gfp_mask & __GFP_WAIT))
>  		goto nomem;
>  
> -	if (gfp_mask & __GFP_NORETRY)
> -		goto nomem;
> -
>  	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= batch)
>  		goto retry;
> +
> +	if (gfp_mask & __GFP_NORETRY)
> +		goto nomem;
>  	/*
>  	 * Even though the limit is exceeded at this point, reclaim
>  	 * may have been able to free some pages.  Retry the charge
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
