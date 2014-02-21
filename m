Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaBUPuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:50:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49111 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaBUPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:50:20 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-1a-530775ba843c
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/2] phy: Select PHY_EXYNOS_MIPI_VIDEO by default for
 ARCH_EXYNOS
Date: Fri, 21 Feb 2014 16:50:01 +0100
Message-id: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsVy+t9jAd1dpezBBjv3mlpcXniJ1eLC0x42
	i02Pr7FaXN41h81ixvl9TBaH37SzOrB5bF5S79G3ZRWjx/Eb25k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4MqY/jau4DBnRe+xFYwNjI/Yuxg5OSQETCR2nWxhhbDFJC7cW8/WxcjFISSwiFFi+88V
	jBBOB5PE9E+rGEGq2AQMJXqP9gHZHBwiAoISnz6BhZkF1jNK3PtjBmILC4RJfJv9jQXEZhFQ
	lfj+7BVYDa+Am8SFac2sIK0SAgoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOBSeSe9gXNVgcYhRgINRiYfXIZU9WIg1say4MvcQowQHs5IIb3M0UIg3JbGyKrUoP76o
	NCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAPj/INqXAfCT3E0mk448KGr6+an
	0raVv6U3nUz9377yk7qC+G5Ns9u77Y7fMN9vNym4LNVvVdlbx6QpRR5LVq1TaDDZ/mB79h5f
	A5OOEMOn3XtjDTuf8YYFG/g/WOD13JMhXW7Vp+b/p+dKXOd56Op64PEzjbkS97Zem79o9eZ6
	uQXvGVetddXoVGIpzkg01GIuKk4EAHoc9e0BAgAA
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
Changes since first version:
 - use ARCH_EXYNOS instead of "ARCH_EXYNOS4 || ARCH_EXYNOS5"
 - add dependency on COMPILE_TEST, and ARCH_S5PV210 for
   PHY_EXYNOS_MIPI_VIDEO
---
 drivers/phy/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index afa2354..ebd455c 100644
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
+	default y
 	help
 	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
 	  and EXYNOS SoCs.
-- 
1.7.9.5

