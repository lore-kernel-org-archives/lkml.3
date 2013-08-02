Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3HBCIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:08:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62998 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3HBCIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:08:02 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-4d-51fb1481f775
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/4] mm, page_alloc: add likely macro to help compiler optimization
Date: Fri,  2 Aug 2013 11:07:56 +0900
Message-Id: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rarely allocate a page with ALLOC_NO_WATERMARKS and it is used
in slow path. For making fast path more faster, add likely macro to
help compiler optimization.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..86ad44b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1901,7 +1901,7 @@ zonelist_scan:
 			goto this_zone_full;
 
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
+		if (likely(!(alloc_flags & ALLOC_NO_WATERMARKS))) {
 			unsigned long mark;
 			int ret;
 
-- 
1.7.9.5

