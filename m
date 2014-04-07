Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaDGOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:40:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaDGOkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:40:15 -0400
Message-ID: <5342B8CC.9020009@suse.cz>
Date: Mon, 07 Apr 2014 16:40:12 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Heesub Shin <heesub.shin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>
Subject: Re: [PATCH 1/2] mm/compaction: clean up unused code lines
References: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com>
In-Reply-To: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:57 AM, Heesub Shin wrote:
> This commit removes code lines currently not in use or never called.
>
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
> Cc: Dongjun Shin <d.j.shin@samsung.com>
> Cc: Sunghwan Yun <sunghwan.yun@samsung.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 10 ----------
>   1 file changed, 10 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 9635083..1ef9144 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -208,12 +208,6 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>   	return true;
>   }
>
> -static inline bool compact_trylock_irqsave(spinlock_t *lock,
> -			unsigned long *flags, struct compact_control *cc)
> -{
> -	return compact_checklock_irqsave(lock, flags, false, cc);
> -}
> -
>   /* Returns true if the page is within a block suitable for migration to */
>   static bool suitable_migration_target(struct page *page)
>   {
> @@ -728,7 +722,6 @@ static void isolate_freepages(struct zone *zone,
>   			continue;
>
>   		/* Found a block suitable for isolating free pages from */
> -		isolated = 0;
>
>   		/*
>   		 * As pfn may not start aligned, pfn+pageblock_nr_page
> @@ -1160,9 +1153,6 @@ static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
>   			if (zone_watermark_ok(zone, cc->order,
>   						low_wmark_pages(zone), 0, 0))
>   				compaction_defer_reset(zone, cc->order, false);
> -			/* Currently async compaction is never deferred. */
> -			else if (cc->sync)
> -				defer_compaction(zone, cc->order);
>   		}
>
>   		VM_BUG_ON(!list_empty(&cc->freepages));
>

