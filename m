Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaLGKdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:33:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49664 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaLGKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:33:13 -0500
Date: Sun, 7 Dec 2014 11:33:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable()
 when no MAX_NUMNODES or not more than 1
Message-ID: <20141207103310.GJ15892@dhcp22.suse.cz>
References: <5482316D.607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5482316D.607@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this has been fixed last week already
http://marc.info/?l=linux-mm&m=141751847710864&w=2

On Sat 06-12-14 06:27:57, Chen Gang wrote:
> test_mem_cgroup_node_reclaimable() is only used when "MAX_NUMNODES > 1",
> so move it into related quote.
> 
> The related warning (with allmodconfig under parisc):
> 
>     CC      mm/memcontrol.o
>   mm/memcontrol.c:1629:13: warning: 'test_mem_cgroup_node_reclaimable' defined but not used [-Wunused-function]
>    static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>                ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c6ac50e..d538b08 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1616,6 +1616,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  			 NULL, "Memory cgroup out of memory");
>  }
>  
> +#if MAX_NUMNODES > 1
>  /**
>   * test_mem_cgroup_node_reclaimable
>   * @memcg: the target memcg
> @@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
>  	return false;
>  
>  }
> -#if MAX_NUMNODES > 1
>  
>  /*
>   * Always updating the nodemask is not very good - even if we have an empty
> -- 
> 1.9.3

-- 
Michal Hocko
SUSE Labs
