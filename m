Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3AUMFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:05:06 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62300 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3AUMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:05:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/24] ab8500-bm: Remove individual [charger|btemp|fg|chargalg] pdata structures
Date: Mon, 21 Jan 2013 12:03:58 +0000
Message-Id: <1358769840-4763-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the aforementioned components have their own dedicated
platform data structures anymore. Instead they have all been
merged into one big Battery Management container. Let's remove
them and place all the nice newly added attributes into the core
container.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c       |    4 ++--
 include/linux/mfd/abx500.h           |    3 +++
 include/linux/mfd/abx500/ab8500-bm.h |   22 ----------------------
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 871bf5a..432f6bc 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2998,7 +2998,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
 	di->ac_chg.wdt_refresh = CHG_WD_INTERVAL;
-	di->ac_chg.enabled = di->pdata->ac_enabled;
+	di->ac_chg.enabled = di->bm->ac_enabled;
 	di->ac_chg.external = false;
 
 	/* USB supply */
@@ -3019,7 +3019,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->usb_chg.max_out_curr = ab8500_charger_current_map[
 		ARRAY_SIZE(ab8500_charger_current_map) - 1];
 	di->usb_chg.wdt_refresh = CHG_WD_INTERVAL;
-	di->usb_chg.enabled = di->pdata->usb_enabled;
+	di->usb_chg.enabled = di->bm->usb_enabled;
 	di->usb_chg.external = false;
 
 	/* Create a work queue for the charger */
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 0e6e90b..1beaa05 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -254,6 +254,9 @@ struct abx500_bm_data {
 	int usb_safety_tmr_h;
 	int bkup_bat_v;
 	int bkup_bat_i;
+	bool autopower_cfg;
+	bool ac_enabled;
+	bool usb_enabled;
 	bool no_maintenance;
 	bool capacity_scaling;
 	bool chg_unknown_bat;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index b800332..802521a 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -404,28 +404,6 @@ struct ab8500_bm_data {
 	const struct ab8500_fg_parameters *fg_params;
 };
 
-struct ab8500_charger_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-	bool autopower_cfg;
-	bool ac_enabled;
-	bool usb_enabled;
-};
-
-struct ab8500_btemp_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-};
-
-struct ab8500_fg_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-};
-
-struct ab8500_chargalg_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-};
 struct ab8500_btemp;
 struct ab8500_gpadc;
 struct ab8500_fg;
-- 
1.7.9.5

