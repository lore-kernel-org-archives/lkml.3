Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3I0TGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:06:48 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:63949 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3I0TGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:06:45 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-i2c@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH v2] misc: (at24) move header to linux/platform_data/
Date: Fri, 27 Sep 2013 15:06:28 -0400
Message-Id: <1380308788-15730-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the at24.h header from include/linux/i2c to
include/linux/platform_data and updates existing support accordingly.

It also fixes the following checkpatch warning:

    WARNING: please, no space before tabs
    #436: FILE: include/linux/platform_data/at24.h:31:
    + * ^Iu8 *mac_addr = ethernet_pdata->mac_addr;$

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                                 | 2 +-
 arch/arm/mach-at91/board-sam9260ek.c        | 2 +-
 arch/arm/mach-at91/board-sam9263ek.c        | 2 +-
 arch/arm/mach-davinci/board-da830-evm.c     | 2 +-
 arch/arm/mach-davinci/board-da850-evm.c     | 2 +-
 arch/arm/mach-davinci/board-dm365-evm.c     | 2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c    | 2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c    | 2 +-
 arch/arm/mach-davinci/board-mityomapl138.c  | 2 +-
 arch/arm/mach-davinci/board-sffsdr.c        | 2 +-
 arch/arm/mach-imx/mach-pca100.c             | 2 +-
 arch/arm/mach-imx/mach-pcm037.c             | 2 +-
 arch/arm/mach-imx/mach-pcm038.c             | 2 +-
 arch/arm/mach-imx/mach-pcm043.c             | 2 +-
 arch/arm/mach-imx/mach-vpr200.c             | 2 +-
 arch/arm/mach-kirkwood/lacie_v2-common.c    | 2 +-
 arch/arm/mach-omap1/board-osk.c             | 2 +-
 arch/arm/mach-omap2/board-cm-t35.c          | 2 +-
 arch/arm/mach-omap2/board-h4.c              | 2 +-
 arch/arm/mach-omap2/board-omap3stalker.c    | 2 +-
 arch/arm/mach-pxa/stargate2.c               | 2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c       | 2 +-
 drivers/misc/eeprom/at24.c                  | 2 +-
 include/linux/{i2c => platform_data}/at24.h | 2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)
 rename include/linux/{i2c => platform_data}/at24.h (97%)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..facbf59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1396,7 +1396,7 @@ M:	Wolfram Sang <wsa@the-dreams.de>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/eeprom/at24.c
-F:	include/linux/i2c/at24.h
+F:	include/linux/platform_data/at24.h
 
 ATA OVER ETHERNET (AOE) DRIVER
 M:	"Ed L. Cashin" <ecashin@coraid.com>
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 0b153c8..f4f8735 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -28,7 +28,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/at73c213.h>
 #include <linux/clk.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 3284df0..947e134 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -27,7 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/fb.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index c4bdc0a..66b5b3c 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index dd1fb24..f25a569 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/platform_data/pca953x.h>
 #include <linux/input.h>
 #include <linux/input/tps6507x-ts.h>
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 92b7f77..30ee81f 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -18,7 +18,7 @@
 #include <linux/i2c.h>
 #include <linux/io.h>
 #include <linux/clk.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/leds.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 40bb9b5..f21fde9 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -15,7 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pcf857x.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 2bc3651..db2df32 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -22,7 +22,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/i2c/pcf857x.h>
 
 #include <media/tvp514x.h>
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index cd0f587..7aa105b 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -15,7 +15,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/regulator/machine.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/etherdevice.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index d843601..41c7c96 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -26,7 +26,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
index 19bb644..c5f9567 100644
--- a/arch/arm/mach-imx/mach-pca100.c
+++ b/arch/arm/mach-imx/mach-pca100.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index bc0261e..20cc53f 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -23,7 +23,7 @@
 #include <linux/smsc911x.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/delay.h>
 #include <linux/spi/spi.h>
 #include <linux/irq.h>
diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index e805ac2..592ddbe 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -18,7 +18,7 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/io.h>
 #include <linux/mtd/plat-ram.h>
 #include <linux/mtd/physmap.h>
diff --git a/arch/arm/mach-imx/mach-pcm043.c b/arch/arm/mach-imx/mach-pcm043.c
index b726cb1..ac504b6 100644
--- a/arch/arm/mach-imx/mach-pcm043.c
+++ b/arch/arm/mach-imx/mach-pcm043.c
@@ -24,7 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
 
diff --git a/arch/arm/mach-imx/mach-vpr200.c b/arch/arm/mach-imx/mach-vpr200.c
index 0910761..8825d12 100644
--- a/arch/arm/mach-imx/mach-vpr200.c
+++ b/arch/arm/mach-imx/mach-vpr200.c
@@ -29,7 +29,7 @@
 #include <asm/mach/time.h>
 
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/mfd/mc13xxx.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-kirkwood/lacie_v2-common.c b/arch/arm/mach-kirkwood/lacie_v2-common.c
index 4894959..8e3e433 100644
--- a/arch/arm/mach-kirkwood/lacie_v2-common.c
+++ b/arch/arm/mach-kirkwood/lacie_v2-common.c
@@ -12,7 +12,7 @@
 #include <linux/spi/flash.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/gpio.h>
 #include <asm/mach/time.h>
 #include <mach/kirkwood.h>
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index a7ce692..d68909b 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -300,7 +300,7 @@ static struct omap_lcd_config osk_lcd_config __initdata = {
 #ifdef	CONFIG_OMAP_OSK_MISTRAL
 
 #include <linux/input.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 33d159e..8dd0ec8 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -25,7 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_data/gpio-omap.h>
 
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 87e41a8..f780834 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -20,7 +20,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/input.h>
 #include <linux/err.h>
 #include <linux/clk.h>
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index ba8342f..119efaf 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -32,7 +32,7 @@
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 #include <linux/smsc911x.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/usb/phy.h>
 
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 62aea3e..01de542 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -27,7 +27,7 @@
 
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/i2c/pcf857x.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/smc91x.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c b/arch/arm/mach-s3c24xx/mach-mini2440.c
index a83db46..4a18d49 100644
--- a/arch/arm/mach-s3c24xx/mach-mini2440.c
+++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
@@ -24,7 +24,7 @@
 #include <linux/io.h>
 #include <linux/serial_core.h>
 #include <linux/dm9000.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/platform_device.h>
 #include <linux/gpio_keys.h>
 #include <linux/i2c.h>
diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 5d4fd69..4ef01ab 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -22,7 +22,7 @@
 #include <linux/jiffies.h>
 #include <linux/of.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 
 /*
  * I2C EEPROMs from most vendors are inexpensive and mostly interchangeable.
diff --git a/include/linux/i2c/at24.h b/include/linux/platform_data/at24.h
similarity index 97%
rename from include/linux/i2c/at24.h
rename to include/linux/platform_data/at24.h
index 285025a..c42aa89 100644
--- a/include/linux/i2c/at24.h
+++ b/include/linux/platform_data/at24.h
@@ -28,7 +28,7 @@
  *
  * void get_mac_addr(struct memory_accessor *mem_acc, void *context)
  * {
- * 	u8 *mac_addr = ethernet_pdata->mac_addr;
+ *	u8 *mac_addr = ethernet_pdata->mac_addr;
  *	off_t offset = context;
  *
  *	// Read MAC addr from EEPROM
-- 
1.8.4

