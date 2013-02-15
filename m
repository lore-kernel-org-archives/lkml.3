Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100Ab3BOKl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:41:57 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3BOKlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:52 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/6] metag: move setup.c exports out of metag_ksyms.c
Date: Fri, 15 Feb 2013 10:41:38 +0000
Message-ID: <1360924901-21404-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's less error prone to have function symbols exported immediately
after the function rather than in metag_ksyms.c. Move each EXPORT_SYMBOL
in metag_ksyms.c for symbols defined in setup.c into setup.c

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |    5 -----
 arch/metag/kernel/setup.c       |    3 +++
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 53d437f..1004e26 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -6,10 +6,8 @@
 #include <linux/interrupt.h>
 #include <linux/hardirq.h>
 
-#include <asm/setup.h>
 #include <asm/checksum.h>
 #include <asm/uaccess.h>
-#include <asm/traps.h>
 #include <asm/ftrace.h>
 #include <asm/tbx.h>
 
@@ -27,9 +25,6 @@ EXPORT_SYMBOL(__strncpy_from_user);
 EXPORT_SYMBOL(strnlen_user);
 EXPORT_SYMBOL(__do_clear_user);
 
-EXPORT_SYMBOL(pTBI_get);
-EXPORT_SYMBOL(meta_memoffset);
-
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 9803ca4..dd6c5ad 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -5,6 +5,7 @@
  *
  */
 
+#include <linux/export.h>
 #include <linux/bootmem.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
@@ -141,6 +142,7 @@ u8 hwthread_id_2_cpu[4] __read_mostly = {
  * probably only be used via them.
  */
 unsigned int meta_memoffset;
+EXPORT_SYMBOL(meta_memoffset);
 
 static char __initdata *original_cmd_line;
 
@@ -579,6 +581,7 @@ PTBI pTBI_get(unsigned int cpu)
 {
 	return per_cpu(pTBI, cpu);
 }
+EXPORT_SYMBOL(pTBI_get);
 
 #if defined(CONFIG_METAG_DSP) && defined(CONFIG_METAG_FPU)
 char capabilites[] = "dsp fpu";
-- 
1.7.7.6


