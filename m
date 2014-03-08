Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaCHJim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:38:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCHJ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/28] phy: Select PHY_EXYNOS_MIPI_VIDEO by default for ARCH_EXYNOS
Date: Sat, 8 Mar 2014 14:59:05 +0530
Message-ID: <1394270969-11851-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Instead of requiring user to figure out when PHY_EXYNOS_MIPI_VIDEO needs
to be selected select it by default for Exynos SoCs. Also enable it when
COMPILE_TEST is selected. If required the MIPI CSIS/DPHY driver can be
then disabled or compiled in as module.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index c7a551c..f0fb429 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -16,8 +16,11 @@ config GENERIC_PHY
 	  framework should select this config.
 
 config PHY_EXYNOS_MIPI_VIDEO
-	depends on HAS_IOMEM
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
+	depends on HAS_IOMEM
+	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
+	select GENERIC_PHY
+	default y if ARCH_S5PV210 || ARCH_EXYNOS
 	help
 	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
 	  and EXYNOS SoCs.
-- 
1.7.9.5

