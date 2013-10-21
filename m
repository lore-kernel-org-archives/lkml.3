Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab3JUPjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:39:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab3JUPi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:38:58 -0400
Date: Mon, 21 Oct 2013 17:38:49 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Stephen Warren <swarren@wwwdotorg.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Jim Cromie <jim.cromie@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: Get rid of MODULE_ALIAS_MISCDEV statements
Message-ID: <20131021173849.2d8be882@endymion.delvare>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just can't find any value in MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR)
and MODULE_ALIAS_MISCDEV(TEMP_MINOR) statements.

Either the device is enumerated and the driver already has a module
alias (e.g. PCI, USB etc.) that will get the right driver loaded
automatically.

Or the device is not enumerated and loading its driver will lead to
more or less intrusive hardware poking. Such hardware poking should be
limited to a bare minimum, so the user should really decide which
drivers should be tried and in what order. Trying them all in
arbitrary order can't do any good.

On top of that, loading that many drivers at once bloats the kernel
log. Also many drivers will stay loaded afterward, bloating the output
of "lsmod" and wasting memory. Some modules (cs5535_mfgpt which gets
loaded as a dependency) can't even be unloaded!

If defining char-major-10-130 is needed then it should happen in
user-space.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Zwane Mwaikambo <zwane@arm.linux.org.uk>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/acquirewdt.c         |    4 +---
 drivers/watchdog/advantechwdt.c       |    1 -
 drivers/watchdog/alim1535_wdt.c       |    1 -
 drivers/watchdog/alim7101_wdt.c       |    1 -
 drivers/watchdog/ar7_wdt.c            |    1 -
 drivers/watchdog/at32ap700x_wdt.c     |    1 -
 drivers/watchdog/at91rm9200_wdt.c     |    1 -
 drivers/watchdog/ath79_wdt.c          |    1 -
 drivers/watchdog/bcm2835_wdt.c        |    1 -
 drivers/watchdog/bcm63xx_wdt.c        |    1 -
 drivers/watchdog/bfin_wdt.c           |    1 -
 drivers/watchdog/cpu5wdt.c            |    1 -
 drivers/watchdog/davinci_wdt.c        |    1 -
 drivers/watchdog/dw_wdt.c             |    1 -
 drivers/watchdog/ep93xx_wdt.c         |    1 -
 drivers/watchdog/eurotechwdt.c        |    1 -
 drivers/watchdog/gef_wdt.c            |    1 -
 drivers/watchdog/geodewdt.c           |    1 -
 drivers/watchdog/hpwdt.c              |    1 -
 drivers/watchdog/i6300esb.c           |    1 -
 drivers/watchdog/iTCO_wdt.c           |    3 ---
 drivers/watchdog/ib700wdt.c           |    1 -
 drivers/watchdog/ibmasr.c             |    1 -
 drivers/watchdog/ie6xx_wdt.c          |    1 -
 drivers/watchdog/imx2_wdt.c           |    1 -
 drivers/watchdog/indydog.c            |    1 -
 drivers/watchdog/intel_scu_watchdog.c |    1 -
 drivers/watchdog/iop_wdt.c            |    1 -
 drivers/watchdog/it8712f_wdt.c        |    1 -
 drivers/watchdog/it87_wdt.c           |    1 -
 drivers/watchdog/ixp4xx_wdt.c         |    2 --
 drivers/watchdog/jz4740_wdt.c         |    1 -
 drivers/watchdog/kempld_wdt.c         |    1 -
 drivers/watchdog/ks8695_wdt.c         |    1 -
 drivers/watchdog/lantiq_wdt.c         |    1 -
 drivers/watchdog/m54xx_wdt.c          |    1 -
 drivers/watchdog/machzwd.c            |    1 -
 drivers/watchdog/max63xx_wdt.c        |    1 -
 drivers/watchdog/mixcomwd.c           |    1 -
 drivers/watchdog/mpc8xxx_wdt.c        |    1 -
 drivers/watchdog/mtx-1_wdt.c          |    1 -
 drivers/watchdog/mv64x60_wdt.c        |    1 -
 drivers/watchdog/nuc900_wdt.c         |    1 -
 drivers/watchdog/nv_tco.c             |    1 -
 drivers/watchdog/of_xilinx_wdt.c      |    1 -
 drivers/watchdog/orion_wdt.c          |    1 -
 drivers/watchdog/pc87413_wdt.c        |    2 --
 drivers/watchdog/pcwd.c               |    4 +---
 drivers/watchdog/pcwd_pci.c           |    4 +---
 drivers/watchdog/pcwd_usb.c           |    4 +---
 drivers/watchdog/pika_wdt.c           |    2 --
 drivers/watchdog/pnx4008_wdt.c        |    1 -
 drivers/watchdog/pnx833x_wdt.c        |    1 -
 drivers/watchdog/rc32434_wdt.c        |    4 +---
 drivers/watchdog/rdc321x_wdt.c        |    1 -
 drivers/watchdog/s3c2410_wdt.c        |    2 --
 drivers/watchdog/sa1100_wdt.c         |    1 -
 drivers/watchdog/sb_wdog.c            |    1 -
 drivers/watchdog/sbc60xxwdt.c         |    1 -
 drivers/watchdog/sbc7240_wdt.c        |    2 --
 drivers/watchdog/sbc8360.c            |    1 -
 drivers/watchdog/sbc_epx_c3.c         |    1 -
 drivers/watchdog/sbc_fitpc2_wdt.c     |    2 --
 drivers/watchdog/sc1200wdt.c          |    1 -
 drivers/watchdog/sc520_wdt.c          |    1 -
 drivers/watchdog/sch311x_wdt.c        |    5 +----
 drivers/watchdog/scx200_wdt.c         |    1 -
 drivers/watchdog/shwdt.c              |    1 -
 drivers/watchdog/smsc37b787_wdt.c     |    2 --
 drivers/watchdog/softdog.c            |    1 -
 drivers/watchdog/sp5100_tco.c         |    1 -
 drivers/watchdog/stmp3xxx_rtc_wdt.c   |    1 -
 drivers/watchdog/txx9wdt.c            |    1 -
 drivers/watchdog/ux500_wdt.c          |    1 -
 drivers/watchdog/w83627hf_wdt.c       |    1 -
 drivers/watchdog/w83697hf_wdt.c       |    1 -
 drivers/watchdog/w83697ug_wdt.c       |    1 -
 drivers/watchdog/w83877f_wdt.c        |    1 -
 drivers/watchdog/w83977f_wdt.c        |    1 -
 drivers/watchdog/wafer5823wdt.c       |    1 -
 drivers/watchdog/wdrtas.c             |    2 --
 drivers/watchdog/wdt.c                |    2 --
 drivers/watchdog/wdt285.c             |    1 -
 drivers/watchdog/wdt977.c             |    1 -
 drivers/watchdog/wdt_pci.c            |    2 --
 drivers/watchdog/xen_wdt.c            |    1 -
 86 files changed, 6 insertions(+), 111 deletions(-)

--- linux-3.12-rc6.orig/drivers/watchdog/acquirewdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/acquirewdt.c	2013-10-21 16:58:11.701092495 +0200
@@ -60,8 +60,7 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
-							(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For struct miscdevice */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/fs.h>			/* For file operations */
 #include <linux/ioport.h>		/* For io-port access */
@@ -337,4 +336,3 @@ module_exit(acq_exit);
 MODULE_AUTHOR("David Woodhouse");
 MODULE_DESCRIPTION("Acquire Inc. Single Board Computer Watchdog Timer driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/advantechwdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/advantechwdt.c	2013-10-21 16:58:11.701092495 +0200
@@ -345,4 +345,3 @@ module_exit(advwdt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marek Michalkiewicz <marekm@linux.org.pl>");
 MODULE_DESCRIPTION("Advantech Single Board Computer WDT driver");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/alim1535_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/alim1535_wdt.c	2013-10-21 16:58:11.701092495 +0200
@@ -452,4 +452,3 @@ module_exit(watchdog_exit);
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("ALi M1535 PMU Watchdog Timer driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/alim7101_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/alim7101_wdt.c	2013-10-21 16:58:11.702092517 +0200
@@ -425,4 +425,3 @@ MODULE_DEVICE_TABLE(pci, alim7101_pci_tb
 MODULE_AUTHOR("Steve Hill");
 MODULE_DESCRIPTION("ALi M7101 PMU Computer Watchdog Timer driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/ar7_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ar7_wdt.c	2013-10-21 16:58:11.702092517 +0200
@@ -46,7 +46,6 @@
 MODULE_AUTHOR("Nicolas Thill <nico@openwrt.org>");
 MODULE_DESCRIPTION(LONGNAME);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int margin = 60;
 module_param(margin, int, 0);
--- linux-3.12-rc6.orig/drivers/watchdog/at32ap700x_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/at32ap700x_wdt.c	2013-10-21 16:58:11.702092517 +0200
@@ -434,4 +434,3 @@ module_platform_driver_probe(at32_wdt_dr
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/at91rm9200_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/at91rm9200_wdt.c	2013-10-21 16:58:11.702092517 +0200
@@ -297,5 +297,4 @@ module_exit(at91_wdt_exit);
 MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91RM9200");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:at91_wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/ath79_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ath79_wdt.c	2013-10-21 16:58:11.703092539 +0200
@@ -329,4 +329,3 @@ MODULE_AUTHOR("Gabor Juhos <juhosg@openw
 MODULE_AUTHOR("Imre Kaloz <kaloz@openwrt.org");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/bcm2835_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/bcm2835_wdt.c	2013-10-21 16:58:11.703092539 +0200
@@ -186,4 +186,3 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
 MODULE_DESCRIPTION("Driver for Broadcom BCM2835 watchdog timer");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/bcm63xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/bcm63xx_wdt.c	2013-10-21 16:58:11.703092539 +0200
@@ -317,5 +317,4 @@ MODULE_AUTHOR("Miguel Gaio <miguel.gaio@
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION("Driver for the Broadcom BCM63xx SoC watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:bcm63xx-wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/bfin_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/bfin_wdt.c	2013-10-21 16:58:11.704092562 +0200
@@ -465,7 +465,6 @@ module_exit(bfin_wdt_exit);
 MODULE_AUTHOR("Michele d'Amico, Mike Frysinger <vapier@gentoo.org>");
 MODULE_DESCRIPTION("Blackfin Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(timeout, uint, 0);
 MODULE_PARM_DESC(timeout,
--- linux-3.12-rc6.orig/drivers/watchdog/cpu5wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/cpu5wdt.c	2013-10-21 16:58:11.704092562 +0200
@@ -289,7 +289,6 @@ MODULE_AUTHOR("Heiko Ronsdorf <hero@ihg.
 MODULE_DESCRIPTION("sma cpu5 watchdog driver");
 MODULE_SUPPORTED_DEVICE("sma cpu5 watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(port, int, 0);
 MODULE_PARM_DESC(port, "base address of watchdog card, default is 0x91");
--- linux-3.12-rc6.orig/drivers/watchdog/davinci_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/davinci_wdt.c	2013-10-21 16:58:11.704092562 +0200
@@ -267,5 +267,4 @@ MODULE_PARM_DESC(heartbeat,
 		 __MODULE_STRING(DEFAULT_HEARTBEAT));
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:watchdog");
--- linux-3.12-rc6.orig/drivers/watchdog/dw_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/dw_wdt.c	2013-10-21 16:58:11.704092562 +0200
@@ -357,4 +357,3 @@ module_platform_driver(dw_wdt_driver);
 MODULE_AUTHOR("Jamie Iles");
 MODULE_DESCRIPTION("Synopsys DesignWare Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/ep93xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ep93xx_wdt.c	2013-10-21 16:58:11.705092584 +0200
@@ -179,4 +179,3 @@ MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail
 MODULE_DESCRIPTION("EP93xx Watchdog");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(WDT_VERSION);
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/eurotechwdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/eurotechwdt.c	2013-10-21 16:58:11.705092584 +0200
@@ -477,4 +477,3 @@ module_exit(eurwdt_exit);
 MODULE_AUTHOR("Rodolfo Giometti");
 MODULE_DESCRIPTION("Driver for Eurotech CPU-1220/1410 on board watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/gef_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/gef_wdt.c	2013-10-21 16:58:11.705092584 +0200
@@ -330,5 +330,4 @@ module_exit(gef_wdt_exit);
 MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
 MODULE_DESCRIPTION("GE watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:gef_wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/geodewdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/geodewdt.c	2013-10-21 16:58:11.705092584 +0200
@@ -297,4 +297,3 @@ module_exit(geodewdt_exit);
 MODULE_AUTHOR("Advanced Micro Devices, Inc");
 MODULE_DESCRIPTION("Geode GX/LX Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/hpwdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/hpwdt.c	2013-10-21 16:58:11.706092606 +0200
@@ -881,7 +881,6 @@ MODULE_AUTHOR("Tom Mingarelli");
 MODULE_DESCRIPTION("hp watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HPWDT_VERSION);
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
--- linux-3.12-rc6.orig/drivers/watchdog/i6300esb.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/i6300esb.c	2013-10-21 16:58:11.706092606 +0200
@@ -497,4 +497,3 @@ module_pci_driver(esb_driver);
 MODULE_AUTHOR("Ross Biro and David Härdeman");
 MODULE_DESCRIPTION("Watchdog driver for Intel 6300ESB chipsets");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/iTCO_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/iTCO_wdt.c	2013-10-21 17:05:50.842393484 +0200
@@ -56,8 +56,6 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
-							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/fs.h>			/* For file operations */
@@ -582,5 +580,4 @@ MODULE_AUTHOR("Wim Van Sebroeck <wim@igu
 MODULE_DESCRIPTION("Intel TCO WatchDog Timer Driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:" DRV_NAME);
--- linux-3.12-rc6.orig/drivers/watchdog/ib700wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ib700wdt.c	2013-10-21 16:58:11.707092629 +0200
@@ -382,6 +382,5 @@ module_exit(ibwdt_exit);
 MODULE_AUTHOR("Charles Howes <chowes@vsol.net>");
 MODULE_DESCRIPTION("IB700 SBC watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 /* end of ib700wdt.c */
--- linux-3.12-rc6.orig/drivers/watchdog/ibmasr.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ibmasr.c	2013-10-21 16:58:11.707092629 +0200
@@ -419,4 +419,3 @@ MODULE_PARM_DESC(nowayout,
 MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
 MODULE_AUTHOR("Andrey Panin");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/ie6xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ie6xx_wdt.c	2013-10-21 16:58:11.707092629 +0200
@@ -344,5 +344,4 @@ module_exit(ie6xx_wdt_exit);
 MODULE_AUTHOR("Alexander Stein <alexander.stein@systec-electronic.com>");
 MODULE_DESCRIPTION("Intel Atom E6xx Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:" DRIVER_NAME);
--- linux-3.12-rc6.orig/drivers/watchdog/imx2_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/imx2_wdt.c	2013-10-21 16:58:11.707092629 +0200
@@ -338,5 +338,4 @@ module_platform_driver_probe(imx2_wdt_dr
 MODULE_AUTHOR("Wolfram Sang");
 MODULE_DESCRIPTION("Watchdog driver for IMX2 and later");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:" DRIVER_NAME);
--- linux-3.12-rc6.orig/drivers/watchdog/indydog.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/indydog.c	2013-10-21 16:58:11.708092651 +0200
@@ -214,4 +214,3 @@ module_exit(watchdog_exit);
 MODULE_AUTHOR("Guido Guenther <agx@sigxcpu.org>");
 MODULE_DESCRIPTION("Hardware Watchdog Device for SGI IP22");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/intel_scu_watchdog.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/intel_scu_watchdog.c	2013-10-21 16:58:11.709092673 +0200
@@ -564,5 +564,4 @@ module_exit(intel_scu_watchdog_exit);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel SCU Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_VERSION(WDT_VER);
--- linux-3.12-rc6.orig/drivers/watchdog/iop_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/iop_wdt.c	2013-10-21 16:58:11.710092695 +0200
@@ -259,4 +259,3 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 MODULE_AUTHOR("Curt E Bruns <curt.e.bruns@intel.com>");
 MODULE_DESCRIPTION("iop watchdog timer driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/it8712f_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/it8712f_wdt.c	2013-10-21 16:58:11.710092695 +0200
@@ -41,7 +41,6 @@
 MODULE_AUTHOR("Jorge Boncompte - DTI2 <jorge@dti2.net>");
 MODULE_DESCRIPTION("IT8712F Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int max_units = 255;
 static int margin = 60;		/* in seconds */
--- linux-3.12-rc6.orig/drivers/watchdog/it87_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/it87_wdt.c	2013-10-21 16:58:11.710092695 +0200
@@ -772,4 +772,3 @@ module_exit(it87_wdt_exit);
 MODULE_AUTHOR("Oliver Schuster");
 MODULE_DESCRIPTION("Hardware Watchdog Device Driver for IT87xx EC-LPC I/O");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/ixp4xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ixp4xx_wdt.c	2013-10-21 16:58:11.710092695 +0200
@@ -208,5 +208,3 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
--- linux-3.12-rc6.orig/drivers/watchdog/jz4740_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/jz4740_wdt.c	2013-10-21 16:58:11.710092695 +0200
@@ -222,5 +222,4 @@ module_platform_driver(jz4740_wdt_driver
 MODULE_AUTHOR("Paul Cercueil <paul@crapouillou.net>");
 MODULE_DESCRIPTION("jz4740 Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:jz4740-wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/kempld_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/kempld_wdt.c	2013-10-21 16:58:11.711092718 +0200
@@ -578,4 +578,3 @@ module_platform_driver(kempld_wdt_driver
 MODULE_DESCRIPTION("KEM PLD Watchdog Driver");
 MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/ks8695_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ks8695_wdt.c	2013-10-21 16:58:11.711092718 +0200
@@ -323,5 +323,4 @@ module_exit(ks8695_wdt_exit);
 MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for KS8695");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:ks8695_wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/lantiq_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/lantiq_wdt.c	2013-10-21 16:58:11.711092718 +0200
@@ -249,4 +249,3 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 MODULE_AUTHOR("John Crispin <blogic@openwrt.org>");
 MODULE_DESCRIPTION("Lantiq SoC Watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/m54xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/m54xx_wdt.c	2013-10-21 16:58:11.711092718 +0200
@@ -223,4 +223,3 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/machzwd.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/machzwd.c	2013-10-21 16:58:11.711092718 +0200
@@ -92,7 +92,6 @@ static unsigned short zf_readw(unsigned
 MODULE_AUTHOR("Fernando Fuganti <fuganti@conectiva.com.br>");
 MODULE_DESCRIPTION("MachZ ZF-Logic Watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
--- linux-3.12-rc6.orig/drivers/watchdog/max63xx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/max63xx_wdt.c	2013-10-21 16:58:11.711092718 +0200
@@ -258,4 +258,3 @@ MODULE_PARM_DESC(nodelay,
 		 "(max6373/74 only, default=0)");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/mixcomwd.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/mixcomwd.c	2013-10-21 16:58:11.712092740 +0200
@@ -315,4 +315,3 @@ MODULE_AUTHOR("Gergely Madarasz <gorgo@i
 MODULE_DESCRIPTION("MixCom Watchdog driver");
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/mpc8xxx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/mpc8xxx_wdt.c	2013-10-21 16:58:11.712092740 +0200
@@ -329,4 +329,3 @@ MODULE_AUTHOR("Dave Updegraff, Kumar Gal
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC8xx/MPC83xx/MPC86xx "
 		   "uProcessors");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/mtx-1_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/mtx-1_wdt.c	2013-10-21 16:58:11.712092740 +0200
@@ -257,5 +257,4 @@ module_platform_driver(mtx1_wdt_driver);
 MODULE_AUTHOR("Michael Stickel, Florian Fainelli");
 MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:mtx1-wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/mv64x60_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/mv64x60_wdt.c	2013-10-21 16:58:11.712092740 +0200
@@ -323,5 +323,4 @@ module_exit(mv64x60_wdt_exit);
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("MV64x60 watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:" MV64x60_WDT_NAME);
--- linux-3.12-rc6.orig/drivers/watchdog/nuc900_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/nuc900_wdt.c	2013-10-21 16:58:11.712092740 +0200
@@ -307,5 +307,4 @@ module_platform_driver(nuc900wdt_driver)
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("Watchdog driver for NUC900");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:nuc900-wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/nv_tco.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/nv_tco.c	2013-10-21 16:58:11.712092740 +0200
@@ -513,4 +513,3 @@ module_exit(nv_tco_cleanup_module);
 MODULE_AUTHOR("Mike Waychison");
 MODULE_DESCRIPTION("TCO timer driver for NV chipsets");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/of_xilinx_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/of_xilinx_wdt.c	2013-10-21 16:58:11.713092762 +0200
@@ -405,4 +405,3 @@ module_platform_driver(xwdt_driver);
 MODULE_AUTHOR("Alejandro Cabrera <aldaya@gmail.com>");
 MODULE_DESCRIPTION("Xilinx Watchdog driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/orion_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/orion_wdt.c	2013-10-21 16:58:11.713092762 +0200
@@ -225,4 +225,3 @@ MODULE_PARM_DESC(nowayout, "Watchdog can
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:orion_wdt");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/pc87413_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pc87413_wdt.c	2013-10-21 16:58:11.713092762 +0200
@@ -580,8 +580,6 @@ MODULE_AUTHOR("Sven Anders <anders@andur
 MODULE_DESCRIPTION("PC87413 WDT driver");
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, MODNAME " I/O port (default: "
 					__MODULE_STRING(IO_DEFAULT) ").");
--- linux-3.12-rc6.orig/drivers/watchdog/pcwd.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pcwd.c	2013-10-21 16:58:11.713092762 +0200
@@ -61,7 +61,7 @@
 #include <linux/delay.h>	/* For mdelay function */
 #include <linux/timer.h>	/* For timer related operations */
 #include <linux/jiffies.h>	/* For jiffies stuff */
-#include <linux/miscdevice.h>	/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>	/* For struct miscdevice */
 #include <linux/watchdog.h>	/* For the watchdog specific items */
 #include <linux/reboot.h>	/* For kernel_power_off() */
 #include <linux/init.h>		/* For __init/__exit/... */
@@ -1011,5 +1011,3 @@ MODULE_AUTHOR("Ken Hollis <kenji@bitgate
 MODULE_DESCRIPTION("Berkshire ISA-PC Watchdog driver");
 MODULE_VERSION(WATCHDOG_VERSION);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/pcwd_pci.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pcwd_pci.c	2013-10-21 16:58:11.714092785 +0200
@@ -40,7 +40,7 @@
 #include <linux/errno.h>	/* For the -ENODEV/... values */
 #include <linux/kernel.h>	/* For printk/panic/... */
 #include <linux/delay.h>	/* For mdelay function */
-#include <linux/miscdevice.h>	/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>	/* For struct miscdevice */
 #include <linux/watchdog.h>	/* For the watchdog specific items */
 #include <linux/notifier.h>	/* For notifier support */
 #include <linux/reboot.h>	/* For reboot_notifier stuff */
@@ -820,5 +820,3 @@ module_pci_driver(pcipcwd_driver);
 MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("Berkshire PCI-PC Watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/pcwd_usb.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pcwd_usb.c	2013-10-21 16:58:11.714092785 +0200
@@ -32,7 +32,7 @@
 #include <linux/errno.h>	/* For the -ENODEV/... values */
 #include <linux/kernel.h>	/* For printk/panic/... */
 #include <linux/delay.h>	/* For mdelay function */
-#include <linux/miscdevice.h>	/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>	/* For struct miscdevice */
 #include <linux/watchdog.h>	/* For the watchdog specific items */
 #include <linux/notifier.h>	/* For notifier support */
 #include <linux/reboot.h>	/* For reboot_notifier stuff */
@@ -72,8 +72,6 @@ do {							\
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE(DRIVER_LICENSE);
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 
 /* Module Parameters */
 module_param(debug, int, 0);
--- linux-3.12-rc6.orig/drivers/watchdog/pika_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pika_wdt.c	2013-10-21 16:58:11.714092785 +0200
@@ -298,5 +298,3 @@ module_exit(pikawdt_exit);
 MODULE_AUTHOR("Sean MacLennan <smaclennan@pikatech.com>");
 MODULE_DESCRIPTION("PIKA FPGA based Watchdog Timer");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
--- linux-3.12-rc6.orig/drivers/watchdog/pnx4008_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pnx4008_wdt.c	2013-10-21 16:58:11.714092785 +0200
@@ -233,5 +233,4 @@ MODULE_PARM_DESC(nowayout,
 		 "Set to 1 to keep watchdog running after device release");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:pnx4008-watchdog");
--- linux-3.12-rc6.orig/drivers/watchdog/pnx833x_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/pnx833x_wdt.c	2013-10-21 16:58:11.714092785 +0200
@@ -278,4 +278,3 @@ module_exit(watchdog_exit);
 MODULE_AUTHOR("Daniel Laird/Andre McCurdy");
 MODULE_DESCRIPTION("Hardware Watchdog Device for PNX833x");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/rc32434_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/rc32434_wdt.c	2013-10-21 16:58:11.715092807 +0200
@@ -25,8 +25,7 @@
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
 #include <linux/fs.h>			/* For file operations */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
-							(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For struct miscdevice */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/platform_device.h>	/* For platform_driver framework */
@@ -329,4 +328,3 @@ MODULE_AUTHOR("Ondrej Zajicek <santiago@
 		"Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION("Driver for the IDT RC32434 SoC watchdog");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/rdc321x_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/rdc321x_wdt.c	2013-10-21 16:58:11.715092807 +0200
@@ -298,4 +298,3 @@ module_platform_driver(rdc321x_wdt_drive
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION("RDC321x watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/s3c2410_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/s3c2410_wdt.c	2013-10-21 16:58:11.715092807 +0200
@@ -29,7 +29,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/miscdevice.h> /* for MODULE_ALIAS_MISCDEV */
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -539,5 +538,4 @@ MODULE_AUTHOR("Ben Dooks <ben@simtec.co.
 	      "Dimitry Andric <dimitry.andric@tomtom.com>");
 MODULE_DESCRIPTION("S3C2410 Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:s3c2410-wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/sa1100_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sa1100_wdt.c	2013-10-21 16:58:11.715092807 +0200
@@ -193,4 +193,3 @@ module_param(margin, int, 0);
 MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sb_wdog.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sb_wdog.c	2013-10-21 16:58:11.715092807 +0200
@@ -341,7 +341,6 @@ MODULE_PARM_DESC(timeout,
       "Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 /*
  * example code that can be put in a platform code area to utilize the
--- linux-3.12-rc6.orig/drivers/watchdog/sbc60xxwdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sbc60xxwdt.c	2013-10-21 16:58:11.715092807 +0200
@@ -387,4 +387,3 @@ module_exit(sbc60xxwdt_unload);
 MODULE_AUTHOR("Jakob Oestergaard <jakob@unthought.net>");
 MODULE_DESCRIPTION("60xx Single Board Computer Watchdog Timer driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sbc7240_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sbc7240_wdt.c	2013-10-21 16:58:11.716092829 +0200
@@ -309,5 +309,3 @@ MODULE_AUTHOR("Gilles Gigan");
 MODULE_DESCRIPTION("Watchdog device driver for single board"
 		   " computers EPIC Nano 7240 from iEi");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
--- linux-3.12-rc6.orig/drivers/watchdog/sbc8360.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sbc8360.c	2013-10-21 16:58:11.716092829 +0200
@@ -404,6 +404,5 @@ MODULE_AUTHOR("Ian E. Morgan <imorgan@we
 MODULE_DESCRIPTION("SBC8360 watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.01");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 /* end of sbc8360.c */
--- linux-3.12-rc6.orig/drivers/watchdog/sbc_epx_c3.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sbc_epx_c3.c	2013-10-21 16:58:11.716092829 +0200
@@ -220,4 +220,3 @@ MODULE_DESCRIPTION("Hardware Watchdog De
 	"so only use it if you are *sure* you are running on this specific "
 	"SBC system from Winsystems!  It writes to IO ports 0x1ee and 0x1ef!");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sbc_fitpc2_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sbc_fitpc2_wdt.c	2013-10-21 16:58:11.716092829 +0200
@@ -263,5 +263,3 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
--- linux-3.12-rc6.orig/drivers/watchdog/sc1200wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sc1200wdt.c	2013-10-21 16:58:11.716092829 +0200
@@ -476,4 +476,3 @@ MODULE_AUTHOR("Zwane Mwaikambo <zwane@co
 MODULE_DESCRIPTION(
 	"Driver for National Semiconductor PC87307/PC97307 watchdog component");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sc520_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sc520_wdt.c	2013-10-21 16:58:11.716092829 +0200
@@ -433,4 +433,3 @@ MODULE_AUTHOR("Scott and Bill Jennings")
 MODULE_DESCRIPTION(
 	"Driver for watchdog timer in AMD \"Elan\" SC520 uProcessor");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sch311x_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sch311x_wdt.c	2013-10-21 16:58:11.717092851 +0200
@@ -26,8 +26,7 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
-							(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For struct miscdevice */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/fs.h>			/* For file operations */
@@ -545,5 +544,3 @@ module_exit(sch311x_wdt_exit);
 MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("SMSC SCH311x WatchDog Timer Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
--- linux-3.12-rc6.orig/drivers/watchdog/scx200_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/scx200_wdt.c	2013-10-21 16:58:11.717092851 +0200
@@ -37,7 +37,6 @@
 MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
 MODULE_DESCRIPTION("NatSemi SCx200 Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int margin = 60;		/* in seconds */
 module_param(margin, int, 0);
--- linux-3.12-rc6.orig/drivers/watchdog/shwdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/shwdt.c	2013-10-21 16:58:11.717092851 +0200
@@ -343,7 +343,6 @@ MODULE_AUTHOR("Paul Mundt <lethal@linux-
 MODULE_DESCRIPTION("SuperH watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(clock_division_ratio, int, 0);
 MODULE_PARM_DESC(clock_division_ratio,
--- linux-3.12-rc6.orig/drivers/watchdog/smsc37b787_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/smsc37b787_wdt.c	2013-10-21 16:58:11.717092851 +0200
@@ -603,8 +603,6 @@ MODULE_DESCRIPTION("Driver for SMsC 37B7
 								VERSION ")");
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
 #ifdef SMSC_SUPPORT_MINUTES
 module_param(unit, int, 0);
 MODULE_PARM_DESC(unit,
--- linux-3.12-rc6.orig/drivers/watchdog/softdog.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/softdog.c	2013-10-21 16:58:11.717092851 +0200
@@ -207,4 +207,3 @@ module_exit(watchdog_exit);
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("Software Watchdog Device Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/sp5100_tco.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/sp5100_tco.c	2013-10-21 16:58:11.718092874 +0200
@@ -580,4 +580,3 @@ module_exit(sp5100_tco_cleanup_module);
 MODULE_AUTHOR("Priyanka Gupta");
 MODULE_DESCRIPTION("TCO timer driver for SP5100/SB800 chipset");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/stmp3xxx_rtc_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/stmp3xxx_rtc_wdt.c	2013-10-21 16:58:11.718092874 +0200
@@ -108,4 +108,3 @@ module_platform_driver(stmp3xxx_wdt_driv
 MODULE_DESCRIPTION("STMP3XXX RTC Watchdog Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/txx9wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/txx9wdt.c	2013-10-21 16:58:11.718092874 +0200
@@ -176,5 +176,4 @@ module_platform_driver_probe(txx9wdt_dri
 
 MODULE_DESCRIPTION("TXx9 Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:txx9wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/ux500_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/ux500_wdt.c	2013-10-21 16:58:11.718092874 +0200
@@ -167,5 +167,4 @@ module_platform_driver(ux500_wdt_driver)
 MODULE_AUTHOR("Jonas Aaberg <jonas.aberg@stericsson.com>");
 MODULE_DESCRIPTION("Ux500 Watchdog Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 MODULE_ALIAS("platform:ux500_wdt");
--- linux-3.12-rc6.orig/drivers/watchdog/w83627hf_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/w83627hf_wdt.c	2013-10-21 16:58:11.718092874 +0200
@@ -396,4 +396,3 @@ module_exit(wdt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pádraig  Brady <P@draigBrady.com>");
 MODULE_DESCRIPTION("w83627hf/thf WDT driver");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/w83697hf_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/w83697hf_wdt.c	2013-10-21 16:58:11.719092896 +0200
@@ -458,4 +458,3 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marcus Junker <junker@anduras.de>, "
 		"Samuel Tardieu <sam@rfc1149.net>");
 MODULE_DESCRIPTION("w83697hf/hg WDT driver");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/w83697ug_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/w83697ug_wdt.c	2013-10-21 16:58:11.719092896 +0200
@@ -395,4 +395,3 @@ module_exit(wdt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Flemming Frandsen <ff@nrvissing.net>");
 MODULE_DESCRIPTION("w83697ug/uf WDT driver");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/w83877f_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/w83877f_wdt.c	2013-10-21 16:58:11.719092896 +0200
@@ -406,4 +406,3 @@ module_exit(w83877f_wdt_unload);
 MODULE_AUTHOR("Scott and Bill Jennings");
 MODULE_DESCRIPTION("Driver for watchdog timer in w83877f chip");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/w83977f_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/w83977f_wdt.c	2013-10-21 16:58:11.719092896 +0200
@@ -527,4 +527,3 @@ module_exit(w83977f_wdt_exit);
 MODULE_AUTHOR("Jose Goncalves <jose.goncalves@inov.pt>");
 MODULE_DESCRIPTION("Driver for watchdog timer in W83977F I/O chip");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/wafer5823wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wafer5823wdt.c	2013-10-21 16:58:11.719092896 +0200
@@ -322,6 +322,5 @@ module_exit(wafwdt_exit);
 MODULE_AUTHOR("Justin Cormack");
 MODULE_DESCRIPTION("ICP Wafer 5823 Single Board Computer WDT driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 /* end of wafer5823wdt.c */
--- linux-3.12-rc6.orig/drivers/watchdog/wdrtas.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wdrtas.c	2013-10-21 16:58:11.719092896 +0200
@@ -48,8 +48,6 @@
 MODULE_AUTHOR("Utz Bacher <utz.bacher@de.ibm.com>");
 MODULE_DESCRIPTION("RTAS watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 
 static bool wdrtas_nowayout = WATCHDOG_NOWAYOUT;
 static atomic_t wdrtas_miscdev_open = ATOMIC_INIT(0);
--- linux-3.12-rc6.orig/drivers/watchdog/wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wdt.c	2013-10-21 16:58:11.720092918 +0200
@@ -664,6 +664,4 @@ module_exit(wdt_exit);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("Driver for ISA ICS watchdog cards (WDT500/501)");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
 MODULE_LICENSE("GPL");
--- linux-3.12-rc6.orig/drivers/watchdog/wdt285.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wdt285.c	2013-10-21 16:58:11.720092918 +0200
@@ -224,7 +224,6 @@ static void __exit footbridge_watchdog_e
 MODULE_AUTHOR("Phil Blundell <pb@nexus.co.uk>");
 MODULE_DESCRIPTION("Footbridge watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
--- linux-3.12-rc6.orig/drivers/watchdog/wdt977.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wdt977.c	2013-10-21 16:58:11.720092918 +0200
@@ -507,4 +507,3 @@ module_exit(wd977_exit);
 MODULE_AUTHOR("Woody Suwalski <woodys@xandros.com>");
 MODULE_DESCRIPTION("W83977AF Watchdog driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/wdt_pci.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/wdt_pci.c	2013-10-21 16:58:11.720092918 +0200
@@ -744,5 +744,3 @@ module_pci_driver(wdtpci_driver);
 MODULE_AUTHOR("JP Nollmann, Alan Cox");
 MODULE_DESCRIPTION("Driver for the ICS PCI-WDT500/501 watchdog cards");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS_MISCDEV(TEMP_MINOR);
--- linux-3.12-rc6.orig/drivers/watchdog/xen_wdt.c	2013-10-21 15:55:48.519981376 +0200
+++ linux-3.12-rc6/drivers/watchdog/xen_wdt.c	2013-10-21 16:58:11.720092918 +0200
@@ -362,4 +362,3 @@ MODULE_AUTHOR("Jan Beulich <jbeulich@nov
 MODULE_DESCRIPTION("Xen WatchDog Timer Driver");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);


-- 
Jean Delvare
Suse L3 Support
