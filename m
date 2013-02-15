Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333Ab3BOMpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:52 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:45107 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161312Ab3BOMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/40] abx500-chargalg: Store the AB8500 MFD parent device for platform differentiation
Date: Fri, 15 Feb 2013 12:44:33 +0000
Message-Id: <1360932310-30065-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any platform can be dynamically probed for model and version number
provided the AB8500 MFD parent device pointer is available. This
patch obtains that pointer and stores it in a locally controlled
struct for later use.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index f043c08..31507bf 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -204,6 +204,7 @@ enum maxim_ret {
  * @batt_data:		data of the battery
  * @susp_status:	current charger suspension status
  * @bm:           	Platform specific battery management information
+ * @parent:		pointer to the struct abx500
  * @chargalg_psy:	structure that holds the battery properties exposed by
  *			the charging algorithm
  * @events:		structure for information about events triggered
@@ -227,6 +228,7 @@ struct abx500_chargalg {
 	struct abx500_chargalg_charger_info chg_info;
 	struct abx500_chargalg_battery_data batt_data;
 	struct abx500_chargalg_suspension_status susp_status;
+	struct ab8500 *parent;
 	struct abx500_bm_data *bm;
 	struct power_supply chargalg_psy;
 	struct ux500_charger *ac_chg;
@@ -1873,8 +1875,9 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* get device struct */
+	/* get device struct and parent */
 	di->dev = &pdev->dev;
+	di->parent = dev_get_drvdata(pdev->dev.parent);
 
 	/* chargalg supply */
 	di->chargalg_psy.name = "abx500_chargalg";
-- 
1.7.10.4

