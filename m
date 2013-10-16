Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab3JPMbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:31:55 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:36711 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934223Ab3JPMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:31:50 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/16] m68k: The bootinfo is located right after the kernel
Date: Wed, 16 Oct 2013 14:31:19 +0200
Message-Id: <1381926693-6392-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the introduction of init sections (which are located after BSS), the
bootinfo is no longer located right after the BSS, but after all kernel
sections.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/bootinfo.h |    2 +-
 arch/m68k/kernel/head.S          |    2 +-
 arch/m68k/kernel/setup_mm.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index 3c2da7bd057f..a66a7f9200f7 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -34,7 +34,7 @@
      *  This way I hope to keep all future changes back/forewards compatible.
      *  Thus, keep your fingers crossed...
      *
-     *  This structure is copied right after the kernel bss by the bootstrap
+     *  This structure is copied right after the kernel by the bootstrap
      *  routine.
      */
 
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index ac85f16534af..fb348caa734e 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -1532,7 +1532,7 @@ L(cache_done):
 
 /*
  * Find a tag record in the bootinfo structure
- * The bootinfo structure is located right after the kernel bss
+ * The bootinfo structure is located right after the kernel
  * Returns: d0: size (-1 if not found)
  *          a0: data pointer (end-of-records if not found)
  */
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 2299080d77f2..b979a3781dcb 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -222,7 +222,7 @@ void __init setup_arch(char **cmdline_p)
 	int i;
 #endif
 
-	/* The bootinfo is located right after the kernel bss */
+	/* The bootinfo is located right after the kernel */
 	if (!CPU_IS_COLDFIRE)
 		m68k_parse_bootinfo((const struct bi_record *)_end);
 
-- 
1.7.9.5

