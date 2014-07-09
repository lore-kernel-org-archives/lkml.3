Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaGILxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:53:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41977 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaGILxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:53:31 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com, tomasz.figa@gmail.com,
        jg1.han@samsung.com
Subject: [PATCH v2 2/2] phy: Kconfig: Update config for Exynos USB DRD
Date: Wed,  9 Jul 2014 17:19:29 +0530
Message-Id: <1404906569-28026-2-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>
References: <1404906569-28026-1-git-send-email-sachin.kamat@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB DWC3 driver on Exynos platform does not work without its
corresponding phy driver. Hence make the PHY driver depend on
Exynos DWC3 driver and default it to yes to make things easier
for the end user.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
No changes since v1.
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 128f8b92b55c..ee6c80a5392a 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -152,8 +152,10 @@ config PHY_EXYNOS5_USBDRD
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

