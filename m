Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaGJGZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:25:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaGJGZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] phy: sun4i: depend on RESET_CONTROLLER
Date: Thu, 10 Jul 2014 11:54:59 +0530
Message-ID: <1404973503-3310-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404973503-3310-1-git-send-email-kishon@ti.com>
References: <1404973503-3310-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

The driver depend on the reset framework in a mandatory way. Make sure
reset_control_get is defined by adding this dependency in Kconfig

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..1d8099a 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -112,6 +112,7 @@ config PHY_EXYNOS5250_SATA
 config PHY_SUN4I_USB
 	tristate "Allwinner sunxi SoC USB PHY driver"
 	depends on ARCH_SUNXI && HAS_IOMEM && OF
+	depends on RESET_CONTROLLER
 	select GENERIC_PHY
 	help
 	  Enable this to support the transceiver that is part of Allwinner
-- 
1.7.9.5

