Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3HEWHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:07:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:37723 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab3HEWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="278100321"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/16] x86: Fix sys_call_table type in asm/syscall.h v2
Date: Mon,  5 Aug 2013 15:02:35 -0700
Message-Id: <1375740170-7446-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make the sys_call_table type defined in asm/syscall.h match
the definition in syscall_64.c

v2: include asm/syscall.h in syscall_64.c too. I left uml alone
because it doesn't have an syscall.h on its own and including
the native one leads to other errors.
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/syscall.h | 3 ++-
 arch/x86/kernel/syscall_64.c   | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 2e188d6..aea284b 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -20,7 +20,8 @@
 #include <asm/thread_info.h>	/* for TS_COMPAT */
 #include <asm/unistd.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 5c7f8c2..ec008f5 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -4,6 +4,7 @@
 #include <linux/sys.h>
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
+#include <asm/syscall.h>
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
 
@@ -19,8 +20,6 @@
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
-
 extern void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
-- 
1.8.3.1

