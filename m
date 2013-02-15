Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537Ab3BOMqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:53 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:47936 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161522Ab3BOMqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/40] pm2301-charger: Removed unused code from PM2301 driver
Date: Fri, 15 Feb 2013 12:45:00 +0000
Message-Id: <1360932310-30065-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

Some of the headers and defines accrued over time are no longer
in use. Let's take the opportunity to remove a few of them.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |    5 -----
 drivers/power/pm2301_charger.h |   22 ----------------------
 2 files changed, 27 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 2cc92ec..cb1c953 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -16,16 +16,12 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-#include <linux/completion.h>
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
-#include <linux/kobject.h>
-#include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
-#include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/pm2301_charger.h>
 #include <linux/gpio.h>
@@ -1018,7 +1014,6 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 	/* get parent data */
 	pm2->dev = &i2c_client->dev;
-	pm2->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	pm2->pm2_int = &pm2xxx_int;
 
diff --git a/drivers/power/pm2301_charger.h b/drivers/power/pm2301_charger.h
index fad1f38..8ce3cc0 100644
--- a/drivers/power/pm2301_charger.h
+++ b/drivers/power/pm2301_charger.h
@@ -9,27 +9,6 @@
 #ifndef PM2301_CHARGER_H
 #define PM2301_CHARGER_H
 
-#define MAIN_WDOG_ENA			0x01
-#define MAIN_WDOG_KICK			0x02
-#define MAIN_WDOG_DIS			0x00
-#define CHARG_WD_KICK			0x01
-#define MAIN_CH_ENA			0x01
-#define MAIN_CH_NO_OVERSHOOT_ENA_N	0x02
-#define MAIN_CH_DET			0x01
-#define MAIN_CH_CV_ON			0x04
-#define OTP_ENABLE_WD			0x01
-
-#define MAIN_CH_INPUT_CURR_SHIFT	4
-
-#define LED_INDICATOR_PWM_ENA		0x01
-#define LED_INDICATOR_PWM_DIS		0x00
-#define LED_IND_CUR_5MA			0x04
-#define LED_INDICATOR_PWM_DUTY_252_256	0xBF
-
-/* HW failure constants */
-#define MAIN_CH_TH_PROT			0x02
-#define MAIN_CH_NOK			0x01
-
 /* Watchdog timeout constant */
 #define WD_TIMER			0x30 /* 4min */
 #define WD_KICK_INTERVAL		(30 * HZ)
@@ -495,7 +474,6 @@ struct pm2xxx_charger {
 	int failure_input_ovv;
 	unsigned int lpn_pin;
 	struct pm2xxx_interrupts *pm2_int;
-	struct ab8500_gpadc *gpadc;
 	struct regulator *regu;
 	struct pm2xxx_bm_data *bat;
 	struct mutex lock;
-- 
1.7.10.4

