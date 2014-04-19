Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaDSDXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:23:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43946 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaDSDVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:21:49 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] phy: exynos: fix building as a module
Date: Sat, 19 Apr 2014 08:51:41 +0530
Message-ID: <1397877704-2755-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397877704-2755-1-git-send-email-kishon@ti.com>
References: <1397877704-2755-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The top-level phy-samsung-usb2 driver may be configured as a
loadable module, which currently causes link errors because
of the dependency on the exynos{5250,4x12,4210}_usb2_phy_config
symbol. Solving this could be achieved by exporting these
symbols, but as the SoC-specific parts of the driver are not
currently built as modules, it seems better to just link
everything into one module and avoid the need for the export.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Makefile |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 2faf78e..7728518 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -13,8 +13,9 @@ obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
 obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o
 obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
-obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
-obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
-obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
-obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
+obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
+phy-exynos-usb2-y			+= phy-samsung-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
-- 
1.7.9.5

