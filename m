Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaEWVF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:05:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57161 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbaEWVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:05:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: kishon@ti.com, hdegoede@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
Date: Fri, 23 May 2014 20:51:28 +0200
Message-Id: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver depend on the reset framework in a mandatory way. Make sure
reset_control_get is defined by adding this dependency in Kconfig

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f067c242..1d8099a56a91 100644
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
1.9.3

