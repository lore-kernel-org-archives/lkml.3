Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3AKNNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:40 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43580 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3AKNNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:37 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/18] power: ab8500_btemp: Allign battery temperature resolution with the framework
Date: Fri, 11 Jan 2013 13:12:56 +0000
Message-Id: <1357909986-9262-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux Power Supply framework expects battery temperatures to have
a resolution of 0.1 degree Celsius; however, the AB8500 btemp driver
supplies a battery temperature resolution of 1 degree Celsius. We
therefore have to use a factor 10 on the measured values.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_btemp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index efeb6dd..3ad47b0 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -746,22 +746,22 @@ static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 	} else {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit;
+				temp = di->btemp_ranges.btemp_low_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit;
+				temp = di->btemp_ranges.btemp_high_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit;
+				temp = di->btemp_ranges.btemp_med_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit;
+				temp = di->btemp_ranges.btemp_med_limit * 10;
 			else
 				temp = di->bat_temp * 10;
 		} else
@@ -1030,8 +1030,8 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		ab8500_btemp_periodic_work);
 
 	/* Set BTEMP thermal limits. Low and Med are fixed */
-	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT;
-	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT;
+	di->btemp_ranges.btemp_low_limit = BTEMP_THERMAL_LOW_LIMIT * 10;
+	di->btemp_ranges.btemp_med_limit = BTEMP_THERMAL_MED_LIMIT * 10;
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_BTEMP_HIGH_TH, &val);
-- 
1.7.9.5

