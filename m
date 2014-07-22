Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaGVLB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:01:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56781 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbaGVK5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:33 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/28] phy: Kconfig: Update config for Exynos USB DRD
Date: Tue, 22 Jul 2014 16:26:38 +0530
Message-ID: <1406026611-30493-16-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@samsung.com>

USB DWC3 driver on Exynos platform does not work without its
corresponding phy driver. Hence make the PHY driver depend on
Exynos DWC3 driver and default it to yes to make things easier
for the end user.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index f28b87f..778e126 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -161,8 +161,10 @@ config PHY_EXYNOS5_USBDRD
 	tristate "Exynos5 SoC series USB DRD PHY driver"
 	depends on ARCH_EXYNOS5 && OF
 	depends on HAS_IOMEM
+	depends on USB_DWC3_EXYNOS
 	select GENERIC_PHY
 	select MFD_SYSCON
+	default y
 	help
 	  Enable USB DRD PHY support for Exynos 5 SoC series.
 	  This driver provides PHY interface for USB 3.0 DRD controller
-- 
1.7.9.5

