Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaDOLO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:14:56 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:42204 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaDOLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:14:55 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v2] spi: cadence: Add dependency on ARM
Date: Tue, 15 Apr 2014 16:42:09 +0530
Message-Id: <1397560329-3603-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dependency on ARM in Kconfig.
This is to fix the build error related to _relaxed IO.
Remove dependency on SPI_MASTER because this is already defined
under if SPI_MASTER in Kconfig.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v2 changes:
Add dependency on ARM instead of ZYNQ.
Remove SPI_MASTER dependency as it is already under if SPI_MASTER.

---
 drivers/spi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index b0f091b..0616f97 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -150,7 +150,7 @@ config SPI_BUTTERFLY
 
 config SPI_CADENCE
 	tristate "Cadence SPI controller"
-	depends on SPI_MASTER
+	depends on ARM
 	help
 	  This selects the Cadence SPI controller master driver
 	  used by Xilinx Zynq.
-- 
1.7.9.5

