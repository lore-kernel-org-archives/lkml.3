Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3CRXU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 19:20:56 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:37676 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CRXUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 19:20:55 -0400
Message-ID: <1363648854.1774.16.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 1/3] rbtree_test: use pr_info for module prefix in messages
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Mar 2013 16:20:54 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides nicer message output. Since it seems more appropriate
for the nature of this module, also use KERN_INFO instead of other
levels.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 lib/rbtree_test.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
index af38aed..66ca26d 100644
--- a/lib/rbtree_test.c
+++ b/lib/rbtree_test.c
@@ -1,3 +1,6 @@
+#define KMSG_COMPONENT "rbtree_test"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/module.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/random.h>
@@ -153,7 +156,7 @@ static int rbtree_test_init(void)
 	int i, j;
 	cycles_t time1, time2, time;
 
-	printk(KERN_ALERT "rbtree testing");
+	pr_info("rbtree testing");
 
 	prandom_seed_state(&rnd, 3141592653589793238ULL);
 	init();
@@ -171,7 +174,7 @@ static int rbtree_test_init(void)
 	time = time2 - time1;
 
 	time = div_u64(time, PERF_LOOPS);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
+	pr_info(" -> %llu cycles\n", (unsigned long long)time);
 
 	for (i = 0; i < CHECK_LOOPS; i++) {
 		init();
@@ -186,7 +189,7 @@ static int rbtree_test_init(void)
 		check(0);
 	}
 
-	printk(KERN_ALERT "augmented rbtree testing");
+	pr_info("augmented rbtree testing");
 
 	init();
 
@@ -203,7 +206,7 @@ static int rbtree_test_init(void)
 	time = time2 - time1;
 
 	time = div_u64(time, PERF_LOOPS);
-	printk(" -> %llu cycles\n", (unsigned long long)time);
+	pr_info(" -> %llu cycles\n", (unsigned long long)time);
 
 	for (i = 0; i < CHECK_LOOPS; i++) {
 		init();
@@ -223,7 +226,7 @@ static int rbtree_test_init(void)
 
 static void rbtree_test_exit(void)
 {
-	printk(KERN_ALERT "test exit\n");
+	pr_info("test exit\n");
 }
 
 module_init(rbtree_test_init)
-- 
1.7.11.7




