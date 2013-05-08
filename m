Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3EHQLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:11:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab3EHQDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:15 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/22] mm: page allocator: Do not lookup the pageblock migratetype during allocation
Date: Wed,  8 May 2013 17:02:52 +0100
Message-Id: <1368028987-8369-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pageblock migrate type is checked during allocation in case it's CMA
but using get_freepage_migratetype() should be sufficient as the
magazines would have been drained prior to a CMA allocation attempt.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f74e16f..8867937 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1523,7 +1523,7 @@ again:
 		if (!page)
 			goto failed;
 		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_pageblock_migratetype(page));
+					  get_freepage_migratetype(page));
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
-- 
1.8.1.4

