Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3EGNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:01:38 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52922 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3EGNBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:01:36 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 01/21] thermal: exynos: Moving exynos thermal files into samsung directory
Date: Tue,  7 May 2013 18:30:51 +0530
Message-Id: <1367931671-3906-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This movement of files is done for easy maintenance and adding more
new sensor's support for exynos platform easily . This will also help in
bifurcating exynos common, sensor driver and sensor data related parts.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/Kconfig                        |   13 +++++--------
 drivers/thermal/Makefile                       |    2 +-
 drivers/thermal/samsung/Kconfig                |    9 +++++++++
 drivers/thermal/samsung/Makefile               |    4 ++++
 drivers/thermal/{ => samsung}/exynos_thermal.c |    0
 5 files changed, 19 insertions(+), 9 deletions(-)
 create mode 100644 drivers/thermal/samsung/Kconfig
 create mode 100644 drivers/thermal/samsung/Makefile
 rename drivers/thermal/{ => samsung}/exynos_thermal.c (100%)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 5e3c025..081ddc5 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -114,14 +114,6 @@ config KIRKWOOD_THERMAL
 	  Support for the Kirkwood thermal sensor driver into the Linux thermal
 	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
 
-config EXYNOS_THERMAL
-	tristate "Temperature sensor on Samsung EXYNOS"
-	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
-	depends on CPU_THERMAL
-	help
-	  If you say yes here you get support for TMU (Thermal Management
-	  Unit) on SAMSUNG EXYNOS series of SoC.
-
 config DOVE_THERMAL
 	tristate "Temperature sensor on Marvell Dove SoCs"
 	depends on ARCH_DOVE
@@ -169,4 +161,9 @@ config INTEL_POWERCLAMP
 	  enforce idle time which results in more package C-state residency. The
 	  user interface is exposed via generic thermal framework.
 
+menu "Exynos thermal drivers"
+depends on PLAT_SAMSUNG
+source "drivers/thermal/samsung/Kconfig"
+endmenu
+
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index c054d41..b3063a9 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -17,7 +17,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
-obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
+obj-y				+= samsung/
 obj-$(CONFIG_DOVE_THERMAL)  	+= dove_thermal.o
 obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
 obj-$(CONFIG_ARMADA_THERMAL)	+= armada_thermal.o
diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
new file mode 100644
index 0000000..2d3d9dc
--- /dev/null
+++ b/drivers/thermal/samsung/Kconfig
@@ -0,0 +1,9 @@
+config EXYNOS_THERMAL
+	tristate "Temperature sensor on Samsung EXYNOS"
+	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
+	depends on CPU_THERMAL
+	help
+	  If you say yes here you get support for TMU (Thermal Management
+	  Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
+	  the exynos thermal driver with the core thermal layer and cpu
+	  cooling API's.
diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
new file mode 100644
index 0000000..1fe6d93
--- /dev/null
+++ b/drivers/thermal/samsung/Makefile
@@ -0,0 +1,4 @@
+#
+# Samsung thermal specific Makefile
+#
+obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/samsung/exynos_thermal.c
similarity index 100%
rename from drivers/thermal/exynos_thermal.c
rename to drivers/thermal/samsung/exynos_thermal.c
-- 
1.7.1

