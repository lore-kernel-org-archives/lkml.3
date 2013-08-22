Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3HVVDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:03:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37840 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3HVVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:03:38 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] dma/Kconfig: TI_EDMA needs to be boolean
Date: Thu, 22 Aug 2013 14:03:24 -0700
Message-Id: <1377205404-16786-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

arch/arm/common/built-in.o: undefined reference to `edma_filter_fn'

seen with "make ARCH=arm allmodconfig"

Commit 6cba4355 (ARM: edma: Add DT and runtime PM support to the private EDMA
API) adds a dependency on edma_filter_fn() into arch/arm/common/edma.c. Since
this file is always built into the kernel, edma_filter_fn() must be built into
the kernel as well.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/dma/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6825957..643d7c7 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -194,7 +194,7 @@ config SIRF_DMA
 	  Enable support for the CSR SiRFprimaII DMA engine.
 
 config TI_EDMA
-	tristate "TI EDMA support"
+	bool "TI EDMA support"
 	depends on ARCH_DAVINCI || ARCH_OMAP
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
-- 
1.7.9.7

