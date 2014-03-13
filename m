Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaCMOZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:25:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaCMOZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:25:44 -0400
Date: Thu, 13 Mar 2014 14:25:40 +0000
From: Mel Gorman <mgorman@suse.de>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v2] mm/page_alloc: fix freeing of MIGRATE_RESERVE
 migratetype pages
Message-ID: <20140313142540.GQ10663@suse.de>
References: <42197912.c6v2hLDCey@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <42197912.c6v2hLDCey@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 07:34:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Pages allocated from MIGRATE_RESERVE migratetype pageblocks
> are not freed back to MIGRATE_RESERVE migratetype free
> lists in free_pcppages_bulk()->__free_one_page() if we got
> to free_pcppages_bulk() through drain_[zone_]pages().
> The freeing through free_hot_cold_page() is okay because
> freepage migratetype is set to pageblock migratetype before
> calling free_pcppages_bulk().  If pages of MIGRATE_RESERVE
> migratetype end up on the free lists of other migratetype
> whole Reserved pageblock may be later changed to the other
> migratetype in __rmqueue_fallback() and it will be never
> changed back to be a Reserved pageblock.  Fix the issue by
> preserving freepage migratetype as a pageblock migratetype
> (instead of overriding it to the requested migratetype)
> for MIGRATE_RESERVE migratetype pages in rmqueue_bulk().
> 
> The problem was introduced in v2.6.31 by commit ed0ae21
> ("page allocator: do not call get_pageblock_migratetype()
> more than necessary").
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Hugh Dickins <hughd@google.com>

It's a pity about the unconditional pageblock lookup in that path but I
didn't see a better way around it so

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
