Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425Ab3BOMqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:24 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44880 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707Ab3BOMqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:13 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Per Forlin <per.forlin@stericsson.com>,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/40] pm2301-charger: Force main charger detect
Date: Fri, 15 Feb 2013 12:44:41 +0000
Message-Id: <1360932310-30065-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@stericsson.com>

Force main charger detect in turn on status.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/pm2301_charger.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index e7eb63d..63f515e 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1067,6 +1067,8 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 		pm2xxx_reg_read(pm2, PM2XXX_REG_INT2, &val);
 		pm2xxx_reg_read(pm2, PM2XXX_REG_INT4, &val);
 		pm2->ac.charger_connected = 1;
+		ab8500_override_turn_on_stat(~AB8500_POW_KEY_1_ON,
+					     AB8500_MAIN_CH_DET);
 		pm2->ac_conn = true;
 		power_supply_changed(&pm2->ac_chg.psy);
 		sysfs_notify(&pm2->ac_chg.psy.dev->kobj, NULL, "present");
-- 
1.7.10.4

