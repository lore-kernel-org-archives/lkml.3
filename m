Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3CSWiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:38:24 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54005 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423Ab3CSWiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:38:22 -0400
Message-ID: <1363732701.1390.45.camel@x61.thuisdomein>
Subject: [PATCH] mfd: remove twelve unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 23:38:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 22:38:21.0182 (UTC) FILETIME=[757831E0:01CE24F2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Twelve Kconfig symbols, all related to WM8350, WM8351, and WM8352, are
unused. Commit 19d57ed5a308472a02e773f33c03ad4cb2ec6a9 ("mfd: Remove
custom wm8350 cache implementation") removed all their (actual) users.
Remove these symbols too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Eyeball tested. (With a lot of help from "git grep", that is.)

1) I did not sent this to the ARM maintainers!

 arch/arm/mach-imx/Kconfig     |  2 --
 arch/arm/mach-s3c64xx/Kconfig |  3 ---
 drivers/mfd/Kconfig           | 48 -------------------------------------------
 3 files changed, 53 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 4c9c6f9..6d9ae09 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -481,8 +481,6 @@ config MACH_MX31ADS_WM1133_EV1
 	depends on MACH_MX31ADS
 	depends on MFD_WM8350_I2C
 	depends on REGULATOR_WM8350 = y
-	select MFD_WM8350_CONFIG_MODE_0
-	select MFD_WM8352_CONFIG_MODE_0
 	help
 	  Include support for the Wolfson Microelectronics 1133-EV1 PMU
 	  and audio module for the MX31ADS platform.
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 131c862..041da51 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -198,10 +198,7 @@ endchoice
 config SMDK6410_WM1190_EV1
 	bool "Support Wolfson Microelectronics 1190-EV1 PMIC card"
 	depends on MACH_SMDK6410
-	select MFD_WM8350_CONFIG_MODE_0
-	select MFD_WM8350_CONFIG_MODE_3
 	select MFD_WM8350_I2C
-	select MFD_WM8352_CONFIG_MODE_0
 	select REGULATOR
 	select REGULATOR_WM8350
 	select SAMSUNG_GPIO_EXTRA64
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..ebb1bed 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -687,54 +687,6 @@ config MFD_WM8350
 	bool
 	depends on GENERIC_HARDIRQS
 
-config MFD_WM8350_CONFIG_MODE_0
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8350_CONFIG_MODE_1
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8350_CONFIG_MODE_2
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8350_CONFIG_MODE_3
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8351_CONFIG_MODE_0
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8351_CONFIG_MODE_1
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8351_CONFIG_MODE_2
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8351_CONFIG_MODE_3
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8352_CONFIG_MODE_0
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8352_CONFIG_MODE_1
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8352_CONFIG_MODE_2
-	bool
-	depends on MFD_WM8350
-
-config MFD_WM8352_CONFIG_MODE_3
-	bool
-	depends on MFD_WM8350
-
 config MFD_WM8350_I2C
 	bool "Support Wolfson Microelectronics WM8350 with I2C"
 	select MFD_WM8350
-- 
1.7.11.7

