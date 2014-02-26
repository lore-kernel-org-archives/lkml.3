Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaBZAZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:25:20 -0500
Received: from ring0.de ([5.45.105.125]:47193 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbaBZAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:25:16 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv3 7/7] mfd: twl4030-madc: Move driver to drivers/iio/adc
Date: Wed, 26 Feb 2014 01:24:30 +0100
Message-Id: <1393374270-20079-8-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393374270-20079-1-git-send-email-sre@debian.org>
References: <1393193271-16717-1-git-send-email-sre@debian.org>
 <1393374270-20079-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for an A/D converter, which belongs into
drivers/iio/adc.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/adc/Kconfig                 | 10 ++++++++++
 drivers/iio/adc/Makefile                |  1 +
 drivers/{mfd => iio/adc}/twl4030-madc.c |  0
 drivers/mfd/Kconfig                     | 10 ----------
 drivers/mfd/Makefile                    |  1 -
 5 files changed, 11 insertions(+), 11 deletions(-)
 rename drivers/{mfd => iio/adc}/twl4030-madc.c (100%)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 2209f28..427f75c 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -183,6 +183,16 @@ config TI_AM335X_ADC
 	  Say yes here to build support for Texas Instruments ADC
 	  driver which is also a MFD client.
 
+config TWL4030_MADC
+	tristate "TWL4030 MADC (Monitoring A/D Converter)"
+	depends on TWL4030_CORE
+	help
+	This driver provides support for Triton TWL4030-MADC. The
+	driver supports both RT and SW conversion methods.
+
+	This driver can also be built as a module. If so, the module will be
+	called twl4030-madc.
+
 config TWL6030_GPADC
 	tristate "TWL6030 GPADC (General Purpose A/D Converter) Support"
 	depends on TWL4030_CORE
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ba9a10a..9acf2df 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -20,5 +20,6 @@ obj-$(CONFIG_MCP3422) += mcp3422.o
 obj-$(CONFIG_NAU7802) += nau7802.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
+obj-$(CONFIG_TWL4030_MADC) += twl4030-madc.o
 obj-$(CONFIG_TWL6030_GPADC) += twl6030-gpadc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/iio/adc/twl4030-madc.c
similarity index 100%
rename from drivers/mfd/twl4030-madc.c
rename to drivers/iio/adc/twl4030-madc.c
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445..23a8a51 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -935,16 +935,6 @@ config TWL4030_CORE
 	  high speed USB OTG transceiver, an audio codec (on most
 	  versions) and many other features.
 
-config TWL4030_MADC
-	tristate "TI TWL4030 MADC"
-	depends on TWL4030_CORE
-	help
-	This driver provides support for triton TWL4030-MADC. The
-	driver supports both RT and SW conversion methods.
-
-	This driver can be built as a module. If so it will be
-	named twl4030-madc
-
 config TWL4030_POWER
 	bool "TI TWL4030 power resources"
 	depends on TWL4030_CORE && ARM
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5aea5ef..c8eb0bc 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -71,7 +71,6 @@ obj-$(CONFIG_MFD_TPS80031)	+= tps80031.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
-obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
 obj-$(CONFIG_TWL6040_CORE)	+= twl6040.o
-- 
1.8.5.3

