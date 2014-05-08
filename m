Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaEHIwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:52:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaEHIv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:51:56 -0400
Date: Thu, 8 May 2014 09:51:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yong-Taek Lee <ytk.lee@samsung.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: DEBUG_VM checks for free_list
 placement of CMA and RESERVE pages
Message-ID: <20140508085148.GK23991@suse.de>
References: <533D8015.1000106@suse.cz>
 <1396539618-31362-1-git-send-email-vbabka@suse.cz>
 <1396539618-31362-2-git-send-email-vbabka@suse.cz>
 <53616F39.2070001@oracle.com>
 <53638ADA.5040200@suse.cz>
 <5367A1E5.2020903@oracle.com>
 <5367B356.1030403@suse.cz>
 <20140507013333.GB26212@bbox>
 <536A4A3B.1090403@suse.cz>
 <20140508055421.GC9161@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140508055421.GC9161@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 02:54:21PM +0900, Joonsoo Kim wrote:
> > >> Furthermore, I think there's a problem that
> > >> setup_zone_migrate_reserve() operates on pageblocks, but as MAX_ODER
> > >> is higher than pageblock_order, RESERVE pages might be merged with
> > >> buddies of different migratetype and end up on their free_list. That
> > >> seems to me like a flaw in the design of reserves, but perhaps
> > >> others won't think it's serious enough to fix?
> 
> I wanna know who want MIGRATE_RESERVE. On my previous testing, one
> pageblock for MIGRATE_RESERVE is merged with buddies of different
> migratetype during boot-up and never come back again. But my system works
> well. :)
> 

It's important for short-lived high-order atomic allocations.
MIGRATE_RESERVE preserves a property of the buddy allocator prior to the
merging of fragmentation avoidance. Most users will not notice as not
many drivers depend on these allocations working. If they are getting
destroyed at boot-up, it's a bug.

-- 
Mel Gorman
SUSE Labs
