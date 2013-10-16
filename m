Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab3JPMdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:33:44 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42208 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336Ab3JPMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 13/16] m68k/UAPI: Move Macintosh model definitions to <asm/bootinfo-mac.h>
Date: Wed, 16 Oct 2013 14:31:30 +0200
Message-Id: <1381926693-6392-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/macintosh.h         |   62 ++---------------------------
 arch/m68k/include/uapi/asm/bootinfo-mac.h |   60 ++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 59 deletions(-)

diff --git a/arch/m68k/include/asm/macintosh.h b/arch/m68k/include/asm/macintosh.h
index 6a633eb64331..d323b2c2d07d 100644
--- a/arch/m68k/include/asm/macintosh.h
+++ b/arch/m68k/include/asm/macintosh.h
@@ -4,6 +4,9 @@
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
+#include <asm/bootinfo-mac.h>
+
+
 /*
  *	Apple Macintoshisms
  */
@@ -74,65 +77,6 @@ struct mac_model
 #define MAC_FLOPPY_SWIM_IOP	3
 #define MAC_FLOPPY_AV		4
 
-/*
- *	Gestalt numbers
- */
-
-#define MAC_MODEL_II		6
-#define MAC_MODEL_IIX		7
-#define MAC_MODEL_IICX		8
-#define MAC_MODEL_SE30		9
-#define MAC_MODEL_IICI		11
-#define MAC_MODEL_IIFX		13	/* And well numbered it is too */
-#define MAC_MODEL_IISI		18
-#define MAC_MODEL_LC		19
-#define MAC_MODEL_Q900		20
-#define MAC_MODEL_PB170		21
-#define MAC_MODEL_Q700		22
-#define MAC_MODEL_CLII		23	/* aka: P200 */
-#define MAC_MODEL_PB140		25
-#define MAC_MODEL_Q950		26	/* aka: WGS95 */
-#define MAC_MODEL_LCIII		27	/* aka: P450 */
-#define MAC_MODEL_PB210		29
-#define MAC_MODEL_C650		30
-#define MAC_MODEL_PB230		32
-#define MAC_MODEL_PB180		33
-#define MAC_MODEL_PB160		34
-#define MAC_MODEL_Q800		35	/* aka: WGS80 */
-#define MAC_MODEL_Q650		36
-#define MAC_MODEL_LCII		37	/* aka: P400/405/410/430 */
-#define MAC_MODEL_PB250		38
-#define MAC_MODEL_IIVI		44
-#define MAC_MODEL_P600		45	/* aka: P600CD */
-#define MAC_MODEL_IIVX		48
-#define MAC_MODEL_CCL		49	/* aka: P250 */
-#define MAC_MODEL_PB165C	50
-#define MAC_MODEL_C610		52	/* aka: WGS60 */
-#define MAC_MODEL_Q610		53
-#define MAC_MODEL_PB145		54	/* aka: PB145B */
-#define MAC_MODEL_P520		56	/* aka: LC520 */
-#define MAC_MODEL_C660		60
-#define MAC_MODEL_P460		62	/* aka: LCIII+, P466/P467 */
-#define MAC_MODEL_PB180C	71
-#define MAC_MODEL_PB520		72	/* aka: PB520C, PB540, PB540C, PB550C */
-#define MAC_MODEL_PB270C	77
-#define MAC_MODEL_Q840		78
-#define MAC_MODEL_P550		80	/* aka: LC550, P560 */
-#define MAC_MODEL_CCLII		83	/* aka: P275 */
-#define MAC_MODEL_PB165		84
-#define MAC_MODEL_PB190		85	/* aka: PB190CS */
-#define MAC_MODEL_TV		88
-#define MAC_MODEL_P475		89	/* aka: LC475, P476 */
-#define MAC_MODEL_P475F		90	/* aka: P475 w/ FPU (no LC040) */
-#define MAC_MODEL_P575		92	/* aka: LC575, P577/P578 */
-#define MAC_MODEL_Q605		94
-#define MAC_MODEL_Q605_ACC	95	/* Q605 accelerated to 33 MHz */
-#define MAC_MODEL_Q630		98	/* aka: LC630, P630/631/635/636/637/638/640 */
-#define MAC_MODEL_P588		99	/* aka: LC580, P580 */
-#define MAC_MODEL_PB280		102
-#define MAC_MODEL_PB280C	103
-#define MAC_MODEL_PB150		115
-
 extern struct mac_model *macintosh_config;
 
 
diff --git a/arch/m68k/include/uapi/asm/bootinfo-mac.h b/arch/m68k/include/uapi/asm/bootinfo-mac.h
index 29a4109ab089..0667c041d1a7 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-mac.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-mac.h
@@ -25,6 +25,66 @@
 
 
     /*
+     * Macintosh Gestalt numbers (BI_MAC_MODEL)
+     */
+
+#define MAC_MODEL_II		6
+#define MAC_MODEL_IIX		7
+#define MAC_MODEL_IICX		8
+#define MAC_MODEL_SE30		9
+#define MAC_MODEL_IICI		11
+#define MAC_MODEL_IIFX		13	/* And well numbered it is too */
+#define MAC_MODEL_IISI		18
+#define MAC_MODEL_LC		19
+#define MAC_MODEL_Q900		20
+#define MAC_MODEL_PB170		21
+#define MAC_MODEL_Q700		22
+#define MAC_MODEL_CLII		23	/* aka: P200 */
+#define MAC_MODEL_PB140		25
+#define MAC_MODEL_Q950		26	/* aka: WGS95 */
+#define MAC_MODEL_LCIII		27	/* aka: P450 */
+#define MAC_MODEL_PB210		29
+#define MAC_MODEL_C650		30
+#define MAC_MODEL_PB230		32
+#define MAC_MODEL_PB180		33
+#define MAC_MODEL_PB160		34
+#define MAC_MODEL_Q800		35	/* aka: WGS80 */
+#define MAC_MODEL_Q650		36
+#define MAC_MODEL_LCII		37	/* aka: P400/405/410/430 */
+#define MAC_MODEL_PB250		38
+#define MAC_MODEL_IIVI		44
+#define MAC_MODEL_P600		45	/* aka: P600CD */
+#define MAC_MODEL_IIVX		48
+#define MAC_MODEL_CCL		49	/* aka: P250 */
+#define MAC_MODEL_PB165C	50
+#define MAC_MODEL_C610		52	/* aka: WGS60 */
+#define MAC_MODEL_Q610		53
+#define MAC_MODEL_PB145		54	/* aka: PB145B */
+#define MAC_MODEL_P520		56	/* aka: LC520 */
+#define MAC_MODEL_C660		60
+#define MAC_MODEL_P460		62	/* aka: LCIII+, P466/P467 */
+#define MAC_MODEL_PB180C	71
+#define MAC_MODEL_PB520		72	/* aka: PB520C, PB540, PB540C, PB550C */
+#define MAC_MODEL_PB270C	77
+#define MAC_MODEL_Q840		78
+#define MAC_MODEL_P550		80	/* aka: LC550, P560 */
+#define MAC_MODEL_CCLII		83	/* aka: P275 */
+#define MAC_MODEL_PB165		84
+#define MAC_MODEL_PB190		85	/* aka: PB190CS */
+#define MAC_MODEL_TV		88
+#define MAC_MODEL_P475		89	/* aka: LC475, P476 */
+#define MAC_MODEL_P475F		90	/* aka: P475 w/ FPU (no LC040) */
+#define MAC_MODEL_P575		92	/* aka: LC575, P577/P578 */
+#define MAC_MODEL_Q605		94
+#define MAC_MODEL_Q605_ACC	95	/* Q605 accelerated to 33 MHz */
+#define MAC_MODEL_Q630		98	/* aka: LC630, P630/631/635/636/637/638/640 */
+#define MAC_MODEL_P588		99	/* aka: LC580, P580 */
+#define MAC_MODEL_PB280		102
+#define MAC_MODEL_PB280C	103
+#define MAC_MODEL_PB150		115
+
+
+    /*
      *  Latest Macintosh bootinfo version
      */
 
-- 
1.7.9.5

