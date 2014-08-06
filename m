Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaHFQ7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:59:11 -0400
Received: from mail-yk0-f193.google.com ([209.85.160.193]:44552 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbaHFQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:55:20 -0400
From: Nick Krause <xerofoiffy@gmail.com>
To: Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] spi: Fix warning about redefinition
Date: Wed,  6 Aug 2014 12:55:28 -0400
Message-Id: <1407344128-9754-1-git-send-email-xerofoiffy@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings about redefining READ and write

drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
include/linux/fs.h:193:0: note: this is the location of the previous definition
drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
include/linux/fs.h:192:0: note: this is the location of the previous definition

Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
---
 drivers/spi/spi-omap-100k.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 5e91858..eb8ae4e 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -70,6 +70,12 @@
 #define SPI_STATUS_WE                   (1UL << 1)
 #define SPI_STATUS_RD                   (1UL << 0)
 
+#ifdef WRITE
+#undef WRITE
+#endif
+#ifdef READ
+#undef READ
+#endif
 #define WRITE 0
 #define READ  1
 
-- 
1.9.1

