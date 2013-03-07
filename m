Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3CGIV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:21:27 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44378 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3CGIV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:21:26 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-c9-51384e0353d9
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: page_alloc: remove branch operation in free_pages_prepare()
Date: Thu,  7 Mar 2013 17:21:20 +0900
Message-Id: <1362644480-18381-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we found that the flag has a bit of PAGE_FLAGS_CHECK_AT_PREP,
we reset the flag. If we always reset the flag, we can reduce one
branch operation. So remove it.

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8fcced7..778f2a9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -614,8 +614,7 @@ static inline int free_pages_check(struct page *page)
 		return 1;
 	}
 	page_nid_reset_last(page);
-	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
-		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
 }
 
-- 
1.7.9.5

