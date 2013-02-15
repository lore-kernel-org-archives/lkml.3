Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161514Ab3BOMxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:53:05 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57782 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161428Ab3BOMqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/40] pm2301-charger: Always compile the PM2301 Charger driver with AB8500 Battery Mgnt
Date: Fri, 15 Feb 2013 12:44:49 +0000
Message-Id: <1360932310-30065-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

The PM2301 Charger should always be available when using the AB8500
Battery Management system, we're ensuring this will be the case.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
---
 drivers/power/Kconfig          |    7 -------
 drivers/power/Makefile         |    3 +--
 drivers/power/ab8500_charger.c |    6 +++---
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 1e47197..1ae5155 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -352,13 +352,6 @@ config BATTERY_GOLDFISH
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
 
-config CHARGER_PM2301
-	bool "PM2301 Battery Charger Driver"
-	depends on AB8500_BM
-	help
-	  Say Y to include support for PM2301 charger driver.
-	  Depends on AB8500 battery management core.
-
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 3f66436..eb520ea 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
 obj-$(CONFIG_BATTERY_RX51)	+= rx51_battery.o
-obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
+obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o pm2301_charger.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
@@ -47,7 +47,6 @@ obj-$(CONFIG_CHARGER_LP8727)	+= lp8727_charger.o
 obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
-obj-$(CONFIG_CHARGER_PM2301)	+= pm2301_charger.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index b5c7a39..6fea4fd 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3387,10 +3387,10 @@ static int ab8500_charger_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	if (di->usb_chg.enabled)
 		power_supply_unregister(&di->usb_chg.psy);
-#if !defined(CONFIG_CHARGER_PM2301)
-	if (di->ac_chg.enabled)
+
+	if (di->ac_chg.enabled && !di->ac_chg.external)
 		power_supply_unregister(&di->ac_chg.psy);
-#endif
+
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.10.4

