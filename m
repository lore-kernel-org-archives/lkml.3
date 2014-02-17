Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaBQI7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34158 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaBQI7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:34 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 4/8] phy,phy-bcm-kona-usb2.c: Add dependency on HAS_IOMEM
Date: Mon, 17 Feb 2014 14:29:21 +0530
Message-ID: <1392627565-1829-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/phy/phy-bcm-kona-usb2.c:114: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    1 +
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
1.7.10.4

