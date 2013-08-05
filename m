Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3HELfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 07:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab3HELfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:35:11 -0400
Date: Mon, 5 Aug 2013 13:34:23 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@surriel.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
Message-ID: <20130805113423.GB6703@redhat.com>
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org>
 <1375457846-21521-4-git-send-email-hannes@cmpxchg.org>
 <20130805103456.GB1039@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805103456.GB1039@hacker.(null)>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:34:56PM +0800, Wanpeng Li wrote:
> Why round robin allocator don't consume ZONE_DMA?

I guess lowmem reserve reserves it all, 4GB/256(ratio)=16MB.

The only way to relax it would be 1) to account depending on memblock
types and allow only the movable ones to bypass the lowmem reserve and
prevent a change from movable type if lowmem reserve doesn't pass, 2)
use memory migration to move the movable pages from the lower zones to
the highest zone if reclaim fails if __GFP_DMA32 or __GFP_DMA is set,
or highmem is missing on 32bit kernels. The last point involving
memory migration would work similarly to compaction but it isn't black
and white, and it would cost CPU as well. The memory used by the
simple lowmem reserve mechanism is probably not significant enough to
warrant such an effort.
