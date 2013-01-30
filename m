Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3A3L2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:28:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3A3L2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:28:19 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH] power/reset: Remove newly introduced __dev* annotations
Date: Wed, 30 Jan 2013 12:28:13 +0100
Message-Id: <1359545293-14721-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:kL4v1W4J9xpSNeRjGtiZSjbW+e+XRqs3o1OnBQk3Nin
 UdLy0tiv+ZF9EQxUD3yMa87F6MgWbY4dOnvLW4vc7Dk+O4S8o/
 VmZh5OHXIb5BcSOsMpP5ES1O0z/QQJxyWVSDnUkjOom9mX2E2B
 Kr+VnQpksQtvt2SVO1lJ+e2r/Z5cpON9CRxPnNr9yOF8azfpip
 gMEOudWwlWG06jE1XWhGoPXw6b7FwN6IcHr8hUkBpsi+8rHqO9
 /OBBk+8tBrQrQMHKBCJq2kLTsrIrNGcFnK4y9ZZYUwX2Q30QMD
 XuZtZCIZuQX4DGU8+dIt80j1NfjI4OTYavSyMYeTZQyX1POydH
 gORdq22HUveEzfAU7b/6IKvSbdNkqyb+SoGz/vClx2YPeSi8OU
 GYJz/6AvkX5Ox60whE9w3lz8iyUAOs/x4nqrZpHn/Cpn7vmvde
 Z9wFy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__devinit, __devexit and __devexit_p have recently been removed and
should no longer be used.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/power/reset/restart-poweroff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index b11b9e8..059cd15 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -22,7 +22,7 @@ static void restart_poweroff_do_poweroff(void)
 	arm_pm_restart('h', NULL);
 }
 
-static int __devinit restart_poweroff_probe(struct platform_device *pdev)
+static int restart_poweroff_probe(struct platform_device *pdev)
 {
 	/* If a pm_power_off function has already been added, leave it alone */
 	if (pm_power_off != NULL) {
@@ -35,7 +35,7 @@ static int __devinit restart_poweroff_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit restart_poweroff_remove(struct platform_device *pdev)
+static int restart_poweroff_remove(struct platform_device *pdev)
 {
 	if (pm_power_off == &restart_poweroff_do_poweroff)
 		pm_power_off = NULL;
@@ -50,7 +50,7 @@ static const struct of_device_id of_restart_poweroff_match[] = {
 
 static struct platform_driver restart_poweroff_driver = {
 	.probe = restart_poweroff_probe,
-	.remove = __devexit_p(restart_poweroff_remove),
+	.remove = restart_poweroff_remove,
 	.driver = {
 		.name = "poweroff-restart",
 		.owner = THIS_MODULE,
-- 
1.8.1.2

