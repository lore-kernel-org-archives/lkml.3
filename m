Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaIDFGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:06:33 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:21629
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbaIDFGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:06:31 -0400
From: Zhao Qiang <B45475@freescale.com>
To: <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <B07421@freescale.com>
CC: <R63061@freescale.com>, <linux-kernel@vger.kernel.org>,
        Zhao Qiang <B45475@freescale.com>
Subject: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
Date: Thu, 4 Sep 2014 13:06:26 +0800
Message-ID: <1409807186-45816-1-git-send-email-B45475@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(40224003)(189002)(21056001)(95666004)(20776003)(47776003)(83072002)(26826002)(76482001)(106466001)(85306004)(85852003)(81542001)(36756003)(105606002)(107046002)(77982001)(229853001)(104166001)(104016003)(102836001)(46102001)(74662001)(50466002)(31966008)(48376002)(19580395003)(84676001)(44976005)(97736001)(77156001)(19580405001)(99396002)(87286001)(90102001)(92566001)(68736004)(2201001)(50986999)(74502001)(6806004)(83322001)(92726001)(93916002)(89996001)(81342001)(62966002)(79102001)(80022001)(88136002)(64706001)(4396001)(50226001)(87936001)(2101003)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0732;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=qiang.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LS1 is arm cpu and it has qe ip block.
move qe code from platform directory to public directory.

QE is an IP block integrates several comunications peripheral
controllers. It can implement a variety of applications, such
as uart, usb and tdm and so on.

Signed-off-by: Zhao Qiang <B45475@freescale.com>
---
Changes for v2:
	- mv code to drivers/soc

 arch/powerpc/Kconfig                               |  2 -
 arch/powerpc/platforms/83xx/km83xx.c               |  4 +-
 arch/powerpc/platforms/83xx/misc.c                 |  2 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |  4 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |  4 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |  4 +-
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |  4 +-
 arch/powerpc/platforms/85xx/common.c               |  2 +-
 arch/powerpc/platforms/85xx/corenet_generic.c      |  2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |  4 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  4 +-
 arch/powerpc/platforms/85xx/twr_p102x.c            |  4 +-
 arch/powerpc/platforms/Kconfig                     | 19 ---------
 arch/powerpc/sysdev/Makefile                       |  1 -
 arch/powerpc/sysdev/qe_lib/Kconfig                 | 27 -------------
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |  2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  8 ++--
 drivers/net/ethernet/freescale/ucc_geth.h          |  8 ++--
 drivers/soc/Kconfig                                |  2 +
 drivers/soc/Makefile                               |  2 +
 drivers/soc/qe/Kconfig                             | 45 ++++++++++++++++++++++
 .../sysdev/qe_lib => drivers/soc/qe}/Makefile      |  0
 .../sysdev/qe_lib => drivers/soc/qe}/gpio.c        |  2 +-
 .../powerpc/sysdev/qe_lib => drivers/soc/qe}/qe.c  |  4 +-
 .../sysdev/qe_lib => drivers/soc/qe}/qe_ic.c       |  2 +-
 .../sysdev/qe_lib => drivers/soc/qe}/qe_ic.h       |  2 +-
 .../sysdev/qe_lib => drivers/soc/qe}/qe_io.c       |  2 +-
 .../powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc.c |  6 +--
 .../sysdev/qe_lib => drivers/soc/qe}/ucc_fast.c    |  8 ++--
 .../sysdev/qe_lib => drivers/soc/qe}/ucc_slow.c    |  8 ++--
 .../powerpc/sysdev/qe_lib => drivers/soc/qe}/usb.c |  4 +-
 drivers/spi/spi-fsl-cpm.c                          |  2 +-
 drivers/tty/serial/ucc_uart.c                      |  2 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |  2 +-
 drivers/usb/host/fhci-hcd.c                        |  2 +-
 drivers/usb/host/fhci-hub.c                        |  2 +-
 drivers/usb/host/fhci-sched.c                      |  2 +-
 drivers/usb/host/fhci.h                            |  4 +-
 .../include/asm => include/linux/fsl}/immap_qe.h   |  0
 .../powerpc/include/asm => include/linux/fsl}/qe.h |  2 +-
 .../include/asm => include/linux/fsl}/qe_ic.h      |  0
 .../include/asm => include/linux/fsl}/ucc.h        |  4 +-
 .../include/asm => include/linux/fsl}/ucc_fast.h   |  6 +--
 .../include/asm => include/linux/fsl}/ucc_slow.h   |  6 +--
 44 files changed, 113 insertions(+), 113 deletions(-)
 delete mode 100644 arch/powerpc/sysdev/qe_lib/Kconfig
 create mode 100644 drivers/soc/qe/Kconfig
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/Makefile (100%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/gpio.c (99%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe.c (99%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.c (99%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.h (98%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_io.c (99%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc.c (98%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_fast.c (98%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_slow.c (98%)
 rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/usb.c (96%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/immap_qe.h (100%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/qe.h (99%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/qe_ic.h (100%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/ucc.h (96%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/ucc_fast.h (98%)
 rename {arch/powerpc/include/asm => include/linux/fsl}/ucc_slow.h (99%)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index bd6dd6e..65ca032 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1050,8 +1050,6 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "arch/powerpc/sysdev/qe_lib/Kconfig"
-
 source "lib/Kconfig"
 
 source "arch/powerpc/Kconfig.debug"
diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index bf4c447..584d8cc 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -37,8 +37,8 @@
 #include <asm/udbg.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 
 #include "mpc83xx.h"
 
diff --git a/arch/powerpc/platforms/83xx/misc.c b/arch/powerpc/platforms/83xx/misc.c
index 125336f..3e2e6d2 100644
--- a/arch/powerpc/platforms/83xx/misc.c
+++ b/arch/powerpc/platforms/83xx/misc.c
@@ -17,7 +17,7 @@
 #include <asm/io.h>
 #include <asm/hw_irq.h>
 #include <asm/ipic.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe_ic.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index 8d76220..e1186be 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -36,8 +36,8 @@
 #include <asm/udbg.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 
 #include "mpc83xx.h"
 
diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index eff5baa..9f75944 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -25,8 +25,8 @@
 #include <asm/time.h>
 #include <asm/ipic.h>
 #include <asm/udbg.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index 1a26d2f..7c1a22f 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -44,8 +44,8 @@
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 #include <sysdev/simple_gpio.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 
 #include "mpc83xx.h"
 
diff --git a/arch/powerpc/platforms/83xx/mpc836x_rdk.c b/arch/powerpc/platforms/83xx/mpc836x_rdk.c
index b63b42d..5e17d71 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_rdk.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_rdk.c
@@ -20,8 +20,8 @@
 #include <asm/time.h>
 #include <asm/ipic.h>
 #include <asm/udbg.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 
diff --git a/arch/powerpc/platforms/85xx/common.c b/arch/powerpc/platforms/85xx/common.c
index b564b5e..dfb21da 100644
--- a/arch/powerpc/platforms/85xx/common.c
+++ b/arch/powerpc/platforms/85xx/common.c
@@ -9,7 +9,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include <sysdev/cpm2_pic.h>
 
 #include "mpc85xx.h"
diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
index d22dd85..265c756 100644
--- a/arch/powerpc/platforms/85xx/corenet_generic.c
+++ b/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -26,7 +26,7 @@
 #include <asm/udbg.h>
 #include <asm/mpic.h>
 #include <asm/ehv_pic.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe_ic.h>
 
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index a392e94..7cf8eb5 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -47,8 +47,8 @@
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
 #include <sysdev/simple_gpio.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 #include <asm/mpic.h>
 #include <asm/swiotlb.h>
 #include <asm/fsl_guts.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index e358bed..d1b6d1b 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -25,8 +25,8 @@
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/mpic.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 #include <asm/fsl_guts.h>
 
 #include <sysdev/fsl_soc.h>
diff --git a/arch/powerpc/platforms/85xx/twr_p102x.c b/arch/powerpc/platforms/85xx/twr_p102x.c
index 1eadb6d..7df08d9 100644
--- a/arch/powerpc/platforms/85xx/twr_p102x.c
+++ b/arch/powerpc/platforms/85xx/twr_p102x.c
@@ -21,8 +21,8 @@
 #include <asm/pci-bridge.h>
 #include <asm/udbg.h>
 #include <asm/mpic.h>
-#include <asm/qe.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/qe_ic.h>
 #include <asm/fsl_guts.h>
 
 #include <sysdev/fsl_soc.h>
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 391b3f6..ae8879c 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -277,25 +277,6 @@ config TAU_AVERAGE
 
 	  If in doubt, say N here.
 
-config QUICC_ENGINE
-	bool "Freescale QUICC Engine (QE) Support"
-	depends on FSL_SOC && PPC32
-	select PPC_LIB_RHEAP
-	select CRC32
-	help
-	  The QUICC Engine (QE) is a new generation of communications
-	  coprocessors on Freescale embedded CPUs (akin to CPM in older chips).
-	  Selecting this option means that you wish to build a kernel
-	  for a machine with a QE coprocessor.
-
-config QE_GPIO
-	bool "QE GPIO support"
-	depends on QUICC_ENGINE
-	select ARCH_REQUIRE_GPIOLIB
-	help
-	  Say Y here if you're going to use hardware that connects to the
-	  QE GPIOs.
-
 config CPM2
 	bool "Enable support for the CPM2 (Communications Processor Module)"
 	depends on (FSL_SOC_BOOKE && PPC32) || 8260
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index f7cb2a1..087d301 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
 obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
 obj-$(CONFIG_FSL_RIO)		+= fsl_rio.o fsl_rmu.o
 obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o
-obj-$(CONFIG_QUICC_ENGINE)	+= qe_lib/
 mv64x60-$(CONFIG_PCI)		+= mv64x60_pci.o
 obj-$(CONFIG_MV64X60)		+= $(mv64x60-y) mv64x60_pic.o mv64x60_dev.o \
 				   mv64x60_udbg.o
diff --git a/arch/powerpc/sysdev/qe_lib/Kconfig b/arch/powerpc/sysdev/qe_lib/Kconfig
deleted file mode 100644
index 3c25199..0000000
--- a/arch/powerpc/sysdev/qe_lib/Kconfig
+++ /dev/null
@@ -1,27 +0,0 @@
-#
-# QE Communication options
-#
-
-config UCC_SLOW
-	bool
-	default y if SERIAL_QE
-	help
-	  This option provides qe_lib support to UCC slow
-	  protocols: UART, BISYNC, QMC
-
-config UCC_FAST
-	bool
-	default y if UCC_GETH
-	help
-	  This option provides qe_lib support to UCC fast
-	  protocols: HDLC, Ethernet, ATM, transparent
-
-config UCC
-	bool
-	default y if UCC_FAST || UCC_SLOW
-
-config QE_USB
-	bool
-	default y if USB_FSL_QE
-	help
-	  QE USB Controller support
diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
index 583e71a..958353c 100644
--- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
+++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
@@ -28,7 +28,7 @@
 #include <linux/of_device.h>
 
 #include <asm/io.h>
-#include <asm/ucc.h>	/* for ucc_set_qe_mux_mii_mng() */
+#include <linux/fsl/ucc.h>	/* for ucc_set_qe_mux_mii_mng() */
 
 #include "gianfar.h"
 
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index fab39e2..ef7740c 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -40,10 +40,10 @@
 #include <asm/uaccess.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
-#include <asm/ucc.h>
-#include <asm/ucc_fast.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/ucc.h>
+#include <linux/fsl/ucc_fast.h>
 #include <asm/machdep.h>
 
 #include "ucc_geth.h"
diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index 75f3371..a803635 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -22,11 +22,11 @@
 #include <linux/list.h>
 #include <linux/if_ether.h>
 
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
-#include <asm/ucc.h>
-#include <asm/ucc_fast.h>
+#include <linux/fsl/ucc.h>
+#include <linux/fsl/ucc_fast.h>
 
 #define DRV_DESC "QE UCC Gigabit Ethernet Controller"
 #define DRV_NAME "ucc_geth"
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index c854385..5432178 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -2,4 +2,6 @@ menu "SOC (System On Chip) specific Drivers"
 
 source "drivers/soc/qcom/Kconfig"
 
+source "drivers/soc/qe/Kconfig"
+
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 0f7c447..5da1a482 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -3,3 +3,5 @@
 #
 
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
+
+obj-$(CONFIG_QUICC_ENGINE)     += qe/
diff --git a/drivers/soc/qe/Kconfig b/drivers/soc/qe/Kconfig
new file mode 100644
index 0000000..8b03ca2
--- /dev/null
+++ b/drivers/soc/qe/Kconfig
@@ -0,0 +1,45 @@
+#
+# QE Communication options
+#
+config QUICC_ENGINE
+	bool "Freescale QUICC Engine (QE) Support"
+	depends on FSL_SOC && PPC32
+	select PPC_LIB_RHEAP
+	select CRC32
+	help
+	  The QUICC Engine (QE) is a new generation of communications
+	  coprocessors on Freescale embedded CPUs (akin to CPM in older chips).
+	  Selecting this option means that you wish to build a kernel
+	  for a machine with a QE coprocessor.
+
+config QE_GPIO
+	bool "QE GPIO support"
+	depends on QUICC_ENGINE
+	select ARCH_REQUIRE_GPIOLIB
+	help
+	  Say Y here if you're going to use hardware that connects to the
+	  QE GPIOs.
+
+config UCC_SLOW
+	bool
+	default y if SERIAL_QE
+	help
+	  This option provides qe_lib support to UCC slow
+	  protocols: UART, BISYNC, QMC
+
+config UCC_FAST
+	bool
+	default y if UCC_GETH
+	help
+	  This option provides qe_lib support to UCC fast
+	  protocols: HDLC, Ethernet, ATM, transparent
+
+config UCC
+	bool
+	default y if UCC_FAST || UCC_SLOW
+
+config QE_USB
+	bool
+	default y if USB_FSL_QE
+	help
+	  QE USB Controller support
diff --git a/arch/powerpc/sysdev/qe_lib/Makefile b/drivers/soc/qe/Makefile
similarity index 100%
rename from arch/powerpc/sysdev/qe_lib/Makefile
rename to drivers/soc/qe/Makefile
diff --git a/arch/powerpc/sysdev/qe_lib/gpio.c b/drivers/soc/qe/gpio.c
similarity index 99%
rename from arch/powerpc/sysdev/qe_lib/gpio.c
rename to drivers/soc/qe/gpio.c
index 521e67a..1e38588 100644
--- a/arch/powerpc/sysdev/qe_lib/gpio.c
+++ b/drivers/soc/qe/gpio.c
@@ -21,7 +21,7 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/export.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 
 struct qe_gpio_chip {
 	struct of_mm_gpio_chip mm_gc;
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/drivers/soc/qe/qe.c
similarity index 99%
rename from arch/powerpc/sysdev/qe_lib/qe.c
rename to drivers/soc/qe/qe.c
index 238a07b..1c5beef 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/drivers/soc/qe/qe.c
@@ -32,8 +32,8 @@
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 #include <asm/prom.h>
 #include <asm/rheap.h>
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/drivers/soc/qe/qe_ic.c
similarity index 99%
rename from arch/powerpc/sysdev/qe_lib/qe_ic.c
rename to drivers/soc/qe/qe_ic.c
index b2b87c3..eb4d160 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ b/drivers/soc/qe/qe_ic.c
@@ -28,7 +28,7 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/prom.h>
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe_ic.h>
 
 #include "qe_ic.h"
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.h b/drivers/soc/qe/qe_ic.h
similarity index 98%
rename from arch/powerpc/sysdev/qe_lib/qe_ic.h
rename to drivers/soc/qe/qe_ic.h
index efef7ab..5c4480e 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_ic.h
+++ b/drivers/soc/qe/qe_ic.h
@@ -16,7 +16,7 @@
 #ifndef _POWERPC_SYSDEV_QE_IC_H
 #define _POWERPC_SYSDEV_QE_IC_H
 
-#include <asm/qe_ic.h>
+#include <linux/fsl/qe_ic.h>
 
 #define NR_QE_IC_INTS		64
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe_io.c b/drivers/soc/qe/qe_io.c
similarity index 99%
rename from arch/powerpc/sysdev/qe_lib/qe_io.c
rename to drivers/soc/qe/qe_io.c
index d099941..3bdc2c7 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c
+++ b/drivers/soc/qe/qe_io.c
@@ -21,7 +21,7 @@
 #include <linux/ioport.h>
 
 #include <asm/io.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include <asm/prom.h>
 #include <sysdev/fsl_soc.h>
 
diff --git a/arch/powerpc/sysdev/qe_lib/ucc.c b/drivers/soc/qe/ucc.c
similarity index 98%
rename from arch/powerpc/sysdev/qe_lib/ucc.c
rename to drivers/soc/qe/ucc.c
index 621575b..36a206f 100644
--- a/arch/powerpc/sysdev/qe_lib/ucc.c
+++ b/drivers/soc/qe/ucc.c
@@ -21,9 +21,9 @@
 
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
-#include <asm/ucc.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/ucc.h>
 
 int ucc_set_qe_mux_mii_mng(unsigned int ucc_num)
 {
diff --git a/arch/powerpc/sysdev/qe_lib/ucc_fast.c b/drivers/soc/qe/ucc_fast.c
similarity index 98%
rename from arch/powerpc/sysdev/qe_lib/ucc_fast.c
rename to drivers/soc/qe/ucc_fast.c
index 65aaf15..223bb36 100644
--- a/arch/powerpc/sysdev/qe_lib/ucc_fast.c
+++ b/drivers/soc/qe/ucc_fast.c
@@ -21,11 +21,11 @@
 #include <linux/export.h>
 
 #include <asm/io.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
-#include <asm/ucc.h>
-#include <asm/ucc_fast.h>
+#include <linux/fsl/ucc.h>
+#include <linux/fsl/ucc_fast.h>
 
 void ucc_fast_dump_regs(struct ucc_fast_private * uccf)
 {
diff --git a/arch/powerpc/sysdev/qe_lib/ucc_slow.c b/drivers/soc/qe/ucc_slow.c
similarity index 98%
rename from arch/powerpc/sysdev/qe_lib/ucc_slow.c
rename to drivers/soc/qe/ucc_slow.c
index befaf11..7dfff79 100644
--- a/arch/powerpc/sysdev/qe_lib/ucc_slow.c
+++ b/drivers/soc/qe/ucc_slow.c
@@ -21,11 +21,11 @@
 #include <linux/export.h>
 
 #include <asm/io.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
-#include <asm/ucc.h>
-#include <asm/ucc_slow.h>
+#include <linux/fsl/ucc.h>
+#include <linux/fsl/ucc_slow.h>
 
 u32 ucc_slow_get_qe_cr_subblock(int uccs_num)
 {
diff --git a/arch/powerpc/sysdev/qe_lib/usb.c b/drivers/soc/qe/usb.c
similarity index 96%
rename from arch/powerpc/sysdev/qe_lib/usb.c
rename to drivers/soc/qe/usb.c
index 27f23bd..0bcdf7d 100644
--- a/arch/powerpc/sysdev/qe_lib/usb.c
+++ b/drivers/soc/qe/usb.c
@@ -17,8 +17,8 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/io.h>
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
 int qe_usb_clock_set(enum qe_clock clk, int rate)
 {
diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
index 54b0637..b23676f 100644
--- a/drivers/spi/spi-fsl-cpm.c
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -22,7 +22,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/of_address.h>
 #include <asm/cpm.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 
 #include "spi-fsl-lib.h"
 #include "spi-fsl-cpm.h"
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index d569ca5..493f74e 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -31,7 +31,7 @@
 #include <linux/dma-mapping.h>
 
 #include <linux/fs_uart_pd.h>
-#include <asm/ucc_slow.h>
+#include <linux/fsl/ucc_slow.h>
 
 #include <linux/firmware.h>
 #include <asm/reg.h>
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index ad54833..a1d4e00 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -38,7 +38,7 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include <asm/cpm.h>
 #include <asm/dma.h>
 #include <asm/reg.h>
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 1cf68ea..7df4e74 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -31,7 +31,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include <asm/fsl_gtm.h>
 #include "fhci.h"
 
diff --git a/drivers/usb/host/fhci-hub.c b/drivers/usb/host/fhci-hub.c
index 6af2512..31b4402 100644
--- a/drivers/usb/host/fhci-hub.c
+++ b/drivers/usb/host/fhci-hub.c
@@ -24,7 +24,7 @@
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/gpio.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include "fhci.h"
 
 /* virtual root hub specific descriptor */
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 95ca598..6f1d4ad 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -25,7 +25,7 @@
 #include <linux/io.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <asm/qe.h>
+#include <linux/fsl/qe.h>
 #include <asm/fsl_gtm.h>
 #include "fhci.h"
 
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index 154e6a0..d7c49531 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -27,8 +27,8 @@
 #include <linux/io.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
-#include <asm/qe.h>
-#include <asm/immap_qe.h>
+#include <linux/fsl/qe.h>
+#include <linux/fsl/immap_qe.h>
 
 #define USB_CLOCK	48000000
 
diff --git a/arch/powerpc/include/asm/immap_qe.h b/include/linux/fsl/immap_qe.h
similarity index 100%
rename from arch/powerpc/include/asm/immap_qe.h
rename to include/linux/fsl/immap_qe.h
diff --git a/arch/powerpc/include/asm/qe.h b/include/linux/fsl/qe.h
similarity index 99%
rename from arch/powerpc/include/asm/qe.h
rename to include/linux/fsl/qe.h
index 32b9bfa..1c9d626 100644
--- a/arch/powerpc/include/asm/qe.h
+++ b/include/linux/fsl/qe.h
@@ -20,7 +20,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <asm/cpm.h>
-#include <asm/immap_qe.h>
+#include <linux/fsl/immap_qe.h>
 
 #define QE_NUM_OF_SNUM	256	/* There are 256 serial number in QE */
 #define QE_NUM_OF_BRGS	16
diff --git a/arch/powerpc/include/asm/qe_ic.h b/include/linux/fsl/qe_ic.h
similarity index 100%
rename from arch/powerpc/include/asm/qe_ic.h
rename to include/linux/fsl/qe_ic.h
diff --git a/arch/powerpc/include/asm/ucc.h b/include/linux/fsl/ucc.h
similarity index 96%
rename from arch/powerpc/include/asm/ucc.h
rename to include/linux/fsl/ucc.h
index 6927ac2..d448813 100644
--- a/arch/powerpc/include/asm/ucc.h
+++ b/include/linux/fsl/ucc.h
@@ -15,8 +15,8 @@
 #ifndef __UCC_H__
 #define __UCC_H__
 
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
 #define STATISTICS
 
diff --git a/arch/powerpc/include/asm/ucc_fast.h b/include/linux/fsl/ucc_fast.h
similarity index 98%
rename from arch/powerpc/include/asm/ucc_fast.h
rename to include/linux/fsl/ucc_fast.h
index 72ea9ba..101fae7 100644
--- a/arch/powerpc/include/asm/ucc_fast.h
+++ b/include/linux/fsl/ucc_fast.h
@@ -16,10 +16,10 @@
 
 #include <linux/kernel.h>
 
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
-#include <asm/ucc.h>
+#include <linux/fsl/ucc.h>
 
 /* Receive BD's status */
 #define R_E	0x80000000	/* buffer empty */
diff --git a/arch/powerpc/include/asm/ucc_slow.h b/include/linux/fsl/ucc_slow.h
similarity index 99%
rename from arch/powerpc/include/asm/ucc_slow.h
rename to include/linux/fsl/ucc_slow.h
index c44131e..61f4c83 100644
--- a/arch/powerpc/include/asm/ucc_slow.h
+++ b/include/linux/fsl/ucc_slow.h
@@ -17,10 +17,10 @@
 
 #include <linux/kernel.h>
 
-#include <asm/immap_qe.h>
-#include <asm/qe.h>
+#include <linux/fsl/immap_qe.h>
+#include <linux/fsl/qe.h>
 
-#include <asm/ucc.h>
+#include <linux/fsl/ucc.h>
 
 /* transmit BD's status */
 #define T_R	0x80000000	/* ready bit */
-- 
2.1.0.27.g96db324

