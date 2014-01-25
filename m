Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaAYW2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 17:28:18 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbaAYW2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 17:28:17 -0500
From: Richard Weinberger <richard@nod.at>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org, mporter@linaro.org, balbi@ti.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] phy,phy-bcm-kona-usb2.c: Add dependency on HAS_IOMEM
Date: Sat, 25 Jan 2014 23:28:02 +0100
Message-Id: <1390688882-4885-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/phy/phy-bcm-kona-usb2.c:114: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index afa2354..79e3c70 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -61,6 +61,7 @@ config PHY_EXYNOS_DP_VIDEO
 config BCM_KONA_USB2_PHY
 	tristate "Broadcom Kona USB2 PHY Driver"
 	depends on GENERIC_PHY
+	depends on HAS_IOMEM
 	help
 	  Enable this to support the Broadcom Kona USB 2.0 PHY.
 
-- 
1.8.1.4

