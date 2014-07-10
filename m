Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaGJMHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:07:19 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:32771 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:07:17 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        t.figa@samsung.com, spk.linux@gmail.com, kgene.kim@samsung.com
Subject: [PATCH 1/1] pinctrl: samsung: Group all drivers in a sub-dir
Date: Thu, 10 Jul 2014 17:33:27 +0530
Message-Id: <1404993807-18598-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group all pin control drivers of Samsung platform together in
a sub-directory for easy maintenance.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
This patch has been inspired by a similar patch [1] from Linus Walleij for
Qualcomm drivers. I have boot tested this patch on Exynos boards and
compile tested for other Samsung platforms.

[1] http://www.spinics.net/lists/arm-kernel/msg345924.html
---
 drivers/pinctrl/Kconfig                            |   27 +------------------
 drivers/pinctrl/Makefile                           |    6 +----
 drivers/pinctrl/samsung/Kconfig                    |   28 ++++++++++++++++++++
 drivers/pinctrl/samsung/Makefile                   |    7 +++++
 drivers/pinctrl/{ => samsung}/pinctrl-exynos.c     |    0
 drivers/pinctrl/{ => samsung}/pinctrl-exynos.h     |    0
 drivers/pinctrl/{ => samsung}/pinctrl-exynos5440.c |    2 +-
 drivers/pinctrl/{ => samsung}/pinctrl-s3c24xx.c    |    0
 drivers/pinctrl/{ => samsung}/pinctrl-s3c64xx.c    |    0
 drivers/pinctrl/{ => samsung}/pinctrl-samsung.c    |    2 +-
 drivers/pinctrl/{ => samsung}/pinctrl-samsung.h    |    0
 11 files changed, 39 insertions(+), 33 deletions(-)
 create mode 100644 drivers/pinctrl/samsung/Kconfig
 create mode 100644 drivers/pinctrl/samsung/Makefile
 rename drivers/pinctrl/{ => samsung}/pinctrl-exynos.c (100%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-exynos.h (100%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-exynos5440.c (99%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-s3c24xx.c (100%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-s3c64xx.c (100%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-samsung.c (99%)
 rename drivers/pinctrl/{ => samsung}/pinctrl-samsung.h (100%)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 2744fa2825e0..f8bf9d80fc1a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -363,22 +363,6 @@ config PINCTRL_COH901
 	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
 	  ports of 8 GPIO pins each.
 
-config PINCTRL_SAMSUNG
-	bool
-	select PINMUX
-	select PINCONF
-
-config PINCTRL_EXYNOS
-	bool "Pinctrl driver data for Samsung EXYNOS SoCs other than 5440"
-	depends on OF && GPIOLIB && (ARCH_EXYNOS || ARCH_S5PV210)
-	select PINCTRL_SAMSUNG
-
-config PINCTRL_EXYNOS5440
-	bool "Samsung EXYNOS5440 SoC pinctrl driver"
-	depends on SOC_EXYNOS5440
-	select PINMUX
-	select PINCONF
-
 config PINCTRL_PALMAS
 	bool "Pinctrl driver for the PALMAS Series MFD devices"
 	depends on OF && MFD_PALMAS
@@ -390,18 +374,9 @@ config PINCTRL_PALMAS
 	  open drain configuration for the Palmas series devices like
 	  TPS65913, TPS80036 etc.
 
-config PINCTRL_S3C24XX
-	bool "Samsung S3C24XX SoC pinctrl driver"
-	depends on ARCH_S3C24XX
-	select PINCTRL_SAMSUNG
-
-config PINCTRL_S3C64XX
-	bool "Samsung S3C64XX SoC pinctrl driver"
-	depends on ARCH_S3C64XX
-	select PINCTRL_SAMSUNG
-
 source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
+source "drivers/pinctrl/samsung/Kconfig"
 source "drivers/pinctrl/sh-pfc/Kconfig"
 source "drivers/pinctrl/spear/Kconfig"
 source "drivers/pinctrl/sunxi/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c7d8f1b7311f..2ee910dbfe36 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -60,11 +60,6 @@ obj-$(CONFIG_PINCTRL_TZ1090)	+= pinctrl-tz1090.o
 obj-$(CONFIG_PINCTRL_TZ1090_PDC)	+= pinctrl-tz1090-pdc.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
-obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
-obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
-obj-$(CONFIG_PINCTRL_EXYNOS5440)	+= pinctrl-exynos5440.o
-obj-$(CONFIG_PINCTRL_S3C24XX)	+= pinctrl-s3c24xx.o
-obj-$(CONFIG_PINCTRL_S3C64XX)	+= pinctrl-s3c64xx.o
 obj-$(CONFIG_PINCTRL_XWAY)	+= pinctrl-xway.o
 obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
 obj-$(CONFIG_PINCTRL_TB10X)	+= pinctrl-tb10x.o
@@ -78,3 +73,4 @@ obj-$(CONFIG_SUPERH)		+= sh-pfc/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_VT8500)	+= vt8500/
 obj-$(CONFIG_ARCH_SUNXI)	+= sunxi/
+obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
diff --git a/drivers/pinctrl/samsung/Kconfig b/drivers/pinctrl/samsung/Kconfig
new file mode 100644
index 000000000000..d0461cd5d707
--- /dev/null
+++ b/drivers/pinctrl/samsung/Kconfig
@@ -0,0 +1,28 @@
+#
+# Samsung Pin control drivers
+#
+config PINCTRL_SAMSUNG
+	bool
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_EXYNOS
+	bool "Pinctrl driver data for Samsung EXYNOS SoCs other than 5440"
+	depends on OF && GPIOLIB && (ARCH_EXYNOS || ARCH_S5PV210)
+	select PINCTRL_SAMSUNG
+
+config PINCTRL_EXYNOS5440
+	bool "Samsung EXYNOS5440 SoC pinctrl driver"
+	depends on SOC_EXYNOS5440
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_S3C24XX
+	bool "Samsung S3C24XX SoC pinctrl driver"
+	depends on ARCH_S3C24XX
+	select PINCTRL_SAMSUNG
+
+config PINCTRL_S3C64XX
+	bool "Samsung S3C64XX SoC pinctrl driver"
+	depends on ARCH_S3C64XX
+	select PINCTRL_SAMSUNG
diff --git a/drivers/pinctrl/samsung/Makefile b/drivers/pinctrl/samsung/Makefile
new file mode 100644
index 000000000000..70160c059edd
--- /dev/null
+++ b/drivers/pinctrl/samsung/Makefile
@@ -0,0 +1,7 @@
+# Samsung pin control drivers
+
+obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
+obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
+obj-$(CONFIG_PINCTRL_EXYNOS5440)	+= pinctrl-exynos5440.o
+obj-$(CONFIG_PINCTRL_S3C24XX)	+= pinctrl-s3c24xx.o
+obj-$(CONFIG_PINCTRL_S3C64XX)	+= pinctrl-s3c64xx.o
diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-exynos.c
rename to drivers/pinctrl/samsung/pinctrl-exynos.c
diff --git a/drivers/pinctrl/pinctrl-exynos.h b/drivers/pinctrl/samsung/pinctrl-exynos.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-exynos.h
rename to drivers/pinctrl/samsung/pinctrl-exynos.h
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-exynos5440.c
rename to drivers/pinctrl/samsung/pinctrl-exynos5440.c
index 4b145b5db7a6..603da2f9dd95 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
@@ -23,7 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/of_irq.h>
-#include "core.h"
+#include "../core.h"
 
 /* EXYNOS5440 GPIO and Pinctrl register offsets */
 #define GPIO_MUX		0x00
diff --git a/drivers/pinctrl/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-s3c24xx.c
rename to drivers/pinctrl/samsung/pinctrl-s3c24xx.c
diff --git a/drivers/pinctrl/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-s3c64xx.c
rename to drivers/pinctrl/samsung/pinctrl-s3c64xx.c
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
similarity index 99%
rename from drivers/pinctrl/pinctrl-samsung.c
rename to drivers/pinctrl/samsung/pinctrl-samsung.c
index 52f849ac06c1..b07406da333c 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -30,7 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 
-#include "core.h"
+#include "../core.h"
 #include "pinctrl-samsung.h"
 
 #define GROUP_SUFFIX		"-grp"
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
similarity index 100%
rename from drivers/pinctrl/pinctrl-samsung.h
rename to drivers/pinctrl/samsung/pinctrl-samsung.h
-- 
1.7.9.5

