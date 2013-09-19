Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3ISVFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:05:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33846 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3ISVFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:05:15 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/3] PM / OPP: rename header to linux/pm_opp.h
Date: Thu, 19 Sep 2013 16:03:52 -0500
Message-ID: <1379624632-17356-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379624632-17356-1-git-send-email-nm@ti.com>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Operating Performance Points(OPP) functions are specific to
device specific power management, be specific and rename opp.h
to pm_opp.h

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/power/opp.txt             |    2 +-
 arch/arm/mach-imx/mach-imx6q.c          |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c |    2 +-
 arch/arm/mach-omap2/omap-pm.h           |    2 +-
 arch/arm/mach-omap2/opp.c               |    2 +-
 arch/arm/mach-omap2/pm.c                |    2 +-
 drivers/base/power/opp.c                |    2 +-
 drivers/cpufreq/arm_big_little.c        |    2 +-
 drivers/cpufreq/arm_big_little_dt.c     |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c          |    2 +-
 drivers/cpufreq/exynos5440-cpufreq.c    |    2 +-
 drivers/cpufreq/imx6q-cpufreq.c         |    2 +-
 drivers/cpufreq/omap-cpufreq.c          |    2 +-
 drivers/devfreq/devfreq.c               |    2 +-
 drivers/devfreq/exynos/exynos4_bus.c    |    2 +-
 drivers/devfreq/exynos/exynos5_bus.c    |    4 ++--
 include/linux/devfreq.h                 |    2 +-
 include/linux/{opp.h => pm_opp.h}       |    0
 18 files changed, 18 insertions(+), 18 deletions(-)
 rename include/linux/{opp.h => pm_opp.h} (100%)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 7f67e3d..b8a907d 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -42,7 +42,7 @@ We can represent these as three OPPs as the following {Hz, uV} tuples:
 
 OPP library provides a set of helper functions to organize and query the OPP
 information. The library is located in drivers/base/power/opp.c and the header
-is located in include/linux/opp.h. OPP library can be enabled by enabling
+is located in include/linux/pm_opp.h. OPP library can be enabled by enabling
 CONFIG_PM_OPP from power management menuconfig menu. OPP library depends on
 CONFIG_PM as certain SoCs such as Texas Instrument's OMAP framework allows to
 optionally boot at a certain OPP without needing cpufreq.
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index dfbf6f2..86dea10 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -25,7 +25,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/phy.h>
 #include <linux/reboot.h>
 #include <linux/regmap.h>
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 33969e5..6432ab8 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -25,7 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/cpu.h>
 
 #include <linux/mtd/mtd.h>
diff --git a/arch/arm/mach-omap2/omap-pm.h b/arch/arm/mach-omap2/omap-pm.h
index 67faa7b..1d777e6 100644
--- a/arch/arm/mach-omap2/omap-pm.h
+++ b/arch/arm/mach-omap2/omap-pm.h
@@ -17,7 +17,7 @@
 #include <linux/device.h>
 #include <linux/cpufreq.h>
 #include <linux/clk.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 
 /*
  * agent_id values for use with omap_pm_set_min_bus_tput():
diff --git a/arch/arm/mach-omap2/opp.c b/arch/arm/mach-omap2/opp.c
index 7b04637..ec21e6e 100644
--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@ -17,7 +17,7 @@
  * GNU General Public License for more details.
  */
 #include <linux/module.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/cpu.h>
 
 #include "omap_device.h"
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 92901bd..2f569b3 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/err.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/export.h>
 #include <linux/suspend.h>
 #include <linux/cpu.h>
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 693e14a..fa41874 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -21,7 +21,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/of.h>
 #include <linux/export.h>
 
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 9e82a9d..e010fb7 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -25,7 +25,7 @@
 #include <linux/cpumask.h>
 #include <linux/export.h>
 #include <linux/of_platform.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/topology.h>
 #include <linux/types.h>
diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index 480c0bd..8d9d591 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -24,7 +24,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/types.h>
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ac67ea7..61cdc25 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -16,7 +16,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 070923e..a684b47 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -20,7 +20,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 0a3b59d..51e4369 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -12,7 +12,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index f057d42..20190f5 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -22,7 +22,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 03530a0..2e23b12 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/devfreq.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 891becd..cede6f7 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -19,7 +19,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/suspend.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/devfreq.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index d06232a..52835f12 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -15,10 +15,10 @@
 #include <linux/module.h>
 #include <linux/devfreq.h>
 #include <linux/io.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index c8c9953..7a7cc74 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -15,7 +15,7 @@
 
 #include <linux/device.h>
 #include <linux/notifier.h>
-#include <linux/opp.h>
+#include <linux/pm_opp.h>
 
 #define DEVFREQ_NAME_LEN 16
 
diff --git a/include/linux/opp.h b/include/linux/pm_opp.h
similarity index 100%
rename from include/linux/opp.h
rename to include/linux/pm_opp.h
-- 
1.7.9.5

