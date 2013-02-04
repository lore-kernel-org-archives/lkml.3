Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3BDXoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:44:01 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42983 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3BDXoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:44:00 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-a3-511047be3563
Date: Tue, 5 Feb 2013 08:43:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high
 memory
Message-ID: <20130204234358.GB2610@blaptop>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
 <20130204150657.6d05f76a.akpm@linux-foundation.org>
 <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 05, 2013 at 08:29:26AM +0900, Kyungmin Park wrote:
> On Tue, Feb 5, 2013 at 8:06 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 04 Feb 2013 11:27:05 +0100
> > Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> >> The total number of low memory pages is determined as
> >> totalram_pages - totalhigh_pages, so without this patch all CMA
> >> pageblocks placed in highmem were accounted to low memory.
> >
> > What are the end-user-visible effects of this bug?
> 
> Even though CMA is located at highmem. LowTotal has more than lowmem
> address spaces.
> 
> e.g.,
> lowmem  : 0xc0000000 - 0xdf000000   ( 496 MB)
> LowTotal:         555788 kB
> 
> >
> > (This information is needed so that others can make patch-scheduling
> > decisions and should be included in all bugfix changelogs unless it is
> > obvious).
> 
> CMA Highmem support is new feature. so don't need to go stable tree.

I would like to clarify it because I remembered alloc_migrate_target have considered
CMA pages could be highmem. Is it really new feature? If so, could you point out
enabling patches for the new feature?

struct page *alloc_migrate_target(struct page *page, unsigned long private,
                                  int **resultp)
{
        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;

        if (PageHighMem(page))
                gfp_mask |= __GFP_HIGHMEM;

        return alloc_page(gfp_mask);
}

Thanks.

> 
> Thank you,
> Kyungmin Park
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
