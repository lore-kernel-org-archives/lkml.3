Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3FLROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:14:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:44772 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3FLROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:14:48 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 14/21] input: mfd: ti_am335x_tsc remove remaining platform data pieces
Date: Wed, 12 Jun 2013 18:58:15 +0200
Message-Id: <1371056302-12714-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
References: <1371056302-12714-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two header files removed here are unused and have no users as this
platform was never used with platform devices.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/input/ti_am335x_tsc.h         |   35 ---------------------------
 include/linux/mfd/ti_am335x_tscadc.h        |    5 ----
 include/linux/platform_data/ti_am335x_adc.h |   14 -----------
 3 files changed, 54 deletions(-)
 delete mode 100644 include/linux/input/ti_am335x_tsc.h
 delete mode 100644 include/linux/platform_data/ti_am335x_adc.h

diff --git a/include/linux/input/ti_am335x_tsc.h b/include/linux/input/ti_am335x_tsc.h
deleted file mode 100644
index 6a66b4d..0000000
--- a/include/linux/input/ti_am335x_tsc.h
+++ /dev/null
@@ -1,35 +0,0 @@
-#ifndef __LINUX_TI_AM335X_TSC_H
-#define __LINUX_TI_AM335X_TSC_H
-
-/**
- * struct tsc_data	Touchscreen wire configuration
- * @wires:		Wires refer to application modes
- *			i.e. 4/5/8 wire touchscreen support
- *			on the platform.
- * @x_plate_resistance:	X plate resistance.
- * @steps_to_configure:	The sequencer supports a total of
- *			16 programmable steps.
- *			A step configured to read a single
- *			co-ordinate value, can be applied
- *			more number of times for better results.
- * @wire_config:	Different EVM's could have a different order
- *			for connecting wires on touchscreen.
- *			We need to provide an 8 bit number where in
- *			the 1st four bits represent the analog lines
- *			and the next 4 bits represent positive/
- *			negative terminal on that input line.
- *			Notations to represent the input lines and
- *			terminals resoectively is as follows:
- *			AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
- *			XP  = 0, XN = 1, YP = 2, YN = 3.
- *
- */
-
-struct tsc_data {
-	int wires;
-	int x_plate_resistance;
-	int steps_to_configure;
-	int wire_config[10];
-};
-
-#endif
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index fe54ba4..533f200 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -120,11 +120,6 @@
 
 #define TSCADC_CELLS		2
 
-struct mfd_tscadc_board {
-	struct tsc_data *tsc_init;
-	struct adc_data *adc_init;
-};
-
 struct ti_tscadc_dev {
 	struct device *dev;
 	struct regmap *regmap_tscadc;
diff --git a/include/linux/platform_data/ti_am335x_adc.h b/include/linux/platform_data/ti_am335x_adc.h
deleted file mode 100644
index e41d583..0000000
--- a/include/linux/platform_data/ti_am335x_adc.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef __LINUX_TI_AM335X_ADC_H
-#define __LINUX_TI_AM335X_ADC_H
-
-/**
- * struct adc_data	ADC Input information
- * @adc_channels:	Number of analog inputs
- *			available for ADC.
- */
-
-struct adc_data {
-	unsigned int adc_channels;
-};
-
-#endif
-- 
1.7.10.4

