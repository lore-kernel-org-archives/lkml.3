Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700AbaH1K0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:26:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36572 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbaH1K0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:26:34 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] phy: miphy365x: Select GENERIC_PHY instead of depending on it
Date: Thu, 28 Aug 2014 15:55:06 +0530
Message-ID: <1409221506-6262-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409221506-6262-1-git-send-email-kishon@ti.com>
References: <1409221506-6262-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Enabling GENERIC_PHY in the shared (by most ARM sub-architectures)
defconfig multi_v7_defconfig is prohibited.  Instead, we'll enable
it from the Kconfig whenever PHY_MIPHY365X is enabled.

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0dd7427..4ff8cbb 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -41,9 +41,9 @@ config PHY_MVEBU_SATA
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
1.7.9.5

