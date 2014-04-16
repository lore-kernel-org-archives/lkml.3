Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaDPXm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:42:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32931 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaDPXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:42:24 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 17 Apr 2014 08:43:09 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/2] mm/compaction: make isolate_freepages start at
 pageblock boundary
Message-ID: <20140416234309.GE27534@bbox>
References: <5342BA34.8050006@suse.cz>
 <1397553507-15330-1-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397553507-15330-1-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:18:26AM +0200, Vlastimil Babka wrote:
> The compaction freepage scanner implementation in isolate_freepages() starts
> by taking the current cc->free_pfn value as the first pfn. In a for loop, it
> scans from this first pfn to the end of the pageblock, and then subtracts
> pageblock_nr_pages from the first pfn to obtain the first pfn for the next
> for loop iteration.
> 
> This means that when cc->free_pfn starts at offset X rather than being aligned
> on pageblock boundary, the scanner will start at offset X in all scanned
> pageblock, ignoring potentially many free pages. Currently this can happen when
> a) zone's end pfn is not pageblock aligned, or
> b) through zone->compact_cached_free_pfn with CONFIG_HOLES_IN_ZONE enabled and
>    a hole spanning the beginning of a pageblock
> 
> This patch fixes the problem by aligning the initial pfn in isolate_freepages()
> to pageblock boundary. This also allows to replace the end-of-pageblock
> alignment within the for loop with a simple pageblock_nr_pages increment.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Heesub Shin <heesub.shin@samsung.com>

Acked-by: Minchan Kim <minchan@kernel.org>

-stable stuff?

-- 
Kind regards,
Minchan Kim
