Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161647Ab3BOMso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:48:44 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65278 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161544Ab3BOMrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:47:01 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/40] ab8500-charger: Remove duplicate code
Date: Fri, 15 Feb 2013 12:45:02 +0000
Message-Id: <1360932310-30065-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |    8 --------
 drivers/power/ab8500_fg.c      |    1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 8530028..81c9615 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3184,14 +3184,6 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		goto out;
 	}
 
-	/* Set charger watchdog timeout */
-	ret = abx500_set_register_interruptible(di->dev, AB8500_CHARGER,
-		AB8500_CH_WD_TIMER_REG, WD_TIMER);
-	if (ret) {
-		dev_err(di->dev, "failed to set charger watchdog timeout\n");
-		goto out;
-	}
-
 	ret = ab8500_charger_led_en(di, false);
 	if (ret < 0) {
 		dev_err(di->dev, "failed to disable LED\n");
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index f596883..54c6417 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1680,7 +1680,6 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 		break;
 
 	case AB8500_FG_DISCHARGE_WAKEUP:
-		ab8500_fg_coulomb_counter(di, true);
 		ab8500_fg_calc_cap_discharge_voltage(di, true);
 
 		di->fg_samples = SEC_TO_SAMPLE(
-- 
1.7.10.4

