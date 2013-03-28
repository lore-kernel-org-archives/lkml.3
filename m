Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3C1AnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:43:13 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56548 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3C1AnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:43:12 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org, milo.kim@ti.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Cc: Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] power: pass IRQF_ONESHOT to request_threaded_irq()
Date: Thu, 28 Mar 2013 02:42:50 +0200
Message-Id: <1364431370-25029-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/power/ab8500_btemp.c     |    2 +-
 drivers/power/ab8500_charger.c   |    2 +-
 drivers/power/ab8500_fg.c        |    2 +-
 drivers/power/lp8788-charger.c   |    2 +-
 drivers/power/max17042_battery.c |    3 ++-
 drivers/power/max8903_charger.c  |   12 +++++++++---
 drivers/power/pm2301_charger.c   |    2 +-
 drivers/power/smb347-charger.c   |    3 ++-
 drivers/power/wm831x_power.c     |    8 +++++---
 9 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 0768906..31073cf 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1105,7 +1105,7 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(ab8500_btemp_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_btemp_irq[i].name);
 		ret = request_threaded_irq(irq, NULL, ab8500_btemp_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
 			ab8500_btemp_irq[i].name, di);
 
 		if (ret) {
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 24b30b7..db16765 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3366,7 +3366,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
 		ret = request_threaded_irq(irq, NULL, ab8500_charger_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
 			ab8500_charger_irq[i].name, di);
 
 		if (ret != 0) {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 25dae4c..5d5cbb4 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2749,7 +2749,7 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(ab8500_fg_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_fg_irq[i].name);
 		ret = request_threaded_irq(irq, NULL, ab8500_fg_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
 			ab8500_fg_irq[i].name, di);
 
 		if (ret != 0) {
diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 6d1f452..1ac1a76 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -519,7 +519,7 @@ static int lp8788_set_irqs(struct platform_device *pdev,
 
 		ret = request_threaded_irq(virq, NULL,
 					lp8788_charger_irq_thread,
-					0, name, pchg);
+					IRQF_ONESHOT, name, pchg);
 		if (ret)
 			break;
 	}
diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d664ef5..b3cdd6d 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -751,7 +751,8 @@ static int max17042_probe(struct i2c_client *client,
 	if (client->irq) {
 		ret = request_threaded_irq(client->irq, NULL,
 						max17042_thread_handler,
-						IRQF_TRIGGER_FALLING,
+						IRQF_TRIGGER_FALLING
+						| IRQF_ONESHOT,
 						chip->battery.name, chip);
 		if (!ret) {
 			reg =  max17042_read_reg(client, MAX17042_CONFIG);
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 14e2b96..5ed2be0 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -297,7 +297,9 @@ static int max8903_probe(struct platform_device *pdev)
 	if (pdata->dc_valid) {
 		ret = request_threaded_irq(gpio_to_irq(pdata->dok),
 				NULL, max8903_dcin,
-				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_FALLING
+				| IRQF_TRIGGER_RISING
+				| IRQF_ONESHOT,
 				"MAX8903 DC IN", data);
 		if (ret) {
 			dev_err(dev, "Cannot request irq %d for DC (%d)\n",
@@ -309,7 +311,9 @@ static int max8903_probe(struct platform_device *pdev)
 	if (pdata->usb_valid) {
 		ret = request_threaded_irq(gpio_to_irq(pdata->uok),
 				NULL, max8903_usbin,
-				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_FALLING
+				| IRQF_TRIGGER_RISING
+				| IRQF_ONESHOT,
 				"MAX8903 USB IN", data);
 		if (ret) {
 			dev_err(dev, "Cannot request irq %d for USB (%d)\n",
@@ -321,7 +325,9 @@ static int max8903_probe(struct platform_device *pdev)
 	if (pdata->flt) {
 		ret = request_threaded_irq(gpio_to_irq(pdata->flt),
 				NULL, max8903_fault,
-				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_FALLING
+				| IRQF_TRIGGER_RISING
+				| IRQF_ONESHOT,
 				"MAX8903 Fault", data);
 		if (ret) {
 			dev_err(dev, "Cannot request irq %d for Fault (%d)\n",
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ed48d75..c62f7a0 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -967,7 +967,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	/* Register interrupts */
 	ret = request_threaded_irq(pm2->pdata->irq_number, NULL,
 				pm2xxx_charger_irq[0].isr,
-				pm2->pdata->irq_type,
+				pm2->pdata->irq_type | IRQF_ONESHOT,
 				pm2xxx_charger_irq[0].name, pm2);
 
 	if (ret != 0) {
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index acf84e8..e9702de 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -842,7 +842,8 @@ static int smb347_irq_init(struct smb347_charger *smb,
 		goto fail;
 
 	ret = request_threaded_irq(irq, NULL, smb347_interrupt,
-				   IRQF_TRIGGER_FALLING, client->name, smb);
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   client->name, smb);
 	if (ret < 0)
 		goto fail_gpio;
 
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 3bed2f5..2277f7b 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -567,7 +567,8 @@ static int wm831x_power_probe(struct platform_device *pdev)
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "SYSLO"));
 	ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq,
-				   IRQF_TRIGGER_RISING, "System power low",
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				   "System power low",
 				   power);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request SYSLO IRQ %d: %d\n",
@@ -577,7 +578,8 @@ static int wm831x_power_probe(struct platform_device *pdev)
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "PWR SRC"));
 	ret = request_threaded_irq(irq, NULL, wm831x_pwr_src_irq,
-				   IRQF_TRIGGER_RISING, "Power source",
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				   "Power source",
 				   power);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request PWR SRC IRQ %d: %d\n",
@@ -590,7 +592,7 @@ static int wm831x_power_probe(struct platform_device *pdev)
 				 platform_get_irq_byname(pdev,
 							 wm831x_bat_irqs[i]));
 		ret = request_threaded_irq(irq, NULL, wm831x_bat_irq,
-					   IRQF_TRIGGER_RISING,
+					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 					   wm831x_bat_irqs[i],
 					   power);
 		if (ret != 0) {
-- 
1.7.9.5

