Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaIKXRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:17:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:52851 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaIKXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,508,1406617200"; 
   d="scan'208";a="601722777"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3 1/5] mfd/axp20x: rename files to support more devices
Date: Thu, 11 Sep 2014 16:15:53 -0700
Message-Id: <1410477357-6407-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More XPowers PMIC devices can be supported by extending this driver, so
rename it to axp2xx to cover axp288 variant.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/mfd/Kconfig                      | 7 ++++---
 drivers/mfd/Makefile                     | 2 +-
 drivers/mfd/{axp20x.c => axp2xx.c}       | 6 +++---
 include/linux/mfd/{axp20x.h => axp2xx.h} | 6 +++---
 4 files changed, 11 insertions(+), 10 deletions(-)
 rename drivers/mfd/{axp20x.c => axp2xx.c} (97%)
 rename include/linux/mfd/{axp20x.h => axp2xx.h} (98%)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..42a70a3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -67,14 +67,15 @@ config MFD_BCM590XX
 	help
 	  Support for the BCM590xx PMUs from Broadcom
 
-config MFD_AXP20X
-	bool "X-Powers AXP20X"
+config MFD_AXP2XX
+	bool "X-Powers AXP2XX"
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	depends on I2C=y
 	help
-	  If you say Y here you get support for the X-Powers AXP202 and AXP209.
+	  If you say Y here you get support for the X-Powers AXP202, AXP209 and
+	  AXP288 power management IC (PMIC).
 	  This driver include only the core APIs. You have to select individual
 	  components like regulators or the PEK (Power Enable Key) under the
 	  corresponding menus.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3fcfdfc..8d0beb2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -103,7 +103,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-irq.o
 obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
-obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
+obj-$(CONFIG_MFD_AXP2XX)	+= axp2xx.o
 
 obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
 obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp2xx.c
similarity index 97%
rename from drivers/mfd/axp20x.c
rename to drivers/mfd/axp2xx.c
index dee6539..332a8a0 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp2xx.c
@@ -1,7 +1,7 @@
 /*
- * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
+ * axp2xx.c - MFD core driver for the X-Powers AXP202 and AXP209
  *
- * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
+ * AXP2xx comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
  * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current and temperature
  * as well as 4 configurable GPIOs.
  *
@@ -21,7 +21,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
-#include <linux/mfd/axp20x.h>
+#include <linux/mfd/axp2xx.h>
 #include <linux/mfd/core.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp2xx.h
similarity index 98%
rename from include/linux/mfd/axp20x.h
rename to include/linux/mfd/axp2xx.h
index d0e31a2..a36d91b 100644
--- a/include/linux/mfd/axp20x.h
+++ b/include/linux/mfd/axp2xx.h
@@ -8,8 +8,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __LINUX_MFD_AXP20X_H
-#define __LINUX_MFD_AXP20X_H
+#ifndef __LINUX_MFD_AXP2XX_H
+#define __LINUX_MFD_AXP2XX_H
 
 enum {
 	AXP202_ID = 0,
@@ -177,4 +177,4 @@ struct axp20x_dev {
 	long				variant;
 };
 
-#endif /* __LINUX_MFD_AXP20X_H */
+#endif /* __LINUX_MFD_AXP2XX_H */
-- 
1.9.1

