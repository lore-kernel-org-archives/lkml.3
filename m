Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaGIV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:27:18 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:54051 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaGIV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:27:15 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] spi: rspi: Relax DMA dependency and increase build coverage
Date: Wed,  9 Jul 2014 23:27:07 +0200
Message-Id: <1404941228-9922-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit ab116a4df4942c78c189d9b0744dd940ab9e00b9 ("dmaengine:
shdma: fix a build failure on platforms with no DMA support"), the DMA
filter function shdma_chan_filter() is sufficiently abstracted to allow
building without DMA support. Hence drop the SH_DMAE_BASE dependency on
SUPERH.
Also increase build coverage by allowing the driver to be enabled if
COMPILE_TEST=y.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index d6be5e6e93e9..d46b4b9e73b2 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -396,7 +396,7 @@ config SPI_ROCKCHIP
 
 config SPI_RSPI
 	tristate "Renesas RSPI/QSPI controller"
-	depends on (SUPERH && SH_DMAE_BASE) || ARCH_SHMOBILE
+	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
 	help
 	  SPI driver for Renesas RSPI and QSPI blocks.
 
-- 
1.9.1

