Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161299Ab3BOKnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:43:07 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760963Ab3BOKlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:55 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 5/6] metag: move mm/init.c exports out of metag_ksyms.c
Date: Fri, 15 Feb 2013 10:41:40 +0000
Message-ID: <1360924901-21404-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's less error prone to have function symbols exported immediately
after the function rather than in metag_ksyms.c. Move each EXPORT_SYMBOL
in metag_ksyms.c for symbols defined in mm/init.c into mm/init.c.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |    2 --
 arch/metag/mm/init.c            |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index d3260c6..559ea6f 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -11,9 +11,7 @@
 
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
-EXPORT_SYMBOL(empty_zero_page);
 
-EXPORT_SYMBOL(pfn_base);
 #ifdef CONFIG_FLATMEM
 /* needed for the pfn_valid macro */
 EXPORT_SYMBOL(max_pfn);
diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index 514376d..504a398 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -3,6 +3,7 @@
  *
  */
 
+#include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/init.h>
@@ -25,10 +26,12 @@
 #include <asm/fixmap.h>
 
 unsigned long pfn_base;
+EXPORT_SYMBOL(pfn_base);
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_data;
 
 unsigned long empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
 
 extern char __user_gateway_start;
 extern char __user_gateway_end;
-- 
1.7.7.6


