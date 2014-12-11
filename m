Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbaLKPyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:54:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:38399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117AbaLKPyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:54:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,558,1413270000"; 
   d="scan'208";a="652301875"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/4] mfd: change a layout for the Intel related drivers
Date: Thu, 11 Dec 2014 17:53:53 +0200
Message-Id: <1418313236-10764-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of keeping everything in one folder with long prefixes let us to reoder
files in the tree by moving them in the dedicated folder. Currently we have
drivers for Intel MID platforms, LPC, and few more are coming.

This patch creates a new layout and moves intel_msic driver to it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_msic.c      |  2 +-
 .../x86/platform/intel-mid/device_libs/platform_msic_audio.c |  2 +-
 .../platform/intel-mid/device_libs/platform_msic_battery.c   |  2 +-
 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c |  2 +-
 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c  |  2 +-
 .../platform/intel-mid/device_libs/platform_msic_power_btn.c |  2 +-
 .../platform/intel-mid/device_libs/platform_msic_thermal.c   |  2 +-
 drivers/gpio/gpio-msic.c                                     |  2 +-
 drivers/mfd/Kconfig                                          | 12 +++---------
 drivers/mfd/Makefile                                         |  3 ++-
 drivers/mfd/intel/Kconfig                                    |  5 +++++
 drivers/mfd/intel/Makefile                                   |  5 +++++
 drivers/mfd/intel/mid/Kconfig                                |  8 ++++++++
 drivers/mfd/intel/mid/Makefile                               |  1 +
 drivers/mfd/{intel_msic.c => intel/mid/msic.c}               |  2 +-
 drivers/platform/x86/intel_mid_powerbtn.c                    |  2 +-
 drivers/platform/x86/intel_mid_thermal.c                     |  2 +-
 include/linux/mfd/{intel_msic.h => intel/msic.h}             |  2 +-
 18 files changed, 36 insertions(+), 22 deletions(-)
 create mode 100644 drivers/mfd/intel/Kconfig
 create mode 100644 drivers/mfd/intel/Makefile
 create mode 100644 drivers/mfd/intel/mid/Kconfig
 create mode 100644 drivers/mfd/intel/mid/Makefile
 rename drivers/mfd/{intel_msic.c => intel/mid/msic.c} (99%)
 rename include/linux/mfd/{intel_msic.h => intel/msic.h} (99%)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.c b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
index 9f4a775..21ec3ee 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
@@ -15,7 +15,7 @@
 #include <linux/scatterlist.h>
 #include <linux/init.h>
 #include <linux/sfi.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel_scu_ipc.h>
 #include <asm/intel-mid.h>
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
index 2962939..45e1c493 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
@@ -16,7 +16,7 @@
 #include <linux/init.h>
 #include <linux/sfi.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
index f446c33..8a6ce11 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
@@ -15,7 +15,7 @@
 #include <linux/scatterlist.h>
 #include <linux/init.h>
 #include <linux/sfi.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
index 2a4f7b1..1c0e957 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
@@ -16,7 +16,7 @@
 #include <linux/sfi.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
index 6497111..52bb772 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
@@ -16,7 +16,7 @@
 #include <linux/sfi.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
index 83a3459..d3633709 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
@@ -14,7 +14,7 @@
 #include <linux/scatterlist.h>
 #include <linux/sfi.h>
 #include <linux/init.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
index a351878..3c7c7b2 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <asm/intel-mid.h>
 
 #include "platform_msic.h"
diff --git a/drivers/gpio/gpio-msic.c b/drivers/gpio/gpio-msic.c
index 01acf0a..bfcae0f 100644
--- a/drivers/gpio/gpio-msic.c
+++ b/drivers/gpio/gpio-msic.c
@@ -27,7 +27,7 @@
 #include <linux/init.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 
 /* the offset for the mapping of global gpio pin to irq */
 #define MSIC_GPIO_IRQ_OFFSET	0x100
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2e6b731..729e9cd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -301,15 +301,6 @@ config INTEL_SOC_PMIC
 	  thermal, charger and related power management functions
 	  on these systems.
 
-config MFD_INTEL_MSIC
-	bool "Intel MSIC"
-	depends on INTEL_SCU_IPC
-	select MFD_CORE
-	help
-	  Select this option to enable access to Intel MSIC (Avatele
-	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
-	  devices used in Intel Medfield platforms.
-
 config MFD_IPAQ_MICRO
 	bool "Atmel Micro ASIC (iPAQ h3100/h3600/h3700) Support"
 	depends on SA1100_H3100 || SA1100_H3600
@@ -1376,4 +1367,7 @@ config MFD_VEXPRESS_SYSREG
 	  on the ARM Ltd. Versatile Express board.
 
 endmenu
+
+source "drivers/mfd/intel/Kconfig"
+
 endif
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e2..11e1945e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -158,7 +158,6 @@ obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
 obj-$(CONFIG_MFD_ATMEL_HLCDC)	+= atmel-hlcdc.o
-obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
 obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
 obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
@@ -177,5 +176,7 @@ obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
 obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
 obj-$(CONFIG_MFD_DLN2)		+= dln2.o
 
+obj-y				+= intel/
+
 intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
 obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/intel/Kconfig b/drivers/mfd/intel/Kconfig
new file mode 100644
index 0000000..9e376b0
--- /dev/null
+++ b/drivers/mfd/intel/Kconfig
@@ -0,0 +1,5 @@
+#
+# Multifunction devices found on Intel platforms
+#
+
+source "drivers/mfd/intel/mid/Kconfig"
diff --git a/drivers/mfd/intel/Makefile b/drivers/mfd/intel/Makefile
new file mode 100644
index 0000000..8d6b43b
--- /dev/null
+++ b/drivers/mfd/intel/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for multifunction devices found on Intel platforms
+#
+
+obj-y	+= mid/
diff --git a/drivers/mfd/intel/mid/Kconfig b/drivers/mfd/intel/mid/Kconfig
new file mode 100644
index 0000000..a212f62
--- /dev/null
+++ b/drivers/mfd/intel/mid/Kconfig
@@ -0,0 +1,8 @@
+config MFD_INTEL_MSIC
+	bool "Intel MSIC"
+	depends on INTEL_SCU_IPC
+	select MFD_CORE
+	help
+	  Select this option to enable access to Intel MSIC (Avatele
+	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
+	  devices used in Intel Medfield platforms.
diff --git a/drivers/mfd/intel/mid/Makefile b/drivers/mfd/intel/mid/Makefile
new file mode 100644
index 0000000..e36bfa3
--- /dev/null
+++ b/drivers/mfd/intel/mid/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MFD_INTEL_MSIC)	+= msic.o
diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel/mid/msic.c
similarity index 99%
rename from drivers/mfd/intel_msic.c
rename to drivers/mfd/intel/mid/msic.c
index 25d486c..7ef98b4 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel/mid/msic.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/mfd/core.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 22606d6..b701f88 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -23,7 +23,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 
 #define DRIVER_NAME "msic_power_btn"
 
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index 0944e83..d9dc468 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -33,7 +33,7 @@
 #include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/thermal.h>
-#include <linux/mfd/intel_msic.h>
+#include <linux/mfd/intel/msic.h>
 
 /* Number of thermal sensors */
 #define MSIC_THERMAL_SENSORS	4
diff --git a/include/linux/mfd/intel_msic.h b/include/linux/mfd/intel/msic.h
similarity index 99%
rename from include/linux/mfd/intel_msic.h
rename to include/linux/mfd/intel/msic.h
index 439a7a6..04c1925 100644
--- a/include/linux/mfd/intel_msic.h
+++ b/include/linux/mfd/intel/msic.h
@@ -1,5 +1,5 @@
 /*
- * include/linux/mfd/intel_msic.h - Core interface for Intel MSIC
+ * include/linux/mfd/intel/msic.h - Core interface for Intel MSIC
  *
  * Copyright (C) 2011, Intel Corporation
  * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
-- 
2.1.3

