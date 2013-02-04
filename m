Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BDXed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:34:33 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51405 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3BDXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:34:32 -0500
X-AuditID: 9c930179-b7c24ae00000119c-34-51104586db81
Date: Tue, 5 Feb 2013 08:34:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-ID: <20130204233430.GA2610@blaptop>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 11:27:05AM +0100, Marek Szyprowski wrote:
> The total number of low memory pages is determined as
> totalram_pages - totalhigh_pages, so without this patch all CMA
> pageblocks placed in highmem were accounted to low memory.

So what's the end user effect? With the effect, we have to decide
routing it on stable.

> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  mm/page_alloc.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f5bab0a..6415d93 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(struct page *page)
>  	set_pageblock_migratetype(page, MIGRATE_CMA);
>  	__free_pages(page, pageblock_order);
>  	totalram_pages += pageblock_nr_pages;
> +#ifdef CONFIG_HIGHMEM

We don't need #ifdef/#endif.

> +	if (PageHighMem(page))
> +		totalhigh_pages += pageblock_nr_pages;
> +#endif
>  }
>  #endif
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
