Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab3HGUmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:42:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60709 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257Ab3HGUkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:53 -0400
Message-ID: <201308072040.r77Ker45016115@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 12:03:53 -0400
Subject: [PATCH] tile: make register dumps more readable
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's much easier to read register dumps if you read vertically
rather than horizontally, since the register numbers line up
and lead the eye down more than to the right.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 25678b8..663289b 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -591,21 +591,21 @@ void show_regs(struct pt_regs *regs)
 	pr_err("\n");
 	show_regs_print_info(KERN_ERR);
 #ifdef __tilegx__
-	for (i = 0; i < 51; i += 3)
+	for (i = 0; i < 17; i++)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
-		       i, regs->regs[i], i+1, regs->regs[i+1],
-		       i+2, regs->regs[i+2]);
-	pr_err(" r51: "REGFMT" r52: "REGFMT" tp : "REGFMT"\n",
-	       regs->regs[51], regs->regs[52], regs->tp);
+		       i, regs->regs[i], i+18, regs->regs[i+18],
+		       i+36, regs->regs[i+36]);
+	pr_err(" r17: "REGFMT" r35: "REGFMT" tp : "REGFMT"\n",
+	       regs->regs[17], regs->regs[35], regs->tp);
 	pr_err(" sp : "REGFMT" lr : "REGFMT"\n", regs->sp, regs->lr);
 #else
-	for (i = 0; i < 52; i += 4)
+	for (i = 0; i < 13; i++)
 		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT
 		       " r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
-		       i, regs->regs[i], i+1, regs->regs[i+1],
-		       i+2, regs->regs[i+2], i+3, regs->regs[i+3]);
-	pr_err(" r52: "REGFMT" tp : "REGFMT" sp : "REGFMT" lr : "REGFMT"\n",
-	       regs->regs[52], regs->tp, regs->sp, regs->lr);
+		       i, regs->regs[i], i+14, regs->regs[i+14],
+		       i+27, regs->regs[i+27], i+40, regs->regs[i+40]);
+	pr_err(" r13: "REGFMT" tp : "REGFMT" sp : "REGFMT" lr : "REGFMT"\n",
+	       regs->regs[13], regs->tp, regs->sp, regs->lr);
 #endif
 	pr_err(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
 	       regs->pc, regs->ex1, regs->faultnum);
-- 
1.8.3.1

