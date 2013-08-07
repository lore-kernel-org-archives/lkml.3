Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3HGOQC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:16:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab3HGOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:16:00 -0400
Date: Wed, 7 Aug 2013 15:15:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 1/3] mm: vmscan: fix numa reclaim balance problem in
 kswapd
Message-ID: <20130807141555.GO2296@suse.de>
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org>
 <1375457846-21521-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1375457846-21521-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:37:24AM -0400, Johannes Weiner wrote:
> When the page allocator fails to get a page from all zones in its
> given zonelist, it wakes up the per-node kswapds for all zones that
> are at their low watermark.
> 
> However, with a system under load the free pages in a zone can
> fluctuate enough that the allocation fails but the kswapd wakeup is
> also skipped while the zone is still really close to the low
> watermark.
> 
> When one node misses a wakeup like this, it won't be aged before all
> the other node's zones are down to their low watermarks again.  And
> skipping a full aging cycle is an obvious fairness problem.
> 
> Kswapd runs until the high watermarks are restored, so it should also
> be woken when the high watermarks are not met.  This ages nodes more
> equally and creates a safety margin for the page counter fluctuation.
> 
> By using zone_balanced(), it will now check, in addition to the
> watermark, if compaction requires more order-0 pages to create a
> higher order page.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
