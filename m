Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3CTJJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:09:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53102 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763Ab3CTJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:09:44 -0400
Message-ID: <1363770579.1390.82.camel@x61.thuisdomein>
Subject: [PATCH v2] mfd: remove twelve unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 10:09:39 +0100
In-Reply-To: <20130320082427.GB28775@opensource.wolfsonmicro.com>
References: <1363732701.1390.45.camel@x61.thuisdomein>
	 <20130320082427.GB28775@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 09:09:39.0466 (UTC) FILETIME=[A6AFA6A0:01CE254A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Twelve Kconfig symbols, all related to WM8350, WM8351, and WM8352, are
unused. Commit 19d57ed5a308472a02e773f33c03ad4cb2ec6a9 ("mfd: Remove
custom wm8350 cache implementation") removed all their (actual) users.
Remove these symbols too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
0) This version adds Mark's ACK. It is now also sent to the ARM
maintainers, as Mark suggested.

1) Still only eyeball tested.

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

