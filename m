Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3BAUnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:43:39 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21480 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab3BAUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:35 -0500
Message-ID: <201302012043.r11KhYaH024378@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 15:06:06 -0500
Subject: [PATCH] tile: export a handful of symbols appropriately
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was shown up by running with "allmodconfig".  I used
EXPORT_SYMBOL() to match existing conventions in files that
were already exporting symbols, or that were exported that way
by other architectures, and otherwise EXPORT_SYMBOL_GPL().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/reboot.c  |    2 ++
 arch/tile/kernel/stack.c   |    1 +
 arch/tile/lib/cacheflush.c |    2 ++
 arch/tile/lib/cpumask.c    |    2 ++
 arch/tile/lib/exports.c    |    2 ++
 arch/tile/mm/homecache.c   |    1 +
 6 files changed, 10 insertions(+)

diff --git a/arch/tile/kernel/reboot.c b/arch/tile/kernel/reboot.c
index baa3d90..d1b5c91 100644
--- a/arch/tile/kernel/reboot.c
+++ b/arch/tile/kernel/reboot.c
@@ -16,6 +16,7 @@
 #include <linux/reboot.h>
 #include <linux/smp.h>
 #include <linux/pm.h>
+#include <linux/export.h>
 #include <asm/page.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
@@ -49,3 +50,4 @@ void machine_restart(char *cmd)
 
 /* No interesting distinction to be made here. */
 void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index ba2b36c..ed258b8 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -484,6 +484,7 @@ void save_stack_trace(struct stack_trace *trace)
 {
 	save_stack_trace_tsk(NULL, trace);
 }
+EXPORT_SYMBOL_GPL(save_stack_trace);
 
 #endif
 
diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index db4fb89..8f8ad81 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -12,6 +12,7 @@
  *   more details.
  */
 
+#include <linux/export.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 #include <arch/icache.h>
@@ -165,3 +166,4 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 	__insn_mtspr(SPR_DSTREAM_PF, old_dstream_pf);
 #endif
 }
+EXPORT_SYMBOL_GPL(finv_buffer_remote);
diff --git a/arch/tile/lib/cpumask.c b/arch/tile/lib/cpumask.c
index fdc4036..75947ed 100644
--- a/arch/tile/lib/cpumask.c
+++ b/arch/tile/lib/cpumask.c
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/smp.h>
+#include <linux/export.h>
 
 /*
  * Allow cropping out bits beyond the end of the array.
@@ -50,3 +51,4 @@ int bitmap_parselist_crop(const char *bp, unsigned long *maskp, int nmaskbits)
 	} while (*bp != '\0' && *bp != '\n');
 	return 0;
 }
+EXPORT_SYMBOL(bitmap_parselist_crop);
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index dd5f0a3..4385cb6 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -55,6 +55,8 @@ EXPORT_SYMBOL(hv_dev_poll_cancel);
 EXPORT_SYMBOL(hv_dev_close);
 EXPORT_SYMBOL(hv_sysconf);
 EXPORT_SYMBOL(hv_confstr);
+EXPORT_SYMBOL(hv_get_rtc);
+EXPORT_SYMBOL(hv_set_rtc);
 
 /* libgcc.a */
 uint32_t __udivsi3(uint32_t dividend, uint32_t divisor);
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 5f7868d..1ae9119 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -408,6 +408,7 @@ void homecache_change_page_home(struct page *page, int order, int home)
 		__set_pte(ptep, pte_set_home(pteval, home));
 	}
 }
+EXPORT_SYMBOL(homecache_change_page_home);
 
 struct page *homecache_alloc_pages(gfp_t gfp_mask,
 				   unsigned int order, int home)
-- 
1.7.10.3

