Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3KULcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:32:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36999 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3KUL3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:29:54 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2 08/10] mtd: nand: davinci: reuse driver for Keystone arch
Date: Thu, 21 Nov 2013 13:28:23 +0200
Message-ID: <1385033305-13179-9-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1385033305-13179-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone arch has compatible nand device, so reuse it.
In case with Keystone it depends on TI_AEMIF because AEMIF
driver is responsible to set timings.

See http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/mtd/davinci-nand.txt       |    8 +++++---
 drivers/mtd/nand/Kconfig                           |    6 +++---
 drivers/mtd/nand/davinci_nand.c                    |    1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
index befaa5b..cfb18ab 100644
--- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
@@ -1,14 +1,16 @@
-Device tree bindings for Texas instruments Davinci NAND controller
+Device tree bindings for Texas instruments Davinci/Keystone NAND controller
 
-This file provides information, what the device node for the davinci NAND
-interface contains.
+This file provides information, what the device node for the davinci/keystone
+NAND interface contains.
 
 Documentation:
 Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
+Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
 
 Required properties:
 
 - compatible:			"ti,davinci-nand"
+				"ti,keystone-nand"
 
 - reg:				Contains 2 offset/length values:
 				- offset and length for the access window.
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index d885298..8bf69c7 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -492,11 +492,11 @@ config MTD_NAND_SH_FLCTL
 	  for NAND Flash using FLCTL.
 
 config MTD_NAND_DAVINCI
-        tristate "Support NAND on DaVinci SoC"
-        depends on ARCH_DAVINCI
+        tristate "Support NAND on DaVinci/Keystone SoC"
+        depends on ARCH_DAVINCI || (ARCH_KEYSTONE && TI_AEMIF)
         help
 	  Enable the driver for NAND flash chips on Texas Instruments
-	  DaVinci processors.
+	  DaVinci/Keystone processors.
 
 config MTD_NAND_TXX9NDFMC
 	tristate "NAND Flash support for TXx9 SoC"
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index f7b21b8..8459720 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -523,6 +523,7 @@ static struct nand_ecclayout hwecc4_2048 __initconst = {
 #if defined(CONFIG_OF)
 static const struct of_device_id davinci_nand_of_match[] = {
 	{.compatible = "ti,davinci-nand", },
+	{.compatible = "ti,keystone-nand", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, davinci_nand_of_match);
-- 
1.7.9.5

