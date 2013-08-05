Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3HEWHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:07:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:64992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3HEWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341520"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/16] x86, asmlinkage: Make dump_stack visible
Date: Mon,  5 Aug 2013 15:02:48 -0700
Message-Id: <1375740170-7446-15-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

dump_stack is used from assembler code, so make it visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/printk.h | 2 +-
 lib/dump_stack.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052..e6131a78 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -200,7 +200,7 @@ static inline void show_regs_print_info(const char *log_lvl)
 }
 #endif
 
-extern void dump_stack(void) __cold;
+extern asmlinkage void dump_stack(void) __cold;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index c031541..f23b63f 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -23,7 +23,7 @@ static void __dump_stack(void)
 #ifdef CONFIG_SMP
 static atomic_t dump_lock = ATOMIC_INIT(-1);
 
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	int was_locked;
 	int old;
@@ -55,7 +55,7 @@ retry:
 	preempt_enable();
 }
 #else
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	__dump_stack();
 }
-- 
1.8.3.1

