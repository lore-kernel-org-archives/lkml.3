Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3CJNdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:33:22 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1087 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3CJNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:32:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5425
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/5] power: pm2301_charger: Remove __dev* annotations
Date: Sun, 10 Mar 2013 14:34:08 +0100
Message-Id: <1362922449-27531-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362922449-27531-1-git-send-email-lars@metafoo.de>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of __devinit and friends seems to have overlapped with the addition
of the pm2301_charger driver. Currently the driver fails to build with the
following errors:

	drivers/power/pm2301_charger.c:843:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pm2xxx_wall_charger_probe'
	drivers/power/pm2301_charger.c:1013:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'pm2xxx_wall_charger_remove'
	drivers/power/pm2301_charger.c:1049:11: error: 'pm2xxx_wall_charger_probe' undeclared here (not in a function)
	drivers/power/pm2301_charger.c:1050:2: error: implicit declaration of function '__devexit_p'
	drivers/power/pm2301_charger.c:1050:24: error: 'pm2xxx_wall_charger_remove' undeclared here (not in a function)

This patch removes the __dev* annotations, which fixes the build errors.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/pm2301_charger.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ed48d75..ca424b8 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -851,7 +851,7 @@ static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
 	return 0;
 }
 
-static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
+static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		const struct i2c_device_id *id)
 {
 	struct pm2xxx_platform_data *pl_data = i2c_client->dev.platform_data;
@@ -1021,7 +1021,7 @@ free_device_info:
 	return ret;
 }
 
-static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
+static int pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
 {
 	struct pm2xxx_charger *pm2 = i2c_get_clientdata(i2c_client);
 
@@ -1058,7 +1058,7 @@ MODULE_DEVICE_TABLE(i2c, pm2xxx_id);
 
 static struct i2c_driver pm2xxx_charger_driver = {
 	.probe = pm2xxx_wall_charger_probe,
-	.remove = __devexit_p(pm2xxx_wall_charger_remove),
+	.remove = pm2xxx_wall_charger_remove,
 	.suspend = pm2xxx_wall_charger_suspend,
 	.resume = pm2xxx_wall_charger_resume,
 	.driver = {
-- 
1.8.0

