Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbaLKPx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:53:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:43521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946AbaLKPx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:53:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427822951"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 4/4] mfd: intel/pmic: move driver to dedicated folder
Date: Thu, 11 Dec 2014 17:53:56 +0200
Message-Id: <1418313236-10764-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the intel_soc_pmic_*.c files to the dedicated folder and rename.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/pmic/intel_pmic_crc.c                       |  2 +-
 drivers/gpio/gpio-crystalcove.c                          |  2 +-
 drivers/mfd/Kconfig                                      | 12 ------------
 drivers/mfd/Makefile                                     |  3 ---
 drivers/mfd/intel/Kconfig                                | 12 ++++++++++++
 drivers/mfd/intel/Makefile                               |  3 +++
 drivers/mfd/{intel_soc_pmic_core.c => intel/pmic_core.c} |  7 ++++---
 drivers/mfd/{intel_soc_pmic_core.h => intel/pmic_core.h} |  2 +-
 drivers/mfd/{intel_soc_pmic_crc.c => intel/pmic_crc.c}   |  7 ++++---
 include/linux/mfd/{intel_soc_pmic.h => intel/pmic.h}     |  0
 10 files changed, 26 insertions(+), 24 deletions(-)
 rename drivers/mfd/{intel_soc_pmic_core.c => intel/pmic_core.c} (97%)
 rename drivers/mfd/{intel_soc_pmic_core.h => intel/pmic_core.h} (94%)
 rename drivers/mfd/{intel_soc_pmic_crc.c => intel/pmic_crc.c} (96%)
 rename include/linux/mfd/{intel_soc_pmic.h => intel/pmic.h} (100%)

diff --git a/drivers/acpi/pmic/intel_pmic_crc.c b/drivers/acpi/pmic/intel_pmic_crc.c
index ef7d8ff..f146fc2 100644
--- a/drivers/acpi/pmic/intel_pmic_crc.c
+++ b/drivers/acpi/pmic/intel_pmic_crc.c
@@ -15,7 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/acpi.h>
-#include <linux/mfd/intel_soc_pmic.h>
+#include <linux/mfd/intel/pmic.h>
 #include <linux/regmap.h>
 #include <linux/platform_device.h>
 #include "intel_pmic.h"
diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 55d4803..6ecddb4 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -21,7 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/regmap.h>
-#include <linux/mfd/intel_soc_pmic.h>
+#include <linux/mfd/intel/pmic.h>
 
 #define CRYSTALCOVE_GPIO_NUM	16
 #define CRYSTALCOVE_VGPIO_NUM	94
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c8dd9bf..0d9d508 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -271,18 +271,6 @@ config HTC_I2CPLD
 	  This device provides input and output GPIOs through an I2C
 	  interface to one or more sub-chips.
 
-config INTEL_SOC_PMIC
-	bool "Support for Intel Atom SoC PMIC"
-	depends on I2C=y
-	select MFD_CORE
-	select REGMAP_I2C
-	select REGMAP_IRQ
-	help
-	  Select this option to enable support for the PMIC device
-	  on some Intel SoC systems. The PMIC provides ADC, GPIO,
-	  thermal, charger and related power management functions
-	  on these systems.
-
 config MFD_IPAQ_MICRO
 	bool "Atmel Micro ASIC (iPAQ h3100/h3600/h3700) Support"
 	depends on SA1100_H3100 || SA1100_H3600
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 63f43ec..0979a73 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -175,6 +175,3 @@ obj-$(CONFIG_MFD_HI6421_PMIC)	+= hi6421-pmic-core.o
 obj-$(CONFIG_MFD_DLN2)		+= dln2.o
 
 obj-y				+= intel/
-
-intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
-obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/intel/Kconfig b/drivers/mfd/intel/Kconfig
index 5d2341f..5e86f3a 100644
--- a/drivers/mfd/intel/Kconfig
+++ b/drivers/mfd/intel/Kconfig
@@ -5,3 +5,15 @@
 source "drivers/mfd/intel/mid/Kconfig"
 
 source "drivers/mfd/intel/lpc/Kconfig"
+
+config INTEL_SOC_PMIC
+	bool "Support for Intel Atom SoC PMIC"
+	depends on I2C=y
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	help
+	  Select this option to enable support for the PMIC device
+	  on some Intel SoC systems. The PMIC provides ADC, GPIO,
+	  thermal, charger and related power management functions
+	  on these systems.
diff --git a/drivers/mfd/intel/Makefile b/drivers/mfd/intel/Makefile
index 8264a26..a9ab8f1 100644
--- a/drivers/mfd/intel/Makefile
+++ b/drivers/mfd/intel/Makefile
@@ -4,3 +4,6 @@
 
 obj-y	+= mid/
 obj-y	+= lpc/
+
+intel-soc-pmic-objs		:= pmic_core.o pmic_crc.o
+obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel/pmic_core.c
similarity index 97%
rename from drivers/mfd/intel_soc_pmic_core.c
rename to drivers/mfd/intel/pmic_core.c
index df7b064..c6e4f2b 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel/pmic_core.c
@@ -1,5 +1,5 @@
 /*
- * intel_soc_pmic_core.c - Intel SoC PMIC MFD Driver
+ * pmic_core.c - Intel SoC PMIC MFD Driver
  *
  * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
  *
@@ -23,8 +23,9 @@
 #include <linux/gpio/consumer.h>
 #include <linux/acpi.h>
 #include <linux/regmap.h>
-#include <linux/mfd/intel_soc_pmic.h>
-#include "intel_soc_pmic_core.h"
+#include <linux/mfd/intel/pmic.h>
+
+#include "pmic_core.h"
 
 /*
  * On some boards the PMIC interrupt may come from a GPIO line.
diff --git a/drivers/mfd/intel_soc_pmic_core.h b/drivers/mfd/intel/pmic_core.h
similarity index 94%
rename from drivers/mfd/intel_soc_pmic_core.h
rename to drivers/mfd/intel/pmic_core.h
index 33aacd9..f6535b0 100644
--- a/drivers/mfd/intel_soc_pmic_core.h
+++ b/drivers/mfd/intel/pmic_core.h
@@ -1,5 +1,5 @@
 /*
- * intel_soc_pmic_core.h - Intel SoC PMIC MFD Driver
+ * pmic_core.h - Intel SoC PMIC MFD Driver
  *
  * Copyright (C) 2012-2014 Intel Corporation. All rights reserved.
  *
diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel/pmic_crc.c
similarity index 96%
rename from drivers/mfd/intel_soc_pmic_crc.c
rename to drivers/mfd/intel/pmic_crc.c
index c85e2ec..888216c 100644
--- a/drivers/mfd/intel_soc_pmic_crc.c
+++ b/drivers/mfd/intel/pmic_crc.c
@@ -1,5 +1,5 @@
 /*
- * intel_soc_pmic_crc.c - Device access for Crystal Cove PMIC
+ * pmic_crc.c - Device access for Crystal Cove PMIC
  *
  * Copyright (C) 2013, 2014 Intel Corporation. All rights reserved.
  *
@@ -19,8 +19,9 @@
 #include <linux/mfd/core.h>
 #include <linux/interrupt.h>
 #include <linux/regmap.h>
-#include <linux/mfd/intel_soc_pmic.h>
-#include "intel_soc_pmic_core.h"
+#include <linux/mfd/intel/pmic.h>
+
+#include "pmic_core.h"
 
 #define CRYSTAL_COVE_MAX_REGISTER	0xC6
 
diff --git a/include/linux/mfd/intel_soc_pmic.h b/include/linux/mfd/intel/pmic.h
similarity index 100%
rename from include/linux/mfd/intel_soc_pmic.h
rename to include/linux/mfd/intel/pmic.h
-- 
2.1.3

