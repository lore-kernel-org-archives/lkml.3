Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaJTTpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:45:10 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53711 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaJTTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:45:09 -0400
Date: Mon, 20 Oct 2014 21:45:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: clarify migration where old page is
 uncharged
Message-ID: <20141020194505.GE505@dhcp22.suse.cz>
References: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413732647-16043-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 19-10-14 11:30:47, Johannes Weiner wrote:
> Better explain re-entrant migration when compaction races with
> reclaim, and also mention swapcache readahead pages as possible
> uncharged migration sources.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fc1d7ca96b9d..76892eb89d26 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6166,7 +6166,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (PageCgroupUsed(pc))
>  		return;
>  
> -	/* Re-entrant migration: old page already uncharged? */
> +	/*
> +	 * Swapcache readahead pages can get migrated before being
> +	 * charged, and migration from compaction can happen to an
> +	 * uncharged page when the PFN walker finds a page that
> +	 * reclaim just put back on the LRU but has not released yet.
> +	 */
>  	pc = lookup_page_cgroup(oldpage);
>  	if (!PageCgroupUsed(pc))
>  		return;
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
