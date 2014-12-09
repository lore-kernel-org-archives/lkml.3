Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaLIJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:47:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaLIJrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:47:22 -0500
Date: Tue, 9 Dec 2014 09:47:18 +0000
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 2/3] mm: more aggressive page stealing for UNMOVABLE
 allocations
Message-ID: <20141209094718.GA21903@suse.de>
References: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
 <1417713178-10256-3-git-send-email-vbabka@suse.cz>
 <20141209030939.GD3358@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20141209030939.GD3358@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 12:09:40PM +0900, Minchan Kim wrote:
> On Thu, Dec 04, 2014 at 06:12:57PM +0100, Vlastimil Babka wrote:
> > When allocation falls back to stealing free pages of another migratetype,
> > it can decide to steal extra pages, or even the whole pageblock in order to
> > reduce fragmentation, which could happen if further allocation fallbacks
> > pick a different pageblock. In try_to_steal_freepages(), one of the situations
> > where extra pages are stolen happens when we are trying to allocate a
> > MIGRATE_RECLAIMABLE page.
> > 
> > However, MIGRATE_UNMOVABLE allocations are not treated the same way, although
> > spreading such allocation over multiple fallback pageblocks is arguably even
> > worse than it is for RECLAIMABLE allocations. To minimize fragmentation, we
> > should minimize the number of such fallbacks, and thus steal as much as is
> > possible from each fallback pageblock.
> 
> Fair enough.
> 

Just to be absolutly sure, check that data and see what the number of
MIGRATE_UNMOVABLE blocks looks like over time. Make sure it's not just
continually growing. MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE blocks were
expected to be freed if the system was aggressively reclaimed but the same
is not be true of MIGRATE_UNMOVABLE. Even if all processes are
aggressively reclaimed for example, the page tables are still there.

-- 
Mel Gorman
SUSE Labs
