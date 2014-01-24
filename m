Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaAXQwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:52:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36140 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaAXQwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:52:45 -0500
From: Balaji T K <balajitk@ti.com>
To: <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <geert@linux-m68k.org>, <chris@printf.net>, <linux@arm.linux.org.uk>
CC: <a-bindra@ti.com>, <linux-sh@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Balaji T K <balajitk@ti.com>
Subject: [PATCH/RFC] dmaengine: omap-dma: split header file
Date: Fri, 24 Jan 2014 22:21:56 +0530
Message-ID: <1390582316-4765-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20140119100235.GN27282@n2100.arm.linux.org.uk>
References: <20140119100235.GN27282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To Resolve build failure seen with sh-allmodconfig:
    include/linux/omap-dma.h:171:8: error: expected identifier before numeric constant
    make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1
due to CCR redefinition, move dmaengine consumer specific function to omap-dmaengine.h

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Balaji T K <balajitk@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c  |    2 +-
 include/linux/omap-dma.h       |   19 +------------------
 include/linux/omap-dmaengine.h |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/omap-dmaengine.h

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index dbd32ad..2f57e36 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -31,7 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/of_device.h>
-#include <linux/omap-dma.h>
+#include <linux/omap-dmaengine.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/core.h>
 #include <linux/mmc/mmc.h>
diff --git a/include/linux/omap-dma.h b/include/linux/omap-dma.h
index 7af25a9..6aa97e5 100644
--- a/include/linux/omap-dma.h
+++ b/include/linux/omap-dma.h
@@ -1,23 +1,6 @@
-/*
- * OMAP DMA Engine support
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
 #ifndef __LINUX_OMAP_DMA_H
 #define __LINUX_OMAP_DMA_H
-
-struct dma_chan;
-
-#if defined(CONFIG_DMA_OMAP) || defined(CONFIG_DMA_OMAP_MODULE)
-bool omap_dma_filter_fn(struct dma_chan *, void *);
-#else
-static inline bool omap_dma_filter_fn(struct dma_chan *c, void *d)
-{
-	return false;
-}
-#endif
+#include <linux/omap-dmaengine.h>
 
 /*
  *  Legacy OMAP DMA handling defines and functions
diff --git a/include/linux/omap-dmaengine.h b/include/linux/omap-dmaengine.h
new file mode 100644
index 0000000..2b0b6aa
--- /dev/null
+++ b/include/linux/omap-dmaengine.h
@@ -0,0 +1,21 @@
+/*
+ * OMAP DMA Engine support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_OMAP_DMAENGINE_H
+#define __LINUX_OMAP_DMAENGINE_H
+
+struct dma_chan;
+
+#if defined(CONFIG_DMA_OMAP) || defined(CONFIG_DMA_OMAP_MODULE)
+bool omap_dma_filter_fn(struct dma_chan *, void *);
+#else
+static inline bool omap_dma_filter_fn(struct dma_chan *c, void *d)
+{
+	return false;
+}
+#endif
+#endif /* __LINUX_OMAP_DMAENGINE_H */
-- 
1.7.5.4

