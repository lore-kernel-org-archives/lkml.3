Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3LRTmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:42:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3LRTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:42:07 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/6] mm: page_alloc: Document why NR_ALLOC_BATCH is always updated
Date: Wed, 18 Dec 2013 19:41:59 +0000
Message-Id: <1387395723-25391-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387395723-25391-1-git-send-email-mgorman@suse.de>
References: <1387395723-25391-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Needs-signed-off
---
 mm/page_alloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f861d02..61e9e8c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1547,7 +1547,15 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
+	/*
+	 * All allocations eat into the round-robin batch, even
+	 * allocations that are not subject to round-robin placement
+	 * themselves.  This makes sure that allocations that ARE
+	 * subject to round-robin placement compensate for the
+	 * allocations that aren't, to have equal placement overall.
+	 */
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
-- 
1.8.4

