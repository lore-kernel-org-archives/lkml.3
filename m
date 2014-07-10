Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaGJMJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:09:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53082 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbaGJMJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:09:01 -0400
Date: Thu, 10 Jul 2014 08:08:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: Move zone->pages_scanned into a vmstat counter
Message-ID: <20140710120857.GK29639@cmpxchg.org>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404893588-21371-4-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:13:05AM +0100, Mel Gorman wrote:
> zone->pages_scanned is a write-intensive cache line during page reclaim
> and it's also updated during page free. Move the counter into vmstat to
> take advantage of the per-cpu updates and do not update it in the free
> paths unless necessary.
> 
> On a small UMA machine running tiobench the difference is marginal. On a
> 4-node machine the overhead is more noticable. Note that automatic NUMA
> balancing was disabled for this test as otherwise the system CPU overhead
> is unpredictable.
> 
>           3.16.0-rc3  3.16.0-rc3  3.16.0-rc3
>              vanillarearrange-v5   vmstat-v5
> User          746.94      759.78      774.56
> System      65336.22    58350.98    32847.27
> Elapsed     27553.52    27282.02    27415.04
> 
> Note that the overhead reduction will vary depending on where exactly
> pages are allocated and freed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
