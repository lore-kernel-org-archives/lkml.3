Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaGAU6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:58:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaGAU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:58:22 -0400
Date: Tue, 1 Jul 2014 21:58:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Improve sequential read throughput v4r8
Message-ID: <20140701205817.GY10819@suse.de>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
 <20140701171611.GB1369@cmpxchg.org>
 <20140701183915.GW10819@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140701183915.GW10819@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:39:15PM +0100, Mel Gorman wrote:
> The fair zone policy itself is partially working against the lowmem
> reserve idea. The point of the lowmem reserve was to preserve the lower
> zones when an upper zone can be used and the fair zone policy breaks
> that. The fair zone policy ignores that and it was never reconciled. The
> dirty page distribution does a different interleaving again and was never
> reconciled with the fair zone policy or lowmem reserves. kswapd itself was
> not using the classzone_idx it actually woken for although in this case
> it may not matter. The end result is that the model is fairly inconsistent
> which makes comparison against it a difficult exercise at best. About all
> that was left was that from a performance perspective that the fair zone
> allocation policy is not doing the right thing for streaming workloads.
> 

The inevitable feedback will be to reconcile those differences so I'm
redid the series and queued it for testing. Patch list currently looks
like

mm: pagemap: Avoid unnecessary overhead when tracepoints are deactivated
mm: Rearrange zone fields into read-only, page alloc, statistics and page reclaim lines
mm: page_alloc: Add ALLOC_DIRTY for dirty page distribution
mm: page_alloc: Only apply the fair zone allocation policy if it's eligible
mm: page_alloc: Only apply either the fair zone or dirty page distribution policy, not both
mm: page_alloc: Reduce cost of the fair zone allocation policy
mm: page_alloc: Reconcile lowmem reserves with fair zone allocation policy
mm: vmscan: Fix oddities with classzone and zone balancing
mm: vmscan: Reconcile balance gap lowmem reclaim with fair zone allocation policy
mm: vmscan: Remove classzone considerations from kswapd decisions

About 13 hours to test for ext3 on the small machine, 3 days for the larger
machine. The test could be accelerated by either reducing the iterations or
the memory size of the machine but that would distort the results too badly.

-- 
Mel Gorman
SUSE Labs
