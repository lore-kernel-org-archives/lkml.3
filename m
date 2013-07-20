Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3GTXIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:08:18 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56683 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3GTXHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:47 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] power supply: collie_battery: convert to use dev_pm_ops
Date: Sun, 21 Jul 2013 01:07:44 +0200
Message-Id: <1374361664-3124-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
linux/drivers/power/collie_battery.c:372:2: warning: initialization from
incompatible pointer type [enabled by default]
linux/drivers/power/collie_battery.c:372:2: warning: (near initialization
for 'collie_bat_driver.suspend') [enabled by default]

Referencess:
MFD: ucb1x00-core: convert to use dev_pm_ops
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/include/linux/mfd?id=5a09b7120a965a7d7e8494d0ed509135bbce0118

MFD: mcp-core: remove legacy driver suspend/resume methods
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/include/linux/mfd?id=cf4abfcc0df2985ff6061f74e63b8353f2a1d0bc

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 drivers/power/collie_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
index c58d0e3..d02ae02 100644
--- a/drivers/power/collie_battery.c
+++ b/drivers/power/collie_battery.c
@@ -287,7 +287,7 @@ static struct gpio collie_batt_gpios[] = {
 };
 
 #ifdef CONFIG_PM
-static int collie_bat_suspend(struct ucb1x00_dev *dev, pm_message_t state)
+static int collie_bat_suspend(struct ucb1x00_dev *dev)
 {
 	/* flush all pending status updates */
 	flush_work(&bat_work);
-- 
1.8.1.5

