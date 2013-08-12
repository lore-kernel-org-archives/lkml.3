Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3HLT5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:57:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27331 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3HLT4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:56:54 -0400
Message-ID: <201308121956.r7CJurir010323@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 15:09:18 -0400
Subject: [PATCH] tile: remove DEBUG_EXTRA_FLAGS kernel config option
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't used any more by us now that the generic kernel build
offers DEBUG_INFO_REDUCED, so just get rid of it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig.debug | 10 ----------
 arch/tile/Makefile      |  4 ----
 2 files changed, 14 deletions(-)

diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index b8d69f2..19734d3 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -14,16 +14,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_EXTRA_FLAGS
-	string "Additional compiler arguments when building with '-g'"
-	depends on DEBUG_INFO
-	default ""
-	help
-	  Debug info can be large, and flags like
-	  `-femit-struct-debug-baseonly' can reduce the kernel file
-	  size and build time noticeably.  Such flags are often
-	  helpful if the main use of debug info is line number info.
-
 config TILE_HVGLUE_TRACE
 	bool "Provide wrapper functions for hypervisor ABI calls"
 	default n
diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 8e7f852..3107e83 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -30,10 +30,6 @@ endif
 # In kernel modules, this causes load failures due to unsupported relocations.
 KBUILD_CFLAGS   += -fno-asynchronous-unwind-tables
 
-ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
-KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
-endif
-
 LIBGCC_PATH     := \
   $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
 
-- 
1.8.3.1

