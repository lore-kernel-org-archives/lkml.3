Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLONhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:37:08 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:57379 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaLONhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:37:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] i2c: sh_mobile: I2C_SH_MOBILE should depend on HAS_DMA
Date: Mon, 15 Dec 2014 14:37:04 +0100
Message-Id: <1418650624-28174-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `sh_mobile_i2c_dma_unmap':
i2c-sh_mobile.c:(.text+0x60de42): undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `sh_mobile_i2c_xfer_dma':
i2c-sh_mobile.c:(.text+0x60df22): undefined reference to `dma_map_single'
i2c-sh_mobile.c:(.text+0x60df2e): undefined reference to `dma_mapping_error'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/i2c/busses/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c1351d9fb35bbc8d..f08dd20f625c184d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -753,6 +753,7 @@ config I2C_SH7760
 
 config I2C_SH_MOBILE
 	tristate "SuperH Mobile I2C Controller"
+	depends on HAS_DMA
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  If you say yes to this option, support will be included for the
-- 
1.9.1

