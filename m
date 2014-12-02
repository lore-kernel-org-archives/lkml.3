Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaLBLsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:48:33 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52137 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLBLsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:48:31 -0500
Date: Tue, 2 Dec 2014 12:48:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Michele Curti <michele.curti@gmail.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix defined but not used compiler warning
Message-ID: <20141202114827.GE27014@dhcp22.suse.cz>
References: <20141202110752.GA11327@powerline.azcom-win.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202110752.GA11327@powerline.azcom-win.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-12-14 12:07:52, Michele Curti wrote:
> test_mem_cgroup_node_reclaimable is used only when MAX_NUMNODES > 1,
> so move it into the compiler if statement
> 
> Signed-off-by: Michele Curti <michele.curti@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c6ac50e..84531a9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
>  			 NULL, "Memory cgroup out of memory");
>  }
> +#if MAX_NUMNODES > 1
>  
>  /**
>   * test_mem_cgroup_node_reclaimable
> @@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>  	return false;
>  
>  }
> -#if MAX_NUMNODES > 1
>  
>  /*
>   * Always updating the nodemask is not very good - even if we have an empty
> -- 
> 2.1.3
> 

-- 
Michal Hocko
SUSE Labs
