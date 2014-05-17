Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaEQGeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 02:34:20 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:58836 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbaEQGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 02:34:19 -0400
X-IronPort-AV: E=Sophos;i="4.98,1071,1392159600"; 
   d="scan'208";a="74196241"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mtd: delete unneeded call to platform_get_drvdata
Date: Sat, 17 May 2014 08:32:48 +0200
Message-Id: <1400308369-24375-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Platform_get_drvdata is an accessor function, and has no purpose if its
result is not used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@
- T x = platform_get_drvdata(...);
... when != x
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/nand/bf5xx_nand.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index b7a2494..b5fbd48 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -840,15 +840,11 @@ out_err_kzalloc:
 
 static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_t pm)
 {
-	struct bf5xx_nand_info *info = platform_get_drvdata(dev);
-
 	return 0;
 }
 
 static int bf5xx_nand_resume(struct platform_device *dev)
 {
-	struct bf5xx_nand_info *info = platform_get_drvdata(dev);
-
 	return 0;
 }
 

