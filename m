Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228Ab3BOKmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:42:00 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab3BOKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/6] metag: move traps.c exports out of metag_ksyms.c
Date: Fri, 15 Feb 2013 10:41:36 +0000
Message-ID: <1360924901-21404-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's less error prone to have function symbols exported immediately
after the function rather than in metag_ksyms.c. Move each EXPORT_SYMBOL
in metag_ksyms.c for symbols defined in traps.c into traps.c

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |    5 -----
 arch/metag/kernel/traps.c       |    3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 1b27bea..12914a4 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -31,11 +31,6 @@ EXPORT_SYMBOL(pTBI_get);
 EXPORT_SYMBOL(meta_memoffset);
 EXPORT_SYMBOL(kick_register_func);
 EXPORT_SYMBOL(kick_unregister_func);
-#ifdef CONFIG_SMP
-EXPORT_SYMBOL(get_trigger_mask);
-#else
-EXPORT_SYMBOL(global_trigger_mask);
-#endif
 
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index d7db772..8961f24 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -8,6 +8,7 @@
  * for more details.
  */
 
+#include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/kernel.h>
@@ -59,6 +60,7 @@ DECLARE_PER_CPU(PTBI, pTBI);
 static DEFINE_PER_CPU(unsigned int, trigger_mask);
 #else
 unsigned int global_trigger_mask;
+EXPORT_SYMBOL(global_trigger_mask);
 #endif
 
 unsigned long per_cpu__stack_save[NR_CPUS];
@@ -787,6 +789,7 @@ unsigned int get_trigger_mask(void)
 {
 	return _get_trigger_mask();
 }
+EXPORT_SYMBOL(get_trigger_mask);
 
 static void set_trigger_mask(unsigned int mask)
 {
-- 
1.7.7.6


