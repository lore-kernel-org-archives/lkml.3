Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3FOLHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:07:31 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47058 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3FOLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:05:47 -0400
Message-ID: <51BC4A83.50302@gmail.com>
Date: Sat, 15 Jun 2013 19:05:39 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Add unlikely for current_order test
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Since we have an unlikely for the "current_order >= pageblock_order / 2"
test above, adding an unlikely for this "current_order >= pageblock_order"
test seems more appropriate.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..1b6d7de 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1071,7 +1071,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			rmv_page_order(page);
 
 			/* Take ownership for orders >= pageblock_order */
-			if (current_order >= pageblock_order &&
+			if (unlikely(current_order >= pageblock_order) &&
 			    !is_migrate_cma(migratetype))
 				change_pageblock_range(page, current_order,
 							start_migratetype);
-- 
1.7.1
