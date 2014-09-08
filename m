Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaIHMvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:51:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaIHMvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:51:40 -0400
Date: Mon, 8 Sep 2014 13:51:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: page_alloc: fix zone allocation fairness on UP
Message-ID: <20140908125135.GM17501@suse.de>
References: <1410179751-28115-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1410179751-28115-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 08:35:51AM -0400, Johannes Weiner wrote:
> The zone allocation batches can easily underflow due to higher-order
> allocations or spills to remote nodes.  On SMP that's fine, because
> underflows are expected from concurrency and dealt with by returning
> 0.  But on UP, zone_page_state will just return a wrapped unsigned
> long, which will get past the <= 0 check and then consider the zone
> eligible until its watermarks are hit.
> 
> 3a025760fc15 ("mm: page_alloc: spill to remote nodes before waking
> kswapd") already made the counter-resetting use atomic_long_read() to
> accomodate underflows from remote spills, but it didn't go all the way
> with it.  Make it clear that these batches are expected to go negative
> regardless of concurrency, and use atomic_long_read() everywhere.
> 
> Fixes: 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: "3.12+" <stable@kernel.org>

This is better than changing the behaviour of zone_page_state().

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
