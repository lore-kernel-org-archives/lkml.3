Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3GVRBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:01:25 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50718 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab3GVRBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:01:23 -0400
Date: Mon, 22 Jul 2013 13:01:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zlatko Calusic <zcalusic@bitsync.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] mm: improve page aging fairness between zones/nodes
Message-ID: <20130722170112.GE715@cmpxchg.org>
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org>
 <51ED6274.3000509@bitsync.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED6274.3000509@bitsync.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zlatko,

On Mon, Jul 22, 2013 at 06:48:52PM +0200, Zlatko Calusic wrote:
> On 19.07.2013 22:55, Johannes Weiner wrote:
> >The way the page allocator interacts with kswapd creates aging
> >imbalances, where the amount of time a userspace page gets in memory
> >under reclaim pressure is dependent on which zone, which node the
> >allocator took the page frame from.
> >
> >#1 fixes missed kswapd wakeups on NUMA systems, which lead to some
> >    nodes falling behind for a full reclaim cycle relative to the other
> >    nodes in the system
> >
> >#3 fixes an interaction where kswapd and a continuous stream of page
> >    allocations keep the preferred zone of a task between the high and
> >    low watermark (allocations succeed + kswapd does not go to sleep)
> >    indefinitely, completely underutilizing the lower zones and
> >    thrashing on the preferred zone
> >
> >These patches are the aging fairness part of the thrash-detection
> >based file LRU balancing.  Andrea recommended to submit them
> >separately as they are bugfixes in their own right.
> >
> 
> I have the patch applied and under testing. So far, so good. It
> looks like it could finally fix the bug that I was chasing few
> months ago (nicely described in your bullet #3). But, few more days
> of testing will be needed before I can reach a quality verdict.

I should have remembered that you talked about this problem... Thanks
a lot for testing!

May I ask for the zone layout of your test machine(s)?  I.e. how many
nodes if NUMA, how big Normal and DMA32 (on Node 0) are.
