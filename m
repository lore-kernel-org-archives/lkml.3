Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaEXNHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:07:04 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:59069 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaEXNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:07:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIJAKOYgFNbtALU/2dsb2JhbABagwerGAUBgzyUToEEF3SCUy8jgRo3iEYB128XhVWIJlcdhCoEjz+KNIsXiBCDOjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] lib/debugobjects.c: add pr_fmt to logging
Date: Sat, 24 May 2014 15:06:55 +0200
Message-Id: <1400936815-24956-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ODEBUG: prefix to pr_fmt

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/debugobjects.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index ea4c737..b628247 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -7,6 +7,9 @@
  *
  * For licencing details see kernel-base/COPYING
  */
+
+#define pr_fmt(fmt) "ODEBUG: " fmt
+
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
@@ -218,7 +221,7 @@ static void debug_objects_oom(void)
 	unsigned long flags;
 	int i;
 
-	pr_warn("ODEBUG: Out of memory. ODEBUG disabled\n");
+	pr_warn("Out of memory. ODEBUG disabled\n");
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		raw_spin_lock_irqsave(&db->lock, flags);
@@ -292,9 +295,9 @@ static void debug_object_is_on_stack(void *addr, int onstack)
 
 	limit++;
 	if (is_on_stack)
-		pr_warn("ODEBUG: object is on stack, but not annotated\n");
+		pr_warn("object is on stack, but not annotated\n");
 	else
-		pr_warn("ODEBUG: object is not on stack, but annotated\n");
+		pr_warn("object is not on stack, but annotated\n");
 	WARN_ON(1);
 }
 
@@ -983,7 +986,7 @@ static void __init debug_objects_selftest(void)
 	if (check_results(&obj, ODEBUG_STATE_NONE, ++fixups, ++warnings))
 		goto out;
 #endif
-	pr_info("ODEBUG: selftest passed\n");
+	pr_info("selftest passed\n");
 
 out:
 	debug_objects_fixups = oldfixups;
@@ -1088,7 +1091,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		if (obj_cache)
 			kmem_cache_destroy(obj_cache);
-		pr_warn("ODEBUG: out of memory.\n");
+		pr_warn("out of memory.\n");
 	} else
 		debug_objects_selftest();
 }
-- 
1.8.4.5

