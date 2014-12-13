Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaLMBQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:16:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65161 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932591AbaLMBP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:15:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [Resend][PATCH] power / PM: Eliminate CONFIG_PM_RUNTIME
Date: Sat, 13 Dec 2014 02:37:38 +0100
Message-ID: <2140907.kiDBIytxHB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2283612.6Ya1ZnvRTt@vostro.rjw.lan>
References: <2283612.6Ya1ZnvRTt@vostro.rjw.lan>
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

Please let me know if there are any objections against this.  If not, I'll
take it through the linux-pm tree, as I'm going to remove CONFIG_PM_RUNTIME
entirely shortly.

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

