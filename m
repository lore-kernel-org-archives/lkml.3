Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab3JPMcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:32:13 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48821 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934329Ab3JPMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/16] m68k/mac: Move struct mac_booter_data to <asm/macintosh.h>
Date: Wed, 16 Oct 2013 14:31:22 +0200
Message-Id: <1381926693-6392-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mac_booter_data is no longer part of the bootinfo API, hence move it
from <asm/bootinfo.h> to <asm/macintosh.h>, dropping all unused fields in
the process.

Also remove the no longer used mac_booter_data pointer from head.S.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/bootinfo.h  |   39 -------------------------------------
 arch/m68k/include/asm/macintosh.h |   23 ++++++++++++++++++++++
 arch/m68k/kernel/head.S           |    2 --
 3 files changed, 23 insertions(+), 41 deletions(-)

diff --git a/arch/m68k/include/asm/bootinfo.h b/arch/m68k/include/asm/bootinfo.h
index b992aa726082..ef888d4af4e6 100644
--- a/arch/m68k/include/asm/bootinfo.h
+++ b/arch/m68k/include/asm/bootinfo.h
@@ -173,45 +173,6 @@ static inline void save_bootinfo(const struct bi_record *bi) {}
 #define BI_MAC_IOP_SWIM		0x8020	/* Mac SWIM floppy IOP */
 #define BI_MAC_IOP_ADB		0x8021	/* Mac ADB IOP */
 
-    /*
-     * Mac: compatibility with old booter data format (temporarily)
-     * Fields unused with the new bootinfo can be deleted now; instead of
-     * adding new fields the struct might be splitted into a hardware address
-     * part and a hardware type part
-     */
-
-#ifndef __ASSEMBLY__
-
-struct mac_booter_data
-{
-	unsigned long videoaddr;
-	unsigned long videorow;
-	unsigned long videodepth;
-	unsigned long dimensions;
-	unsigned long args;
-	unsigned long boottime;
-	unsigned long gmtbias;
-	unsigned long bootver;
-	unsigned long videological;
-	unsigned long sccbase;
-	unsigned long id;
-	unsigned long memsize;
-	unsigned long serialmf;
-	unsigned long serialhsk;
-	unsigned long serialgpi;
-	unsigned long printmf;
-	unsigned long printhsk;
-	unsigned long printgpi;
-	unsigned long cpuid;
-	unsigned long rombase;
-	unsigned long adbdelay;
-	unsigned long timedbra;
-};
-
-extern struct mac_booter_data
-	mac_bi_data;
-
-#endif
 
     /*
      *  Apollo-specific tags
diff --git a/arch/m68k/include/asm/macintosh.h b/arch/m68k/include/asm/macintosh.h
index 682a1a2ff55f..6a633eb64331 100644
--- a/arch/m68k/include/asm/macintosh.h
+++ b/arch/m68k/include/asm/macintosh.h
@@ -135,4 +135,27 @@ struct mac_model
 
 extern struct mac_model *macintosh_config;
 
+
+    /*
+     * Internal representation of the Mac hardware, filled in from bootinfo
+     */
+
+struct mac_booter_data
+{
+	unsigned long videoaddr;
+	unsigned long videorow;
+	unsigned long videodepth;
+	unsigned long dimensions;
+	unsigned long boottime;
+	unsigned long gmtbias;
+	unsigned long videological;
+	unsigned long sccbase;
+	unsigned long id;
+	unsigned long memsize;
+	unsigned long cpuid;
+	unsigned long rombase;
+};
+
+extern struct mac_booter_data mac_bi_data;
+
 #endif
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index 8d14b0f9a36f..28f817481f3b 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -3896,8 +3896,6 @@ BVME_SCC_DATA_A	= 0xffb0000f
 #endif
 
 #if defined(CONFIG_MAC)
-L(mac_booter_data):
-	.long	0
 L(mac_videobase):
 	.long	0
 L(mac_videodepth):
-- 
1.7.9.5

