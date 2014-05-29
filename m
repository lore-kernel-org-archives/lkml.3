Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbaE2Gel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:34:41 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46163 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbaE2Gej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:34:39 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 29 May 2014 15:35:05 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] CMA: use MIGRATE_SYNC in alloc_contig_range()
Message-ID: <20140529063505.GH10092@bbox>
References: <1401344750-3684-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401344750-3684-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:25:50PM +0900, Joonsoo Kim wrote:
> Before commit 'mm, compaction: embed migration mode in compact_control'
> from David is merged, alloc_contig_range() used sync migration,
> instead of sync_light migration. This doesn't break anything currently
> because page isolation doesn't have any difference with sync and
> sync_light, but it could in the future, so change back as it was.
> 
> And pass cc->mode to migrate_pages(), instead of passing MIGRATE_SYNC
> to migrate_pages().
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Hello Joonsoo,

Please Ccing me if you send patch related to CMA mm part.
I have reviewed/fixed mm part of CMA for a long time so worth to Cced
although I always don't have a time to look at it. :)

Thanks.

> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7f97767..97c4185 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6262,7 +6262,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>  		cc->nr_migratepages -= nr_reclaimed;
>  
>  		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
> -				    NULL, 0, MIGRATE_SYNC, MR_CMA);
> +				    NULL, 0, cc->mode, MR_CMA);
>  	}
>  	if (ret < 0) {
>  		putback_movable_pages(&cc->migratepages);
> @@ -6301,7 +6301,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>  		.nr_migratepages = 0,
>  		.order = -1,
>  		.zone = page_zone(pfn_to_page(start)),
> -		.mode = MIGRATE_SYNC_LIGHT,
> +		.mode = MIGRATE_SYNC,
>  		.ignore_skip_hint = true,
>  	};
>  	INIT_LIST_HEAD(&cc.migratepages);
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
