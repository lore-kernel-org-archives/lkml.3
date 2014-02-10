Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBJAlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:41:15 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50351 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBJAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:41:14 -0500
X-AuditID: 9c93017d-b7b1fae00000636d-47-52f82028843c
Date: Mon, 10 Feb 2014 09:41:22 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/compaction: do not call
 suitable_migration_target() on every page
Message-ID: <20140210004122.GB12049@lge.com>
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1391749726-28910-3-git-send-email-iamjoonsoo.kim@lge.com>
 <52F4A90D.20804@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4A90D.20804@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:36:13AM +0100, Vlastimil Babka wrote:
> On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> > suitable_migration_target() checks that pageblock is suitable for
> > migration target. In isolate_freepages_block(), it is called on every
> > page and this is inefficient. So make it called once per pageblock.
> 
> Hmm but in sync compaction, compact_checklock_irqsave() may drop the zone->lock,
> reschedule and reacquire it and thus possibly invalidate your previous check. Async
> compaction is ok as that will quit immediately. So you could probably communicate that
> this happened and invalidate checked_pageblock in such case. Or maybe this would not
> happen too enough to worry about rare suboptimal migrations?

So, the result of previous check can be changed only if *this* pageblock's migratetype
is changed while we drop the lock. I guess that this is really rare event, and,
in this case, this pageblock already has mixed migratetype pages, so it has
no serious problem.

Thanks.
