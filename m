Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaGNKNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:13:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44977 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaGNKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:12:45 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com
Subject: [PATCH 2/2] phy: Kconfig: Update config for Exynos USB DRD
Date: Mon, 14 Jul 2014 15:38:42 +0530
Message-Id: <1405332522-6162-2-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405332522-6162-1-git-send-email-sachin.kamat@samsung.com>
References: <1405332522-6162-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB DWC3 driver on Exynos platform does not work without its
corresponding phy driver. Hence make the PHY driver depend on
Exynos DWC3 driver and default it to yes to make things easier
for the end user.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index c412ca4..c730e85 100644
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

