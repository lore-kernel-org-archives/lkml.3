Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbbAMOu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:50:58 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40018 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbAMOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:50:57 -0500
Date: Tue, 13 Jan 2015 15:50:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: remove unnecessary soft limit tree
 node test
Message-ID: <20150113145053.GG25318@dhcp22.suse.cz>
References: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-01-15 21:13:59, Johannes Weiner wrote:
> kzalloc_node() automatically falls back to nodes with suitable memory.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fd9e542fc26f..aad254b30708 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4520,13 +4520,10 @@ static void __init mem_cgroup_soft_limit_tree_init(void)
>  {
>  	struct mem_cgroup_tree_per_node *rtpn;
>  	struct mem_cgroup_tree_per_zone *rtpz;
> -	int tmp, node, zone;
> +	int node, zone;
>  
>  	for_each_node(node) {
> -		tmp = node;
> -		if (!node_state(node, N_NORMAL_MEMORY))
> -			tmp = -1;
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
>  		BUG_ON(!rtpn);
>  
>  		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs
