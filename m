Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaI0BMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:12:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57470 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaI0BL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:11:57 -0400
From: Behan Webster <behanw@converseincode.com>
To: archit@ti.com, b.zolnierkie@samsung.com, m.chehab@samsung.com
Cc: behanw@converseincode.com, hans.verkuil@cisco.com, k.debski@samsung.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] media, platform, LLVMLinux: Remove nested function from ti-vpe
Date: Fri, 26 Sep 2014 18:11:45 -0700
Message-Id: <1411780305-5685-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the use of nested functions where a normal function will suffice.

Nested functions are not liked by upstream kernel developers in general. Their
use breaks the use of clang as a compiler, and doesn't make the code any
better.

This code now works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/ti-vpe/csc.c | 8 ++------
 drivers/media/platform/ti-vpe/sc.c  | 8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index 940df40..44fbf41 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -93,12 +93,8 @@ void csc_dump_regs(struct csc_data *csc)
 {
 	struct device *dev = &csc->pdev->dev;
 
-	u32 read_reg(struct csc_data *csc, int offset)
-	{
-		return ioread32(csc->base + offset);
-	}
-
-#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(csc, CSC_##r))
+#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
+	ioread32(csc->base + CSC_##r))
 
 	DUMPREG(CSC00);
 	DUMPREG(CSC01);
diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index 6314171..1088381 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -24,12 +24,8 @@ void sc_dump_regs(struct sc_data *sc)
 {
 	struct device *dev = &sc->pdev->dev;
 
-	u32 read_reg(struct sc_data *sc, int offset)
-	{
-		return ioread32(sc->base + offset);
-	}
-
-#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(sc, CFG_##r))
+#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
+	ioread32(sc->base + CFG_##r))
 
 	DUMPREG(SC0);
 	DUMPREG(SC1);
-- 
1.9.1

