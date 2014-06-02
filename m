Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaFBJrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:47:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34003 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaFBJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:47:29 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, mhocko@suse.cz, riel@redhat.com,
        hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, cldu@marvell.com,
        nasa4836@gmail.com, handai.szj@taobao.com,
        paul.gortmaker@windriver.com, mpatlasov@parallels.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page-writeback.c: remove outdated comment
Date: Mon,  2 Jun 2014 17:47:20 +0800
Message-Id: <1401702440-1884-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an orphaned prehistoric comment , which used to be against
get_dirty_limits(), the dawn of global_dirtyable_memory().

Back then, the implementation of get_dirty_limits() is complicated and
full of magic numbers, so this comment is necessary. But we now
use the clear and neat global_dirtyable_memory(), which renders this
comment ambiguous and useless. Remove it.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/page-writeback.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a4317da..f2683ac 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -156,24 +156,6 @@ static unsigned long writeout_period_time = 0;
 #define VM_COMPLETIONS_PERIOD_LEN (3*HZ)
 
 /*
- * Work out the current dirty-memory clamping and background writeout
- * thresholds.
- *
- * The main aim here is to lower them aggressively if there is a lot of mapped
- * memory around.  To avoid stressing page reclaim with lots of unreclaimable
- * pages.  It is better to clamp down on writers than to start swapping, and
- * performing lots of scanning.
- *
- * We only allow 1/2 of the currently-unmapped memory to be dirtied.
- *
- * We don't permit the clamping level to fall below 5% - that is getting rather
- * excessive.
- *
- * We make sure that the background writeout level is below the adjusted
- * clamping level.
- */
-
-/*
  * In a memory zone, there is a certain amount of pages we consider
  * available for the page cache, which is essentially the number of
  * free and reclaimable pages, minus some zone reserves to protect
-- 
2.0.0

