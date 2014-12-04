Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaLDA5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:57:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63743 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751959AbaLDA5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:57:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH] power / PM: Eliminate CONFIG_PM_RUNTIME
Date: Thu, 04 Dec 2014 02:19:11 +0100
Message-ID: <2283612.6Ya1ZnvRTt@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME within #ifdef blocks depending on
CONFIG_PM may be dropped now.

Do that in drivers/power/pm2301_charger.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
PM_SLEEP is selected) which is only in linux-next at the moment (via the
linux-pm tree).

Please let me know if it is OK to take this one into linux-pm.

---
 drivers/power/pm2301_charger.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-pm/drivers/power/pm2301_charger.c
===================================================================
--- linux-pm.orig/drivers/power/pm2301_charger.c
+++ linux-pm/drivers/power/pm2301_charger.c
@@ -951,8 +951,6 @@ static int pm2xxx_wall_charger_suspend(s
 
 #endif
 
-#ifdef CONFIG_PM_RUNTIME
-
 static int  pm2xxx_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *pm2xxx_i2c_client = to_i2c_client(dev);
@@ -977,8 +975,6 @@ static int  pm2xxx_runtime_resume(struct
 	return 0;
 }
 
-#endif
-
 static const struct dev_pm_ops pm2xxx_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm2xxx_wall_charger_suspend,
 		pm2xxx_wall_charger_resume)

