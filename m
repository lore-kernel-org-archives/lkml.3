Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaAFPq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:46:28 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56701 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaAFPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:46:27 -0500
From: Jesper Falk <jesperfalk94@gmail.com>
To: anton@enomsg.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Jesper Falk <jesperfalk94@gmail.com>
Subject: [PATCH] Power: charger-manager: Fixed coding style
Date: Mon,  6 Jan 2014 16:46:15 +0100
Message-Id: <1389023175-11872-1-git-send-email-jesperfalk94@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed apaces before semicolon and fixed brackets on if statements

Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
---
 drivers/power/charger-manager.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 7287c0e..4c5a848 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -327,7 +327,7 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		cm->charging_start_time = ktime_to_ms(ktime_get());
 		cm->charging_end_time = 0;
 
-		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		for (i = 0; i < desc->num_charger_regulators; i++) {
 			if (desc->charger_regulators[i].externally_control)
 				continue;
 
@@ -345,7 +345,7 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 		cm->charging_start_time = 0;
 		cm->charging_end_time = ktime_to_ms(ktime_get());
 
-		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+		for (i = 0; i < desc->num_charger_regulators; i++) {
 			if (desc->charger_regulators[i].externally_control)
 				continue;
 
@@ -1476,20 +1476,17 @@ static int charger_manager_probe(struct platform_device *pdev)
 	 * The following two do not need to be errors.
 	 * Users may intentionally ignore those two features.
 	 */
-	if (desc->fullbatt_uV == 0) {
+	if (desc->fullbatt_uV == 0)
 		dev_info(&pdev->dev, "Ignoring full-battery voltage threshold as it is not supplied\n");
-	}
 	if (!desc->fullbatt_vchkdrop_ms || !desc->fullbatt_vchkdrop_uV) {
 		dev_info(&pdev->dev, "Disabling full-battery voltage drop checking mechanism as it is not supplied\n");
 		desc->fullbatt_vchkdrop_ms = 0;
 		desc->fullbatt_vchkdrop_uV = 0;
 	}
-	if (desc->fullbatt_soc == 0) {
+	if (desc->fullbatt_soc == 0)
 		dev_info(&pdev->dev, "Ignoring full-battery soc(state of charge) threshold as it is not supplied\n");
-	}
-	if (desc->fullbatt_full_capacity == 0) {
+	if (desc->fullbatt_full_capacity == 0)
 		dev_info(&pdev->dev, "Ignoring full-battery full capacity threshold as it is not supplied\n");
-	}
 
 	if (!desc->charger_regulators || desc->num_charger_regulators < 1) {
 		dev_err(&pdev->dev, "charger_regulators undefined\n");
@@ -1676,16 +1673,16 @@ static int charger_manager_remove(struct platform_device *pdev)
 	cancel_work_sync(&setup_polling);
 	cancel_delayed_work_sync(&cm_monitor_work);
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+	for (i = 0; i < desc->num_charger_regulators; i++) {
 		struct charger_regulator *charger
 				= &desc->charger_regulators[i];
-		for (j = 0 ; j < charger->num_cables ; j++) {
+		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 			extcon_unregister_interest(&cable->extcon_dev);
 		}
 	}
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+	for (i = 0; i < desc->num_charger_regulators; i++)
 		regulator_put(desc->charger_regulators[i].consumer);
 
 	power_supply_unregister(&cm->charger_psy);
-- 
1.8.5.2

