Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3IBL2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:28:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37352 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3IBL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:28:10 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, sachin.kamat@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] ab8500-charger: Check return value of regulator_enable
Date: Mon,  2 Sep 2013 16:40:22 +0530
Message-Id: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of regulator_enable to silence the following
type of warnings:
drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
of ‘regulator_enable’, declared with attribute warn_unused_result
[-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a4c4a10..fec0546 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1387,7 +1387,12 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 		 * the GPADC module independant of the AB8500 chargers
 		 */
 		if (!di->vddadc_en_ac) {
-			regulator_enable(di->regu);
+			ret = regulator_enable(di->regu);
+			if (ret) {
+				dev_err(di->dev,
+					"Failed to enable regulator\n");
+				return ret;
+			}
 			di->vddadc_en_ac = true;
 		}
 
@@ -1556,7 +1561,12 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 		 * the GPADC module independant of the AB8500 chargers
 		 */
 		if (!di->vddadc_en_usb) {
-			regulator_enable(di->regu);
+			ret = regulator_enable(di->regu);
+			if (ret) {
+				dev_err(di->dev,
+					"Failed to enable regulator\n");
+				return ret;
+			}
 			di->vddadc_en_usb = true;
 		}
 
-- 
1.7.9.5

