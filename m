Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaFWHtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:49:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaFWHtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:49:03 -0400
Date: Mon, 23 Jun 2014 09:49:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mm: vmscan: remove remains of kswapd-managed
 zone->all_unreclaimable
Message-ID: <20140623074900.GB9743@dhcp22.suse.cz>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-06-14 12:33:47, Johannes Weiner wrote:
> shrink_zones() has a special branch to skip the all_unreclaimable()
> check during hibernation, because a frozen kswapd can't mark a zone
> unreclaimable.
> 
> But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
> livelock"), determining a zone to be unreclaimable is done by directly
> looking at its scan history and no longer relies on kswapd setting the
> per-zone flag.
> 
> Remove this branch and let shrink_zones() check the reclaimability of
> the target zones regardless of hibernation state.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

This code is really tricky :/

But the patch looks good to me.
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/vmscan.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0f16ffe8eb67..19b5b8016209 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2534,14 +2534,6 @@ out:
>  	if (sc->nr_reclaimed)
>  		return sc->nr_reclaimed;
>  
> -	/*
> -	 * As hibernation is going on, kswapd is freezed so that it can't mark
> -	 * the zone into all_unreclaimable. Thus bypassing all_unreclaimable
> -	 * check.
> -	 */
> -	if (oom_killer_disabled)
> -		return 0;
> -
>  	/* Aborted reclaim to try compaction? don't OOM, then */
>  	if (aborted_reclaim)
>  		return 1;
> -- 
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
