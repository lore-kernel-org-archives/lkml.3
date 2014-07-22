Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaGVJrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:47:53 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46170 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaGVJru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:47:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] phy: miphy365x: Select GENERIC_PHY instead of depending on it
Date: Tue, 22 Jul 2014 10:47:37 +0100
Message-Id: <1406022457-9350-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling GENERIC_PHY in the shared (by most ARM sub-architectures)
defconfig multi_v7_defconfig is prohibited.  Instead, we'll enable
it from the Kconfig whenever PHY_MIPHY365X is enabled.

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5d54dcf..75cb9bc 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -34,9 +34,9 @@ config PHY_MVEBU_SATA
 config PHY_MIPHY365X
 	tristate "STMicroelectronics MIPHY365X PHY driver for STiH41x series"
 	depends on ARCH_STI
-	depends on GENERIC_PHY
 	depends on HAS_IOMEM
 	depends on OF
+	select GENERIC_PHY
 	help
 	  Enable this to support the miphy transceiver (for SATA/PCIE)
 	  that is part of STMicroelectronics STiH41x SoC series.
-- 
1.8.3.2

