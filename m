Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab3JOUvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:51:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45772 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3JOUvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:51:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
Date: Tue, 15 Oct 2013 22:50:51 +0200
Message-Id: <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Liu Chuansheng <chuansheng.liu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/printk.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e6131a78..3c5069b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
+#include <linux/once.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -252,14 +253,7 @@ extern asmlinkage void dump_stack(void) __cold;
 
 #ifdef CONFIG_PRINTK
 #define printk_once(fmt, ...)			\
-({						\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(fmt, ##__VA_ARGS__);	\
-	}					\
-})
+	DO_ONCE(printk(fmt, ##__VA_ARGS__));
 #else
 #define printk_once(fmt, ...)			\
 	no_printk(fmt, ##__VA_ARGS__)
-- 
1.8.3.1

