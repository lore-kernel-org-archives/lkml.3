Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbaBUQoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:44:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45903 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaBUQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:44:16 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-26-5307825f3352
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 1/2] phy: Select PHY_EXYNOS_MIPI_VIDEO by default for
 ARCH_EXYNOS
Date: Fri, 21 Feb 2014 17:44:01 +0100
Message-id: <1393001042-5951-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t9jQd34JvZgg6UvhSwuL7zEanHhaQ+b
	xabH11gtLu+aw2Yx4/w+JovDb9pZHdg8Ni+p9+jbsorR4/iN7UwenzfJBbBEcdmkpOZklqUW
	6dslcGWc3NLMXrCBq+Lps0NsDYy7OboYOTkkBEwk/jV0M0LYYhIX7q1nA7GFBKYzSmxZEdfF
	yAVkdzBJzFj3ngUkwSZgKNF7tA+ogYNDREBQ4tMnsF5mgfWMEvf+mIGEhQXCJG6tyQQJswio
	Shz4tp4ZxOYVcJX4PPcTM0iJhICCxJxJNhMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECA6EZ1I7GFc2WBxiFOBgVOLhdUhlDxZiTSwrrsw9xCjBwawkwtscDRTiTUmsrEotyo8v
	Ks1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuPFbs+h+KaY9a6XiHgqnvJ2o
	atHMWCHjujp4962tQadTmtdkrejd8CfqgCLv3twnTban30c9Wv3n7n2RhQsZFZfc7j3BMEvp
	+Kdk5nff5sbqHw5sS762fd6NJN4LDT0tr9fnBu3tjXVSyV60+PJEob2XLwp7xi5zPhT04bCm
	bfqxHYUe7WwO7kosxRmJhlrMRcWJAA3v7PAAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of requiring user to figure out when PHY_EXYNOS_MIPI_VIDEO needs
to be selected select it by default for Exynos SoCs. Also enable it when
COMPILE_TEST is selected. If required the MIPI CSIS/DPHY driver can be
then disabled or compiled in as module.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v2:
 - s/default y/default y if ARCH_S5PV210 || ARCH_EXYNOS

Changes since first version:
 - use ARCH_EXYNOS instead of "ARCH_EXYNOS4 || ARCH_EXYNOS5"
 - add dependency on COMPILE_TEST, and ARCH_S5PV210 for
   PHY_EXYNOS_MIPI_VIDEO
---
 drivers/phy/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index afa2354..d71be95 100644
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

