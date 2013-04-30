Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3D3OIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:08:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078Ab3D3OIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:08:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>, Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v3.10] mmc: sdhci-s3c: Fix operation on non-single image Samsung platforms
Date: Tue, 30 Apr 2013 15:08:27 +0100
Message-Id: <1367330907-13525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cc014f3 (mmc: sdhci-s3c: remove platform dependencies) changed
the platform dependency in Kconfig to depend on SAMSUNG_SINGLE, meaning
the driver was available only on single zImage Samsung platforms.  This
breaks platforms that haven't been converted such as S3C64xx.  Revert
that part of the change to fix.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 2217164..9ab8f8d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -180,7 +180,7 @@ config MMC_SDHCI_TEGRA
 
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
-	depends on MMC_SDHCI && PLAT_SAMSUNG_SINGLE
+	depends on MMC_SDHCI && PLAT_SAMSUNG
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  often referrered to as the HSMMC block in some of the Samsung S3C
-- 
1.7.10.4

