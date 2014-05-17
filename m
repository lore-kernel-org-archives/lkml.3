Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaEQGeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 02:34:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:58836 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbaEQGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 02:34:20 -0400
X-IronPort-AV: E=Sophos;i="4.98,1071,1392159600"; 
   d="scan'208";a="74196242"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: kernel-janitors@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] video: delete unneeded call to platform_get_drvdata
Date: Sat, 17 May 2014 08:32:49 +0200
Message-Id: <1400308369-24375-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/video/fbdev/bf54x-lq043fb.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/bf54x-lq043fb.c b/drivers/video/fbdev/bf54x-lq043fb.c
index e2c42ad..adbef54 100644
--- a/drivers/video/fbdev/bf54x-lq043fb.c
+++ b/drivers/video/fbdev/bf54x-lq043fb.c
@@ -717,8 +717,6 @@ static int bfin_bf54x_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_bf54x_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-
 	bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() & ~EPPI_EN);
 	disable_dma(CH_EPPI0);
 	bfin_write_EPPI0_STATUS(0xFFFF);

