Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbaEPNFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:05:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58924 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbaEPNDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:25 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/11] phy: kona2: use 'select GENERIC_PHY' in Kconfig
Date: Fri, 16 May 2014 18:33:00 +0530
Message-ID: <1400245387-14445-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

All other phy drivers use 'select', while this one is
the only one to use 'depends on'. This is not a bug, just
slightly inconsistent, so let's change it to do things the
same way as everyone else.

We may also want to turn GENERIC_PHY into a silent option
that only ever gets turned on if another driver needs it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Matt Porter <mporter@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 4906c27..071b763 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -89,8 +89,8 @@ config PHY_EXYNOS_DP_VIDEO
 
 config BCM_KONA_USB2_PHY
 	tristate "Broadcom Kona USB2 PHY Driver"
-	depends on GENERIC_PHY
 	depends on HAS_IOMEM
+	select GENERIC_PHY
 	help
 	  Enable this to support the Broadcom Kona USB 2.0 PHY.
 
-- 
1.7.9.5

