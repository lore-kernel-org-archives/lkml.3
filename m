Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab3JPMdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:33:43 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42360 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340Ab3JPMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 14/16] m68k/UAPI: Move VME Board ID definition to <asm/bootinfo-vme.h>
Date: Wed, 16 Oct 2013 14:31:31 +0200
Message-Id: <1381926693-6392-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/include/asm/mvme16xhw.h         |   15 ---------------
 arch/m68k/include/uapi/asm/bootinfo-vme.h |   25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/m68k/include/asm/mvme16xhw.h b/arch/m68k/include/asm/mvme16xhw.h
index 87fa84ad252e..1eb89de631e5 100644
--- a/arch/m68k/include/asm/mvme16xhw.h
+++ b/arch/m68k/include/asm/mvme16xhw.h
@@ -3,21 +3,6 @@
 
 #include <asm/irq.h>
 
-/* Board ID data structure - pointer to this retrieved from Bug by head.S */
-
-/* Note, bytes 12 and 13 are board no in BCD (0162,0166,0167,0177,etc) */
-
-typedef struct {
-	char	bdid[4];
-	u_char	rev, mth, day, yr;
-	u_short	size, reserved;
-	u_short	brdno;
-	char brdsuffix[2];
-	u_long	options;
-	u_short	clun, dlun, ctype, dnum;
-	u_long	option2;
-} t_bdid, *p_bdid;
-
 
 typedef struct {
 	u_char	ack_icr,
diff --git a/arch/m68k/include/uapi/asm/bootinfo-vme.h b/arch/m68k/include/uapi/asm/bootinfo-vme.h
index 4643a55ed768..13ba5e19fe24 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-vme.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-vme.h
@@ -28,11 +28,32 @@
 #define VME_TYPE_BVME4000	0x4000	/* BVM Ltd. BVME4000 */
 #define VME_TYPE_BVME6000	0x6000	/* BVM Ltd. BVME6000 */
 
-/* BI_VME_BRDINFO is a 32 byte struct as returned by the Bug code on
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Board ID data structure - pointer to this retrieved from Bug by head.S
+ *
+ * BI_VME_BRDINFO is a 32 byte struct as returned by the Bug code on
  * Motorola VME boards.  Contains board number, Bug version, board
- * configuration options, etc.  See include/asm/mvme16xhw.h for details.
+ * configuration options, etc.
+ *
+ * Note, bytes 12 and 13 are board no in BCD (0162,0166,0167,0177,etc)
  */
 
+typedef struct {
+	char	bdid[4];
+	u_char	rev, mth, day, yr;
+	u_short	size, reserved;
+	u_short	brdno;
+	char	brdsuffix[2];
+	u_long	options;
+	u_short	clun, dlun, ctype, dnum;
+	u_long	option2;
+} t_bdid, *p_bdid;
+
+#endif /* __ASSEMBLY__ */
+
 
     /*
      *  Latest VME bootinfo versions
-- 
1.7.9.5

