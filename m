Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3H2TZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:25:18 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:52915 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3H2TZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:25:15 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: arm@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-gpio@vger.kernel.org,
        kernel@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH RESEND] gpio: (gpio-pca953x) move header to linux/platform_data/
Date: Thu, 29 Aug 2013 15:24:14 -0400
Message-Id: <1377804254-15955-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the pca953x.h header from include/linux/i2c to
include/linux/platform_data and updates existing support accordingly.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/arm/mach-at91/board-snapper9260.c         | 2 +-
 arch/arm/mach-davinci/board-da850-evm.c        | 2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c           | 2 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c    | 2 +-
 arch/arm/mach-imx/mach-mxt_td60.c              | 2 +-
 arch/arm/mach-ks8695/board-acs5k.c             | 2 +-
 arch/arm/mach-mmp/ttc_dkb.c                    | 2 +-
 arch/arm/mach-omap2/board-am3517evm.c          | 2 +-
 arch/arm/mach-pxa/cm-x300.c                    | 2 +-
 arch/arm/mach-pxa/em-x270.c                    | 2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c           | 2 +-
 arch/arm/mach-pxa/spitz.c                      | 2 +-
 arch/arm/mach-pxa/zeus.c                       | 2 +-
 arch/arm/mach-pxa/zylonite_pxa300.c            | 2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c          | 2 +-
 arch/x86/platform/mrst/mrst.c                  | 2 +-
 drivers/gpio/gpio-pca953x.c                    | 2 +-
 include/linux/{i2c => platform_data}/pca953x.h | 0
 18 files changed, 17 insertions(+), 17 deletions(-)
 rename include/linux/{i2c => platform_data}/pca953x.h (100%)

diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3aaa978..f1d49e9 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -26,7 +26,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index bea6793..af6dafb 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -19,7 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/input.h>
 #include <linux/input/tps6507x-ts.h>
 #include <linux/mfd/tps6507x.h>
diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c b/arch/arm/mach-ep93xx/vision_ep9307.c
index 605956f..64f2e50 100644
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -23,7 +23,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #include <linux/spi/mmc_spi.h>
diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 29ac8ee6..97f9c62 100644
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
diff --git a/arch/arm/mach-imx/mach-mxt_td60.c b/arch/arm/mach-imx/mach-mxt_td60.c
index a27faab..c918940 100644
--- a/arch/arm/mach-imx/mach-mxt_td60.c
+++ b/arch/arm/mach-imx/mach-mxt_td60.c
@@ -26,7 +26,7 @@
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
 #include <linux/gpio.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 
 #include "common.h"
 #include "devices-imx27.h"
diff --git a/arch/arm/mach-ks8695/board-acs5k.c b/arch/arm/mach-ks8695/board-acs5k.c
index 456d638..9f9c044 100644
--- a/arch/arm/mach-ks8695/board-acs5k.c
+++ b/arch/arm/mach-ks8695/board-acs5k.c
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/i2c-gpio.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 8483906..7022329 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -15,7 +15,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/onenand.h>
 #include <linux/interrupt.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/gpio.h>
 #include <linux/gpio-pxa.h>
 #include <linux/mfd/88pm860x.h>
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index d63f14b..c7196a6 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -21,7 +21,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/can/platform/ti_hecc.h>
 #include <linux/davinci_emac.h>
 #include <linux/mmc/host.h>
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index 8091aac..f942349 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -29,7 +29,7 @@
 #include <linux/pwm_backlight.h>
 
 #include <linux/i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/i2c/pxa-i2c.h>
 
 #include <linux/mfd/da903x.h>
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 3a3362f..8eb4e23 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -30,7 +30,7 @@
 #include <linux/power_supply.h>
 #include <linux/apm-emulation.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/regulator/userspace-consumer.h>
 
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 13e5b00..3133ba8 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -408,7 +408,7 @@ struct pxacamera_platform_data pcm990_pxacamera_platform_data = {
 	.mclk_10khz = 1000,
 };
 
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 
 static struct pca953x_platform_data pca9536_data = {
 	.gpio_base	= PXA_NR_BUILTIN_GPIO,
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 4c29173..0b11c1a 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -20,7 +20,7 @@
 #include <linux/leds.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 #include <linux/spi/corgi_lcd.h>
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index f5d4364..126e4a8 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -26,7 +26,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/apm-emulation.h>
 #include <linux/can/platform/mcp251x.h>
 
diff --git a/arch/arm/mach-pxa/zylonite_pxa300.c b/arch/arm/mach-pxa/zylonite_pxa300.c
index 86e59c0..869bce7 100644
--- a/arch/arm/mach-pxa/zylonite_pxa300.c
+++ b/arch/arm/mach-pxa/zylonite_pxa300.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pxa-i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/gpio.h>
 
 #include <mach/pxa300.h>
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index 8ad88ac..007fc53 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -30,7 +30,7 @@
 #include <linux/basic_mmio_gpio.h>
 #include <linux/spi/spi.h>
 
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/platform_data/s3c-hsotg.h>
 
 #include <video/platform_lcd.h>
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 47fe66f..3ca5957 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -20,7 +20,7 @@
 #include <linux/intel_pmic_gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 426c51d..8804aec 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -18,7 +18,7 @@
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pca953x.h>
+#include <linux/platform_data/pca953x.h>
 #include <linux/slab.h>
 #ifdef CONFIG_OF_GPIO
 #include <linux/of_platform.h>
diff --git a/include/linux/i2c/pca953x.h b/include/linux/platform_data/pca953x.h
similarity index 100%
rename from include/linux/i2c/pca953x.h
rename to include/linux/platform_data/pca953x.h
-- 
1.8.4

