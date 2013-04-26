Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3DZJHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:07:04 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63783 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3DZJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:06:59 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dmaengine: use phys_addr_t for slave configuration
Date: Fri, 26 Apr 2013 11:06:54 +0200
Message-Id: <1366967214-20776-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation already says these are physical addresses, and
we have concluded that any translation into the DMA address space
needs to reside in the dmaengine driver, so change the type of
the passed arguments.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/dmaengine.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 91ac8da..681df5f9 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -361,8 +361,8 @@ enum dma_slave_buswidth {
  */
 struct dma_slave_config {
 	enum dma_transfer_direction direction;
-	dma_addr_t src_addr;
-	dma_addr_t dst_addr;
+	phys_addr_t src_addr;
+	phys_addr_t dst_addr;
 	enum dma_slave_buswidth src_addr_width;
 	enum dma_slave_buswidth dst_addr_width;
 	u32 src_maxburst;
-- 
1.8.1.4

