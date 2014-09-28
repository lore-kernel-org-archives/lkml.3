Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaI1J1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:27:18 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:34957 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaI1J0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:26:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/5] m68k: Reformat arch/m68k/mm/hwtest.c
Date: Sun, 28 Sep 2014 11:26:22 +0200
Message-Id: <1411896385-25384-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
References: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/hwtest.c | 78 ++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/arch/m68k/mm/hwtest.c b/arch/m68k/mm/hwtest.c
index 2a5259fd23ebc532..fb8be4dd38c448d7 100644
--- a/arch/m68k/mm/hwtest.c
+++ b/arch/m68k/mm/hwtest.c
@@ -25,32 +25,32 @@
 
 #include <linux/module.h>
 
-int hwreg_present( volatile void *regp )
+int hwreg_present(volatile void *regp)
 {
-    int	ret = 0;
-    unsigned long flags;
-    long	save_sp, save_vbr;
-    long	tmp_vectors[3];
+	int ret = 0;
+	unsigned long flags;
+	long save_sp, save_vbr;
+	long tmp_vectors[3];
 
-    local_irq_save(flags);
-    __asm__ __volatile__
-	(	"movec	%/vbr,%2\n\t"
-		"movel	#Lberr1,%4@(8)\n\t"
-                "movec	%4,%/vbr\n\t"
-		"movel	%/sp,%1\n\t"
-		"moveq	#0,%0\n\t"
-		"tstb	%3@\n\t"
+	local_irq_save(flags);
+	__asm__ __volatile__ (
+		"movec %/vbr,%2\n\t"
+		"movel #Lberr1,%4@(8)\n\t"
+		"movec %4,%/vbr\n\t"
+		"movel %/sp,%1\n\t"
+		"moveq #0,%0\n\t"
+		"tstb %3@\n\t"
 		"nop\n\t"
-		"moveq	#1,%0\n"
-                "Lberr1:\n\t"
-		"movel	%1,%/sp\n\t"
-		"movec	%2,%/vbr"
+		"moveq #1,%0\n"
+	"Lberr1:\n\t"
+		"movel %1,%/sp\n\t"
+		"movec %2,%/vbr"
 		: "=&d" (ret), "=&r" (save_sp), "=&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors)
-                );
-    local_irq_restore(flags);
+	);
+	local_irq_restore(flags);
 
-    return( ret );
+	return ret;
 }
 EXPORT_SYMBOL(hwreg_present);
 
@@ -58,34 +58,36 @@ EXPORT_SYMBOL(hwreg_present);
  * by a bus error handler. Returns 1 if successful, 0 otherwise.
  */
 
-int hwreg_write( volatile void *regp, unsigned short val )
+int hwreg_write(volatile void *regp, unsigned short val)
 {
-	int		ret;
+	int ret;
 	unsigned long flags;
-	long	save_sp, save_vbr;
-	long	tmp_vectors[3];
+	long save_sp, save_vbr;
+	long tmp_vectors[3];
 
 	local_irq_save(flags);
-	__asm__ __volatile__
-	(	"movec	%/vbr,%2\n\t"
-		"movel	#Lberr2,%4@(8)\n\t"
-		"movec	%4,%/vbr\n\t"
-		"movel	%/sp,%1\n\t"
-		"moveq	#0,%0\n\t"
-		"movew	%5,%3@\n\t"
-		"nop	\n\t"	/* If this nop isn't present, 'ret' may already be
-				 * loaded with 1 at the time the bus error
-				 * happens! */
-		"moveq	#1,%0\n"
+	__asm__ __volatile__ (
+		"movec %/vbr,%2\n\t"
+		"movel #Lberr2,%4@(8)\n\t"
+		"movec %4,%/vbr\n\t"
+		"movel %/sp,%1\n\t"
+		"moveq #0,%0\n\t"
+		"movew %5,%3@\n\t"
+		"nop\n\t"
+		/*
+		 * If this nop isn't present, 'ret' may already be loaded
+		 * with 1 at the time the bus error happens!
+		 */
+		"moveq #1,%0\n"
 	"Lberr2:\n\t"
-		"movel	%1,%/sp\n\t"
-		"movec	%2,%/vbr"
+		"movel %1,%/sp\n\t"
+		"movec %2,%/vbr"
 		: "=&d" (ret), "=&r" (save_sp), "=&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors), "g" (val)
 	);
 	local_irq_restore(flags);
 
-	return( ret );
+	return ret;
 }
 EXPORT_SYMBOL(hwreg_write);
 
-- 
1.9.1

