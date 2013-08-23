Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3HWSib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:38:31 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:56997 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3HWSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:38:29 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-i2c@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH] misc: (at24) move header to linux/platform_data/
Date: Fri, 23 Aug 2013 14:38:20 -0400
Message-Id: <1377283100-10390-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.3.4
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
 MAINTAINERS                                |  2 +-
 arch/arm/mach-at91/board-sam9260ek.c       |  2 +-
 arch/arm/mach-at91/board-sam9263ek.c       |  2 +-
 arch/arm/mach-davinci/board-da830-evm.c    |  2 +-
 arch/arm/mach-davinci/board-da850-evm.c    |  2 +-
 arch/arm/mach-davinci/board-dm365-evm.c    |  2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c   |  2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c   |  2 +-
 arch/arm/mach-davinci/board-mityomapl138.c |  2 +-
 arch/arm/mach-davinci/board-sffsdr.c       |  2 +-
 arch/arm/mach-imx/mach-pca100.c            |  2 +-
 arch/arm/mach-imx/mach-pcm037.c            |  2 +-
 arch/arm/mach-imx/mach-pcm038.c            |  2 +-
 arch/arm/mach-imx/mach-pcm043.c            |  2 +-
 arch/arm/mach-imx/mach-vpr200.c            |  2 +-
 arch/arm/mach-kirkwood/lacie_v2-common.c   |  2 +-
 arch/arm/mach-omap1/board-osk.c            |  2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |  2 +-
 arch/arm/mach-omap2/board-h4.c             |  2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |  2 +-
 arch/arm/mach-pxa/stargate2.c              |  2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c      |  2 +-
 drivers/misc/eeprom/at24.c                 |  2 +-
 include/linux/i2c/at24.h                   | 55 ------------------------------
 include/linux/platform_data/at24.h         | 55 ++++++++++++++++++++++++++++++
 25 files changed, 78 insertions(+), 78 deletions(-)
 delete mode 100644 include/linux/i2c/at24.h
 create mode 100644 include/linux/platform_data/at24.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8197fbd..9a6a52f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1382,7 +1382,7 @@ M:	Wolfram Sang <wsa@the-dreams.de>
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
index 1332de8..d509798 100644
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
index bea6793..ee81ca2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
-#include <linux/i2c/at24.h>
+#include <linux/platform_data/at24.h>
 #include <linux/i2c/pca953x.h>
 #include <linux/input.h>
 #include <linux/input/tps6507x-ts.h>
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 4cdb61c..eee6c45 100644
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
index fa4bfaf..032fb04 100644
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
index 0c005e8..c8dbbe9 100644
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
index 9549d53..0b7f112 100644
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
index 513eee1..c8c10e0 100644
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
index d4622ed..55c6847 100644
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
index 69c0acf..1275efc 100644
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
index d37e6b1..d6ef8ea 100644
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
diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
deleted file mode 100644
index 285025a..0000000
--- a/include/linux/i2c/at24.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * at24.h - platform_data for the at24 (generic eeprom) driver
- * (C) Copyright 2008 by Pengutronix
- * (C) Copyright 2012 by Wolfram Sang
- * same license as the driver
- */
-
-#ifndef _LINUX_AT24_H
-#define _LINUX_AT24_H
-
-#include <linux/types.h>
-#include <linux/memory.h>
-
-/**
- * struct at24_platform_data - data to set up at24 (generic eeprom) driver
- * @byte_len: size of eeprom in byte
- * @page_size: number of byte which can be written in one go
- * @flags: tunable options, check AT24_FLAG_* defines
- * @setup: an optional callback invoked after eeprom is probed; enables kernel
-	code to access eeprom via memory_accessor, see example
- * @context: optional parameter passed to setup()
- *
- * If you set up a custom eeprom type, please double-check the parameters.
- * Especially page_size needs extra care, as you risk data loss if your value
- * is bigger than what the chip actually supports!
- *
- * An example in pseudo code for a setup() callback:
- *
- * void get_mac_addr(struct memory_accessor *mem_acc, void *context)
- * {
- * 	u8 *mac_addr = ethernet_pdata->mac_addr;
- *	off_t offset = context;
- *
- *	// Read MAC addr from EEPROM
- *	if (mem_acc->read(mem_acc, mac_addr, offset, ETH_ALEN) == ETH_ALEN)
- *		pr_info("Read MAC addr from EEPROM: %pM\n", mac_addr);
- * }
- *
- * This function pointer and context can now be set up in at24_platform_data.
- */
-
-struct at24_platform_data {
-	u32		byte_len;		/* size (sum of all addr) */
-	u16		page_size;		/* for writes */
-	u8		flags;
-#define AT24_FLAG_ADDR16	0x80	/* address pointer is 16 bit */
-#define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
-#define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
-#define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
-
-	void		(*setup)(struct memory_accessor *, void *context);
-	void		*context;
-};
-
-#endif /* _LINUX_AT24_H */
diff --git a/include/linux/platform_data/at24.h b/include/linux/platform_data/at24.h
new file mode 100644
index 0000000..c42aa89
--- /dev/null
+++ b/include/linux/platform_data/at24.h
@@ -0,0 +1,55 @@
+/*
+ * at24.h - platform_data for the at24 (generic eeprom) driver
+ * (C) Copyright 2008 by Pengutronix
+ * (C) Copyright 2012 by Wolfram Sang
+ * same license as the driver
+ */
+
+#ifndef _LINUX_AT24_H
+#define _LINUX_AT24_H
+
+#include <linux/types.h>
+#include <linux/memory.h>
+
+/**
+ * struct at24_platform_data - data to set up at24 (generic eeprom) driver
+ * @byte_len: size of eeprom in byte
+ * @page_size: number of byte which can be written in one go
+ * @flags: tunable options, check AT24_FLAG_* defines
+ * @setup: an optional callback invoked after eeprom is probed; enables kernel
+	code to access eeprom via memory_accessor, see example
+ * @context: optional parameter passed to setup()
+ *
+ * If you set up a custom eeprom type, please double-check the parameters.
+ * Especially page_size needs extra care, as you risk data loss if your value
+ * is bigger than what the chip actually supports!
+ *
+ * An example in pseudo code for a setup() callback:
+ *
+ * void get_mac_addr(struct memory_accessor *mem_acc, void *context)
+ * {
+ *	u8 *mac_addr = ethernet_pdata->mac_addr;
+ *	off_t offset = context;
+ *
+ *	// Read MAC addr from EEPROM
+ *	if (mem_acc->read(mem_acc, mac_addr, offset, ETH_ALEN) == ETH_ALEN)
+ *		pr_info("Read MAC addr from EEPROM: %pM\n", mac_addr);
+ * }
+ *
+ * This function pointer and context can now be set up in at24_platform_data.
+ */
+
+struct at24_platform_data {
+	u32		byte_len;		/* size (sum of all addr) */
+	u16		page_size;		/* for writes */
+	u8		flags;
+#define AT24_FLAG_ADDR16	0x80	/* address pointer is 16 bit */
+#define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
+#define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
+#define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
+
+	void		(*setup)(struct memory_accessor *, void *context);
+	void		*context;
+};
+
+#endif /* _LINUX_AT24_H */
-- 
1.8.3.4

