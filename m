Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660Ab3B1PWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:22:16 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:37390 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab3B1PV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:21:59 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-leds@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        ldewangan@nvidia.com, j-keerthy@ti.com, gg@slimlogic.co.uk,
        cooloney@gmail.com, rpurdie@rpsys.net, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH v2 2/2] leds: Kconfig for Palmas LEDs
Date: Thu, 28 Feb 2013 15:21:49 +0000
Message-Id: <1362064909-634-2-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk>
References: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Kconfig and Makefile for the Palmas LED driver.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/leds/Kconfig  |    9 +++++++++
 drivers/leds/Makefile |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ec50824..a070e29 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -469,6 +469,15 @@ config LEDS_BLINKM
 	  This option enables support for the BlinkM RGB LED connected
 	  through I2C. Say Y to enable support for the BlinkM LED.
 
+config LEDS_PALMAS
+	bool "LED support for the Palmas family of PMICs"
+	depends on LEDS_CLASS
+	depends on MFD_PALMAS
+	help
+	  This option enables the driver for LED1 & LED2 pins on Palmas PMIC
+	  if these pins are enabled in the mux configuration. The driver support
+	  ON/OFF and blinking with hardware control.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 215e7e3..233023e 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
+obj-$(CONFIG_LEDS_PALMAS)		+= leds-palmas.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
-- 
1.7.0.4

