Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3GTXIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:08:19 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:50028 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3GTXHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:49 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] power supply: tosa_battery: get rid of irq_to_gpio usage
Date: Sun, 21 Jul 2013 01:07:46 +0200
Message-Id: <1374361666-3154-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
linux/drivers/power/tosa_battery.c:153:2: error: implicit declaration of
function 'irq_to_gpio' [-Werror=implicit-function-declaration]
|   pr_info("tosa_bat_gpio irq: %d\n",
gpio_get_value(irq_to_gpio(irq)));

as done for collie_battery.c with
commit 629bcb4b72d49b3631ae3dd0fe1d345820fadfcc

Since 9d08d5d77a355510c2f5657c86b0a4b25acfe72c, irq_to_gpio() is no
longer available but still in use by collie_battery.c. As it's just
for a debug message, just get rid of this call.

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 drivers/power/tosa_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
index 0224de5..f4d80df 100644
--- a/drivers/power/tosa_battery.c
+++ b/drivers/power/tosa_battery.c
@@ -150,7 +150,7 @@ static void tosa_bat_external_power_changed(struct power_supply *psy)
 
 static irqreturn_t tosa_bat_gpio_isr(int irq, void *data)
 {
-	pr_info("tosa_bat_gpio irq: %d\n", gpio_get_value(irq_to_gpio(irq)));
+	pr_info("tosa_bat_gpio irq\n");
 	schedule_work(&bat_work);
 	return IRQ_HANDLED;
 }
-- 
1.8.1.5

