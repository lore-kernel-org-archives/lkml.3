Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaGMDHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:07:21 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37119 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaGMDHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:07:16 -0400
Message-ID: <53C1F7DE.3060102@gmail.com>
Date: Sun, 13 Jul 2014 11:07:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, benh@kernel.crashing.org, kys@microsoft.com,
        schwidefsky@de.ibm.com, teg@jklm.no, Mischa.Jonker@synopsys.com,
        msalter@redhat.com, lars@metafoo.de, richard@nod.at, knaack.h@gmx.de,
        marex@denx.de, rdunlap@infradead.org, linux-input@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers need 'devm_ioremap_resource' which need HAS_IOMEM enabled.
So let them depend on HAS_IOMEM.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/staging/iio/adc/mxs-lradc.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/input/serio/olpc_apsp.ko] undefined!
  ERROR: "devm_ioremap_resource" [drivers/input/serio/arc_ps2.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/input/serio/Kconfig     | 3 ++-
 drivers/pwm/Kconfig             | 2 +-
 drivers/staging/iio/adc/Kconfig | 2 +-
 drivers/watchdog/Kconfig        | 3 ++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index bc2d474..449d45f 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -244,6 +244,7 @@ config SERIO_PS2MULT
 
 config SERIO_ARC_PS2
 	tristate "ARC PS/2 support"
+	depends on HAS_IOMEM
 	help
 	  Say Y here if you have an ARC FPGA platform with a PS/2
 	  controller in it.
@@ -263,7 +264,7 @@ config SERIO_APBPS2
 
 config SERIO_OLPC_APSP
 	tristate "OLPC AP-SP input support"
-	depends on OLPC || COMPILE_TEST
+	depends on (OLPC || COMPILE_TEST) && HAS_IOMEM
 	help
 	  Say Y here if you want support for the keyboard and touchpad included
 	  in the OLPC XO-1.75 and XO-4 laptops.
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 4ad7b89..2faf5ce 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -82,7 +82,7 @@ config PWM_BFIN
 
 config PWM_CLPS711X
 	tristate "CLPS711X PWM support"
-	depends on ARCH_CLPS711X || COMPILE_TEST
+	depends on (ARCH_CLPS711X || COMPILE_TEST) && HAS_IOMEM
 	help
 	  Generic PWM framework driver for Cirrus Logic CLPS711X.
 
diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index b87e382..4e927d2 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -94,7 +94,7 @@ config LPC32XX_ADC
 
 config MXS_LRADC
 	tristate "Freescale i.MX23/i.MX28 LRADC"
-	depends on ARCH_MXS || COMPILE_TEST
+	depends on (ARCH_MXS || COMPILE_TEST) && HAS_IOMEM
 	depends on INPUT
 	select STMP_DEVICE
 	select IIO_BUFFER
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 76dd541..0e4abb2 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -113,6 +113,7 @@ config WM8350_WATCHDOG
 
 config XILINX_WATCHDOG
 	tristate "Xilinx Watchdog timer"
+	depends on HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Watchdog driver for the xps_timebase_wdt ip core.
@@ -434,7 +435,7 @@ config SIRFSOC_WATCHDOG
 
 config TEGRA_WATCHDOG
 	tristate "Tegra watchdog"
-	depends on ARCH_TEGRA || COMPILE_TEST
+	depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
 	select WATCHDOG_CORE
 	help
 	  Say Y here to include support for the watchdog timer
-- 
1.7.11.7
