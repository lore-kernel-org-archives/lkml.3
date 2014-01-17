Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAQFp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:45:56 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4636 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbaAQFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:45:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Prabhakar Kushwaha <prabhakar@freescale.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <scottwood@freescale.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: [PATCH 1/2][4] driver/memory:Move Freescale IFC driver to a common driver
Date: Fri, 17 Jan 2014 11:15:16 +0530
Message-ID: <1389937516-29563-1-git-send-email-prabhakar@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Freescale IFC controller has been used for mpc8xxx. It will be used
 for ARM-based SoC as well. This patch moves the driver to driver/memory
 and fix the header file includes.

  Also remove module_platform_driver() and  instead call
  platform_driver_register() from subsys_initcall() to make sure this module
  has been loaded before MTD partition parsing starts.

Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
Changes for v2:
	- Move fsl_ifc in driver/memory

Changes for v3:
	- move device tree bindings to memory

Changes for v4: Rebased to 
	git://git.kernel.org/pub/scm/linux/kernel/git/scottwood/linux.git

 .../{powerpc => memory-controllers}/fsl/ifc.txt    |    0
 arch/powerpc/sysdev/Makefile                       |    1 -
 drivers/memory/Makefile                            |    1 +
 {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c  |    8 ++++++--
 drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
 .../include/asm => include/linux}/fsl_ifc.h        |    0
 6 files changed, 8 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/{powerpc => memory-controllers}/fsl/ifc.txt (100%)
 rename {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c (98%)
 rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/ifc.txt b/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
similarity index 100%
rename from Documentation/devicetree/bindings/powerpc/fsl/ifc.txt
rename to Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 99464a7..ec69532 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -19,7 +19,6 @@ obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o fsl_mpic_err.o
 obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o $(fsl-msi-obj-y)
 obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
 obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
-obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
 obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
 obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index 9cce5d7..b494e5b 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -6,5 +6,6 @@ ifeq ($(CONFIG_DDR),y)
 obj-$(CONFIG_OF)		+= of_memory.o
 endif
 obj-$(CONFIG_TI_EMIF)		+= emif.o
+obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
diff --git a/arch/powerpc/sysdev/fsl_ifc.c b/drivers/memory/fsl_ifc.c
similarity index 98%
rename from arch/powerpc/sysdev/fsl_ifc.c
rename to drivers/memory/fsl_ifc.c
index d7fc722..135a950 100644
--- a/arch/powerpc/sysdev/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -30,8 +30,8 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/fsl_ifc.h>
 #include <asm/prom.h>
-#include <asm/fsl_ifc.h>
 
 struct fsl_ifc_ctrl *fsl_ifc_ctrl_dev;
 EXPORT_SYMBOL(fsl_ifc_ctrl_dev);
@@ -299,7 +299,11 @@ static struct platform_driver fsl_ifc_ctrl_driver = {
 	.remove      = fsl_ifc_ctrl_remove,
 };
 
-module_platform_driver(fsl_ifc_ctrl_driver);
+static int __init fsl_ifc_init(void)
+{
+	return platform_driver_register(&fsl_ifc_ctrl_driver);
+}
+subsys_initcall(fsl_ifc_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Freescale Semiconductor");
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index f1f7f12..43d1a92 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -29,7 +29,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand_ecc.h>
-#include <asm/fsl_ifc.h>
+#include <linux/fsl_ifc.h>
 
 #define FSL_IFC_V1_1_0	0x01010000
 #define ERR_BYTE		0xFF /* Value returned for read
diff --git a/arch/powerpc/include/asm/fsl_ifc.h b/include/linux/fsl_ifc.h
similarity index 100%
rename from arch/powerpc/include/asm/fsl_ifc.h
rename to include/linux/fsl_ifc.h
-- 
1.7.9.5



