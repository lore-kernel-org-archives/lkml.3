Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3CJNdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:33:20 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1090 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CJNcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:32:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5425
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/5] power: pm2301_charger: Remove no-op suspend/resume callbacks
Date: Sun, 10 Mar 2013 14:34:09 +0100
Message-Id: <1362922449-27531-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362922449-27531-1-git-send-email-lars@metafoo.de>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having suspend/resume callbacks which do nothing other then return 0 are
functional equivalent to having no suspend/resume callbacks. So just remove
these no-op suspend/resume callbacks.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/pm2301_charger.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ca424b8..e8aaa9d 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -840,17 +840,6 @@ static struct pm2xxx_irq pm2xxx_charger_irq[] = {
 	{"PM2XXX_IRQ_INT", pm2xxx_irq_int},
 };
 
-static int pm2xxx_wall_charger_resume(struct i2c_client *i2c_client)
-{
-	return 0;
-}
-
-static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
-	pm_message_t state)
-{
-	return 0;
-}
-
 static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		const struct i2c_device_id *id)
 {
@@ -1059,8 +1048,6 @@ MODULE_DEVICE_TABLE(i2c, pm2xxx_id);
 static struct i2c_driver pm2xxx_charger_driver = {
 	.probe = pm2xxx_wall_charger_probe,
 	.remove = pm2xxx_wall_charger_remove,
-	.suspend = pm2xxx_wall_charger_suspend,
-	.resume = pm2xxx_wall_charger_resume,
 	.driver = {
 		.name = "pm2xxx-wall_charger",
 		.owner = THIS_MODULE,
-- 
1.8.0

