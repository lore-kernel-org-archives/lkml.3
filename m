Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaFWGPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:15:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53582 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaFWGPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:15:16 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 23 Jun 2014 15:16:04 +0900
From: Minchan Kim <minchan@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 1/4] mm: vmscan: remove remains of kswapd-managed
 zone->all_unreclaimable
Message-ID: <20140623061604.GA15594@bbox>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:33:47PM -0400, Johannes Weiner wrote:
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
Acked-by: Minchan Kim <minchan@kernel.org>

It would be not bad to Cced KOSAKI who was involved all_unreclaimable
series several time with me.

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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
