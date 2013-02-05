Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3BEHeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:34:31 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60374 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3BEHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:34:30 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-70-5110b604503d
Date: Tue, 5 Feb 2013 16:34:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, kyungmin.park@samsung.com
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-ID: <20130205073428.GA11197@blaptop>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204233430.GA2610@blaptop>
 <5110B05B.5070109@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110B05B.5070109@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Feb 05, 2013 at 08:10:19AM +0100, Marek Szyprowski wrote:
> Hello,
> 
> On 2/5/2013 12:34 AM, Minchan Kim wrote:
> >On Mon, Feb 04, 2013 at 11:27:05AM +0100, Marek Szyprowski wrote:
> >> The total number of low memory pages is determined as
> >> totalram_pages - totalhigh_pages, so without this patch all CMA
> >> pageblocks placed in highmem were accounted to low memory.
> >
> >So what's the end user effect? With the effect, we have to decide
> >routing it on stable.
> >
> >>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> ---
> >>  mm/page_alloc.c |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index f5bab0a..6415d93 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(struct page *page)
> >>  	set_pageblock_migratetype(page, MIGRATE_CMA);
> >>  	__free_pages(page, pageblock_order);
> >>  	totalram_pages += pageblock_nr_pages;
> >> +#ifdef CONFIG_HIGHMEM
> >
> >We don't need #ifdef/#endif.
> 
> #ifdef is required to let this code compile when highmem is not enabled,
> becuase totalhigh_pages is defined as 0, see include/linux/highmem.h

Argh, Sorry for the noise.
I think it would be better to use accessor but it's a just nitpick. :)
Thanks!

> 
> >> +	if (PageHighMem(page))
> >> +		totalhigh_pages += pageblock_nr_pages;
> >> +#endif
> >>  }
> >>  #endif
> >>
> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
