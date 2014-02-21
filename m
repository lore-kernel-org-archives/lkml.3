Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBUT4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:56:13 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:46254 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBUT4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:56:11 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fbdev: FB_OPENCORES should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:56:09 +0100
Message-Id: <1393012569-22560-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    drivers/built-in.o: In function `ocfb_remove':
    ocfb.c:(.text+0x27fee): undefined reference to `dma_free_coherent'
    drivers/built-in.o: In function `ocfb_probe':
    ocfb.c:(.text+0x28418): undefined reference to `dma_alloc_coherent'
    ocfb.c:(.text+0x284d2): undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 0192900dd183..fb8d31e717bc 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -982,7 +982,7 @@ config FB_PVR2
 
 config FB_OPENCORES
 	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
-	depends on FB
+	depends on FB && HAS_DMA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.9.5

