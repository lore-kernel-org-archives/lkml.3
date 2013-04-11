Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937777Ab3DKAMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:12:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937370Ab3DKAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: [PATCH 09/30] mmc: sdhci-s3c: remove platform dependencies
Date: Thu, 11 Apr 2013 02:04:51 +0200
Message-Id: <1365638712-1028578-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:J7w7k3Wz3wlT1/mzm5VJTPANa6x3F/AhvRxasiEwtyf
 fGixyNN5LvQX9iP6oIMdHDhkhcPb5tiWJPcfMJ3IdviAk/LPy8
 z4sj/6NcJbgE4Lu4ppKt9EHhGy9+oa5KPRKuKNYY9ZkMl1QfTk
 XBGkhG6aa1d0lYqRaaSyPaTZSnil7ZymjZq5xYDbpGEXYdn9A0
 vl5nmaTqMHdv0kDrNAWWjyvlYt4EwuQSSanv7YGjeC3ajmIau7
 t/RZo/CyWuBsXqGb9y/kqHwPlYKbAhHKpFmgyrYe2U6DaApmn6
 C/S0IWrYXKLsNLIWSKfiIqPsKJxTfCP1f92Y7COKE0f08OAE9f
 C7GFC0zarkhtvCQs78bLB6eaAHAc7sBrdrisWJWrpg1+St8ILl
 /2Yp9oTEXmA8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

plat/regs-sdhci.h is not used anywhere but in the sdhci-s3c
driver, so it can become a local file there and all other
inclusions removed.

plat/sdhci.h is used only to define the platform devices,
and with the exception of the platform_data structure not
needed by the driver, so we can split out the platform_data
definition instead and leave the rest to platform code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>
---
 arch/arm/mach-exynos/setup-sdhci-gpio.c            |  2 +-
 arch/arm/mach-s5pc100/setup-sdhci-gpio.c           |  1 -
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c           |  1 -
 arch/arm/plat-samsung/include/plat/sdhci.h         | 56 +---------------------
 drivers/mmc/host/Kconfig                           |  2 +-
 .../mmc/host/sdhci-s3c-regs.h                      |  0
 drivers/mmc/host/sdhci-s3c.c                       |  5 +-
 include/linux/platform_data/mmc-sdhci-s3c.h        | 56 ++++++++++++++++++++++
 8 files changed, 61 insertions(+), 62 deletions(-)
 rename arch/arm/plat-samsung/include/plat/regs-sdhci.h => drivers/mmc/host/sdhci-s3c-regs.h (100%)
 create mode 100644 include/linux/platform_data/mmc-sdhci-s3c.h

diff --git a/arch/arm/mach-exynos/setup-sdhci-gpio.c b/arch/arm/mach-exynos/setup-sdhci-gpio.c
index e8d08bf..d5b98c8 100644
--- a/arch/arm/mach-exynos/setup-sdhci-gpio.c
+++ b/arch/arm/mach-exynos/setup-sdhci-gpio.c
@@ -19,8 +19,8 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
 
+#include <mach/gpio.h>
 #include <plat/gpio-cfg.h>
-#include <plat/regs-sdhci.h>
 #include <plat/sdhci.h>
 
 void exynos4_setup_sdhci0_cfg_gpio(struct platform_device *dev, int width)
diff --git a/arch/arm/mach-s5pc100/setup-sdhci-gpio.c b/arch/arm/mach-s5pc100/setup-sdhci-gpio.c
index 03c02d0..6010c03 100644
--- a/arch/arm/mach-s5pc100/setup-sdhci-gpio.c
+++ b/arch/arm/mach-s5pc100/setup-sdhci-gpio.c
@@ -19,7 +19,6 @@
 #include <linux/mmc/card.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/regs-sdhci.h>
 #include <plat/sdhci.h>
 
 void s5pc100_setup_sdhci0_cfg_gpio(struct platform_device *dev, int width)
diff --git a/arch/arm/mach-s5pv210/setup-sdhci-gpio.c b/arch/arm/mach-s5pv210/setup-sdhci-gpio.c
index 3e3ac05..0512ada 100644
--- a/arch/arm/mach-s5pv210/setup-sdhci-gpio.c
+++ b/arch/arm/mach-s5pv210/setup-sdhci-gpio.c
@@ -20,7 +20,6 @@
 #include <linux/mmc/card.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/regs-sdhci.h>
 #include <plat/sdhci.h>
 
 void s5pv210_setup_sdhci0_cfg_gpio(struct platform_device *dev, int width)
diff --git a/arch/arm/plat-samsung/include/plat/sdhci.h b/arch/arm/plat-samsung/include/plat/sdhci.h
index 5560586..ce1d0f7 100644
--- a/arch/arm/plat-samsung/include/plat/sdhci.h
+++ b/arch/arm/plat-samsung/include/plat/sdhci.h
@@ -18,62 +18,9 @@
 #ifndef __PLAT_S3C_SDHCI_H
 #define __PLAT_S3C_SDHCI_H __FILE__
 
+#include <linux/platform_data/mmc-sdhci-s3c.h>
 #include <plat/devs.h>
 
-struct platform_device;
-struct mmc_host;
-struct mmc_card;
-struct mmc_ios;
-
-enum cd_types {
-	S3C_SDHCI_CD_INTERNAL,	/* use mmc internal CD line */
-	S3C_SDHCI_CD_EXTERNAL,	/* use external callback */
-	S3C_SDHCI_CD_GPIO,	/* use external gpio pin for CD line */
-	S3C_SDHCI_CD_NONE,	/* no CD line, use polling to detect card */
-	S3C_SDHCI_CD_PERMANENT,	/* no CD line, card permanently wired to host */
-};
-
-/**
- * struct s3c_sdhci_platdata() - Platform device data for Samsung SDHCI
- * @max_width: The maximum number of data bits supported.
- * @host_caps: Standard MMC host capabilities bit field.
- * @host_caps2: The second standard MMC host capabilities bit field.
- * @cd_type: Type of Card Detection method (see cd_types enum above)
- * @ext_cd_init: Initialize external card detect subsystem. Called on
- *		 sdhci-s3c driver probe when cd_type == S3C_SDHCI_CD_EXTERNAL.
- *		 notify_func argument is a callback to the sdhci-s3c driver
- *		 that triggers the card detection event. Callback arguments:
- *		 dev is pointer to platform device of the host controller,
- *		 state is new state of the card (0 - removed, 1 - inserted).
- * @ext_cd_cleanup: Cleanup external card detect subsystem. Called on
- *		 sdhci-s3c driver remove when cd_type == S3C_SDHCI_CD_EXTERNAL.
- *		 notify_func argument is the same callback as for ext_cd_init.
- * @ext_cd_gpio: gpio pin used for external CD line, valid only if
- *		 cd_type == S3C_SDHCI_CD_GPIO
- * @ext_cd_gpio_invert: invert values for external CD gpio line
- * @cfg_gpio: Configure the GPIO for a specific card bit-width
- *
- * Initialisation data specific to either the machine or the platform
- * for the device driver to use or call-back when configuring gpio or
- * card speed information.
-*/
-struct s3c_sdhci_platdata {
-	unsigned int	max_width;
-	unsigned int	host_caps;
-	unsigned int	host_caps2;
-	unsigned int	pm_caps;
-	enum cd_types	cd_type;
-
-	int		ext_cd_gpio;
-	bool		ext_cd_gpio_invert;
-	int	(*ext_cd_init)(void (*notify_func)(struct platform_device *,
-						   int state));
-	int	(*ext_cd_cleanup)(void (*notify_func)(struct platform_device *,
-						      int state));
-
-	void	(*cfg_gpio)(struct platform_device *dev, int width);
-};
-
 /* s3c_sdhci_set_platdata() - common helper for setting SDHCI platform data
  * @pd: The default platform data for this device.
  * @set: Pointer to the platform data to fill in.
@@ -378,5 +325,4 @@ static inline void s3c_sdhci_setname(int id, char *name)
 		break;
 	}
 }
-
 #endif /* __PLAT_S3C_SDHCI_H */
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index d88219e..d054744 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -180,7 +180,7 @@ config MMC_SDHCI_TEGRA
 
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
-	depends on MMC_SDHCI && PLAT_SAMSUNG
+	depends on MMC_SDHCI && PLAT_SAMSUNG_SINGLE
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  often referrered to as the HSMMC block in some of the Samsung S3C
diff --git a/arch/arm/plat-samsung/include/plat/regs-sdhci.h b/drivers/mmc/host/sdhci-s3c-regs.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/regs-sdhci.h
rename to drivers/mmc/host/sdhci-s3c-regs.h
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 7363efe..e4f52b5 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+#include <linux/platform_data/mmc-sdhci-s3c.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -28,9 +29,7 @@
 
 #include <linux/mmc/host.h>
 
-#include <plat/sdhci.h>
-#include <plat/regs-sdhci.h>
-
+#include "sdhci-s3c-regs.h"
 #include "sdhci.h"
 
 #define MAX_BUS_CLK	(4)
diff --git a/include/linux/platform_data/mmc-sdhci-s3c.h b/include/linux/platform_data/mmc-sdhci-s3c.h
new file mode 100644
index 0000000..249f023
--- /dev/null
+++ b/include/linux/platform_data/mmc-sdhci-s3c.h
@@ -0,0 +1,56 @@
+#ifndef __PLATFORM_DATA_SDHCI_S3C_H
+#define __PLATFORM_DATA_SDHCI_S3C_H
+
+struct platform_device;
+
+enum cd_types {
+	S3C_SDHCI_CD_INTERNAL,	/* use mmc internal CD line */
+	S3C_SDHCI_CD_EXTERNAL,	/* use external callback */
+	S3C_SDHCI_CD_GPIO,	/* use external gpio pin for CD line */
+	S3C_SDHCI_CD_NONE,	/* no CD line, use polling to detect card */
+	S3C_SDHCI_CD_PERMANENT,	/* no CD line, card permanently wired to host */
+};
+
+/**
+ * struct s3c_sdhci_platdata() - Platform device data for Samsung SDHCI
+ * @max_width: The maximum number of data bits supported.
+ * @host_caps: Standard MMC host capabilities bit field.
+ * @host_caps2: The second standard MMC host capabilities bit field.
+ * @cd_type: Type of Card Detection method (see cd_types enum above)
+ * @ext_cd_init: Initialize external card detect subsystem. Called on
+ *		 sdhci-s3c driver probe when cd_type == S3C_SDHCI_CD_EXTERNAL.
+ *		 notify_func argument is a callback to the sdhci-s3c driver
+ *		 that triggers the card detection event. Callback arguments:
+ *		 dev is pointer to platform device of the host controller,
+ *		 state is new state of the card (0 - removed, 1 - inserted).
+ * @ext_cd_cleanup: Cleanup external card detect subsystem. Called on
+ *		 sdhci-s3c driver remove when cd_type == S3C_SDHCI_CD_EXTERNAL.
+ *		 notify_func argument is the same callback as for ext_cd_init.
+ * @ext_cd_gpio: gpio pin used for external CD line, valid only if
+ *		 cd_type == S3C_SDHCI_CD_GPIO
+ * @ext_cd_gpio_invert: invert values for external CD gpio line
+ * @cfg_gpio: Configure the GPIO for a specific card bit-width
+ *
+ * Initialisation data specific to either the machine or the platform
+ * for the device driver to use or call-back when configuring gpio or
+ * card speed information.
+*/
+struct s3c_sdhci_platdata {
+	unsigned int	max_width;
+	unsigned int	host_caps;
+	unsigned int	host_caps2;
+	unsigned int	pm_caps;
+	enum cd_types	cd_type;
+
+	int		ext_cd_gpio;
+	bool		ext_cd_gpio_invert;
+	int	(*ext_cd_init)(void (*notify_func)(struct platform_device *,
+						   int state));
+	int	(*ext_cd_cleanup)(void (*notify_func)(struct platform_device *,
+						      int state));
+
+	void	(*cfg_gpio)(struct platform_device *dev, int width);
+};
+
+
+#endif /* __PLATFORM_DATA_SDHCI_S3C_H */
-- 
1.8.1.2

