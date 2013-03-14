Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3CNKaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:30:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59779 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3CNKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:30:38 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, anton.vorontsov@linaro.org, cbou@mail.ru,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] sbs-battery: Use of_match_ptr() macro
Date: Thu, 14 Mar 2013 15:49:46 +0530
Message-Id: <1363256386-28552-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates having an #ifdef returning NULL for the case
when OF is disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/sbs-battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 3960f0b..3922f06 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 
 #include <linux/power/sbs-battery.h>
 
@@ -667,7 +668,6 @@ of_out:
 	return pdata;
 }
 #else
-#define sbs_dt_ids NULL
 static struct sbs_platform_data *sbs_of_populate_pdata(
 	struct i2c_client *client)
 {
@@ -859,7 +859,7 @@ static struct i2c_driver sbs_battery_driver = {
 	.id_table	= sbs_id,
 	.driver = {
 		.name	= "sbs-battery",
-		.of_match_table = sbs_dt_ids,
+		.of_match_table = of_match_ptr(sbs_dt_ids),
 	},
 };
 module_i2c_driver(sbs_battery_driver);
-- 
1.7.4.1

