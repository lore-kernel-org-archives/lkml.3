Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3JDMid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:38:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29159 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3JDMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:38:31 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e4-524eb6c69956
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] thermal: EXYNOS: always register TMU driver with core thermal
 framework
Date: Fri, 04 Oct 2013 14:38:25 +0200
Message-id: <2244251.cWS1a83qbK@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd1j2/yCDP68lrdouBpisWb/TyaL
	s01v2C0u75rDZvG59wijxYzz+5gsnjzsY3Ng91i85yWTR9+WVYwex29sZ/L4vEkugCWKyyYl
	NSezLLVI3y6BK2PJjR3sBcslKzY9/8rYwLhdtIuRk0NCwERi0pvFTBC2mMSFe+vZQGwhgemM
	ErP6E7oYuYDsFiaJuf3PwYrYBKwkJravYgSxRQT0JG68eAIWZxa4xyhx8UsWiC0sECXx7sox
	dhCbRUBV4v6DJ8wgNq+ApsSV59fB4qICnhKfJi2FigtK/Jh8jwVijrzEvv1TWSFsLYn1O48z
	TWDkm4WkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7UZ9I7GFc1WBxi
	FOBgVOLh3VDsGyTEmlhWXJl7iFGCg1lJhPf4JL8gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwH
	W60DhQTSE0tSs1NTC1KLYLJMHJxSDYwrlund+BC1f+WOu2HxV+O+xmUpbo26tO/U3+mRO9Pv
	l/Dbe/V3Pnm+wnfybDurJ2+XTGap3SH3hqmRZ8HJX79O1K+a4BEefOzPhMR/ek/Zt3gwXWti
	zTWt6Dg9LXbPWjmWhUKmnXNubk9YadH18Fv8rbj2x5JLQn9erNt/rqx0zsFN/htCr73qUGIp
	zkg01GIuKk4EAFPl3zFQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is little sense in having separate config option for
registering EXYNOS TMU driver with the core thermal framework.
Fix it by integrating EXYNOS_THERMAL_CORE config option with
EXYNOS_THERMAL one.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/Kconfig                 | 14 +++-----------
 drivers/thermal/samsung/Makefile                |  2 +-
 drivers/thermal/samsung/exynos_thermal_common.h | 12 ------------
 3 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
index f760389..04eabee 100644
--- a/drivers/thermal/samsung/Kconfig
+++ b/drivers/thermal/samsung/Kconfig
@@ -5,14 +5,6 @@ config EXYNOS_THERMAL
 	  If you say yes here you get support for the TMU (Thermal Management
 	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initialises
 	  the TMU, reports temperature and handles cooling action if defined.
-	  This driver uses the Exynos core thermal APIs and TMU configuration
-	  data from the supported SoCs.
-
-config EXYNOS_THERMAL_CORE
-	bool "Core thermal framework support for EXYNOS SOCs"
-	depends on EXYNOS_THERMAL
-	help
-	  If you say yes here you get support for EXYNOS TMU
-	  (Thermal Management Unit) common registration/unregistration
-	  functions to the core thermal layer and also to use the generic
-	  CPU cooling APIs.
+	  This driver uses the Exynos core thermal APIs, TMU configuration data
+	  from the supported SoCs, common registration/unregistration functions
+	  to the core thermal layer and also the generic CPU cooling APIs.
diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
index c09d830..a829107 100644
--- a/drivers/thermal/samsung/Makefile
+++ b/drivers/thermal/samsung/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_EXYNOS_THERMAL)			+= exynos_thermal.o
 exynos_thermal-y				:= exynos_tmu.o
 exynos_thermal-y				+= exynos_tmu_data.o
-exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+= exynos_thermal_common.o
+exynos_thermal-y				+= exynos_thermal_common.o
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 3eb2ed9..8681679 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -88,20 +88,8 @@ struct thermal_sensor_conf {
 	struct device *dev;
 };
 
-/*Functions used exynos based thermal sensor driver*/
-#ifdef CONFIG_EXYNOS_THERMAL_CORE
 void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
 int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
 void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
-#else
-static inline void
-exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf) { return; }
 
-static inline int
-exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { return 0; }
-
-static inline void
-exynos_report_trigger(struct thermal_sensor_conf *sensor_conf) { return; }
-
-#endif /* CONFIG_EXYNOS_THERMAL_CORE */
 #endif /* _EXYNOS_THERMAL_COMMON_H */
-- 
1.8.2.3


