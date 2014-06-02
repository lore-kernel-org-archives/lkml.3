Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaFBQSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:18:10 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:44182 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbaFBQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:18:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkAOAE6jjFNbtAfK/2dsb2JhbABZgwerXwUBmBuBFRd0gwIjgRo3iEYB0UAXhVWIfR2EKgSPRYo7ixuIEoM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Luca Barbieri <luca@luca-barbieri.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/atomic64_test.c: convert printk(KERN_INFO to pr_info
Date: Mon,  2 Jun 2014 18:16:50 +0200
Message-Id: <1401725810-6289-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printk to current pr_foo() logging functions.

Also add pr_fmt based on KBUILD_MODNAME to avoid repeating prefix.
Prefix is now "atomic64_test: "

Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/atomic64_test.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 00bca22..0211d30 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -8,6 +8,9 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
@@ -146,18 +149,18 @@ static __init int test_atomic64(void)
 	BUG_ON(v.counter != r);
 
 #ifdef CONFIG_X86
-	printk(KERN_INFO "atomic64 test passed for %s platform %s CX8 and %s SSE\n",
+	pr_info("passed for %s platform %s CX8 and %s SSE\n",
 #ifdef CONFIG_X86_64
-	       "x86-64",
+		"x86-64",
 #elif defined(CONFIG_X86_CMPXCHG64)
-	       "i586+",
+		"i586+",
 #else
-	       "i386+",
+		"i386+",
 #endif
 	       boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
 	       boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
 #else
-	printk(KERN_INFO "atomic64 test passed\n");
+	pr_info("passed\n");
 #endif
 
 	return 0;
-- 
1.8.4.5

