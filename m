Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaAMFYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:24:50 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:32016
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbaAMFYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:24:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Prabhakar Kushwaha <prabhakar@freescale.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
Date: Mon, 13 Jan 2014 10:54:31 +0530
Message-ID: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
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
for ARM-based SoC as well. This patch moves the driver to driver/misc
and fix the header file includes.

Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
---
 arch/powerpc/sysdev/Makefile                       |    1 -
 drivers/misc/Makefile                              |    1 +
 {arch/powerpc/sysdev => drivers/misc}/fsl_ifc.c    |    2 +-
 drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
 .../include/asm => include/linux}/fsl_ifc.h        |    0
 5 files changed, 3 insertions(+), 3 deletions(-)
 rename {arch/powerpc/sysdev => drivers/misc}/fsl_ifc.c (99%)
 rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)

diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index f67ac90..afbcc37 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -21,7 +21,6 @@ obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o fsl_mpic_err.o
 obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o $(fsl-msi-obj-y)
 obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
 obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
-obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
 obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
 obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f45473e..61c6271 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_BMP085_I2C)	+= bmp085-i2c.o
 obj-$(CONFIG_BMP085_SPI)	+= bmp085-spi.o
 obj-$(CONFIG_DUMMY_IRQ)		+= dummy-irq.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
+obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
diff --git a/arch/powerpc/sysdev/fsl_ifc.c b/drivers/misc/fsl_ifc.c
similarity index 99%
rename from arch/powerpc/sysdev/fsl_ifc.c
rename to drivers/misc/fsl_ifc.c
index d7fc722..d4ae878 100644
--- a/arch/powerpc/sysdev/fsl_ifc.c
+++ b/drivers/misc/fsl_ifc.c
@@ -30,8 +30,8 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/fsl_ifc.h>
 #include <asm/prom.h>
-#include <asm/fsl_ifc.h>
 
 struct fsl_ifc_ctrl *fsl_ifc_ctrl_dev;
 EXPORT_SYMBOL(fsl_ifc_ctrl_dev);
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 4335577..865b323 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -30,7 +30,7 @@
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



