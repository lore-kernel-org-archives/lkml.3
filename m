Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LLPe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:34:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3LLPe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:34:26 -0500
Date: Thu, 12 Dec 2013 15:34:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] Configurable fair allocation zone policy
Message-ID: <20131212153422.GJ11295@suse.de>
References: <1386860779-2301-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386860779-2301-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:06:15PM +0000, Mel Gorman wrote:
> Commit 81c0a2bb ("mm: page_alloc: fair zone allocator policy") solved a
> bug whereby new pages could be reclaimed before old pages because of how
> the page allocator and kswapd interacted on the per-zone LRU lists.
> 
> Unfortunately a side-effect missed during review was that it's now very
> easy to allocate remote memory on NUMA machines. The problem is that
> it is not a simple case of just restoring local allocation policies as
> there are genuine reasons why global page aging may be prefereable. It's
> still a major change to default behaviour so this patch makes the policy
> configurable and sets what I think is a sensible default.
> 
> The patches are on top of some NUMA balancing patches currently in -mm.
> The first patch in the series is a patch posted by Johannes that must be
> taken into account before any of my patches on top. The last patch of the
> series is what alters default behaviour and makes the fair zone allocator
> policy configurable.
> 
> Sniff test results based on following kernels
> 
> vanilla		 3.13-rc3 stock
> instrument-v5r1  NUMA balancing patches just to rule out any conflicts there
> lruslabonly-v1r2 Patch 1 only
> local-v1r2	 Full series
> 

These figures need to be redone. The instrument-v5r1 and later kernels
included a debugging patch that increases migration rates to trigger
another bug. The figures of local-v1r2 relative to instrument-v5r1 are
fine but not relative to 3.13.0-rc3-vanilla

-- 
Mel Gorman
SUSE Labs
