Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaFKAdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:33:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43915 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaFKAdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:33:24 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 11 Jun 2014 09:33:23 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 01/10] mm, compaction: do not recheck
 suitable_migration_target under lock
Message-ID: <20140611003322.GB15630@bbox>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:26:13AM +0200, Vlastimil Babka wrote:
> isolate_freepages_block() rechecks if the pageblock is suitable to be a target
> for migration after it has taken the zone->lock. However, the check has been
> optimized to occur only once per pageblock, and compact_checklock_irqsave()
> might be dropping and reacquiring lock, which means somebody else might have
> changed the pageblock's migratetype meanwhile.
> 
> Furthermore, nothing prevents the migratetype to change right after
> isolate_freepages_block() has finished isolating. Given how imperfect this is,
> it's simpler to just rely on the check done in isolate_freepages() without
> lock, and not pretend that the recheck under lock guarantees anything. It is
> just a heuristic after all.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
