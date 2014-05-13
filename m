Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbaEMJqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:46:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbaEMJqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:46:12 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 15/19] mm: Do not use atomic operations when releasing pages
Date: Tue, 13 May 2014 10:45:46 +0100
Message-Id: <1399974350-11089-16-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no references to it any more and a parallel mark should
not be reordered against us. Use non-locked varient to clear page active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index f2228b7..7a5bdd7 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -854,7 +854,7 @@ void release_pages(struct page **pages, int nr, bool cold)
 		}
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
-		ClearPageActive(page);
+		__ClearPageActive(page);
 
 		list_add(&page->lru, &pages_to_free);
 	}
-- 
1.8.4.5

