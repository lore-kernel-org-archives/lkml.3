Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbaIKOOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:14:10 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:39393 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbaIKOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:14:09 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: sre@kernel.org, dbaryshkov@gmail.com, wmw2@infradead.org,
        santosh.shilimkar@ti.com, maxime.ripard@free-electrons.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] power: Make of_device_id array const
Date: Thu, 11 Sep 2014 19:41:43 +0530
Message-Id: <1410444703-27451-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/power/charger-manager.c         |    2 +-
 drivers/power/reset/hisi-reboot.c       |    2 +-
 drivers/power/reset/keystone-reset.c    |    2 +-
 drivers/power/reset/sun6i-reboot.c      |    2 +-
 drivers/power/reset/vexpress-poweroff.c |    2 +-
 drivers/power/reset/xgene-reboot.c      |    2 +-
 drivers/power/tps65090-charger.c        |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..eea4dad 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1529,7 +1529,7 @@ static int cm_init_thermal_data(struct charger_manager *cm)
 	return ret;
 }
 
-static struct of_device_id charger_manager_match[] = {
+static const struct of_device_id charger_manager_match[] = {
 	{
 		.compatible = "charger-manager",
 	},
diff --git a/drivers/power/reset/hisi-reboot.c b/drivers/power/reset/hisi-reboot.c
index 0c91d02..df2ad92 100644
--- a/drivers/power/reset/hisi-reboot.c
+++ b/drivers/power/reset/hisi-reboot.c
@@ -52,7 +52,7 @@ static int hisi_reboot_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id hisi_reboot_of_match[] = {
+static const struct of_device_id hisi_reboot_of_match[] = {
 	{ .compatible = "hisilicon,sysctrl" },
 	{}
 };
diff --git a/drivers/power/reset/keystone-reset.c b/drivers/power/reset/keystone-reset.c
index 408a18f..a8c22c3 100644
--- a/drivers/power/reset/keystone-reset.c
+++ b/drivers/power/reset/keystone-reset.c
@@ -62,7 +62,7 @@ static void rsctrl_restart(enum reboot_mode mode, const char *cmd)
 			   RSCTRL_RESET_MASK, 0);
 }
 
-static struct of_device_id rsctrl_of_match[] = {
+static const struct of_device_id rsctrl_of_match[] = {
 	{.compatible = "ti,keystone-reset", },
 	{},
 };
diff --git a/drivers/power/reset/sun6i-reboot.c b/drivers/power/reset/sun6i-reboot.c
index af2cd7f..b3b010f 100644
--- a/drivers/power/reset/sun6i-reboot.c
+++ b/drivers/power/reset/sun6i-reboot.c
@@ -70,7 +70,7 @@ static int sun6i_reboot_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id sun6i_reboot_of_match[] = {
+static const struct of_device_id sun6i_reboot_of_match[] = {
 	{ .compatible = "allwinner,sun6i-a31-wdt" },
 	{}
 };
diff --git a/drivers/power/reset/vexpress-poweroff.c b/drivers/power/reset/vexpress-poweroff.c
index 4dc102e2..c199d34 100644
--- a/drivers/power/reset/vexpress-poweroff.c
+++ b/drivers/power/reset/vexpress-poweroff.c
@@ -72,7 +72,7 @@ DEVICE_ATTR(active, S_IRUGO | S_IWUSR, vexpress_reset_active_show,
 
 enum vexpress_reset_func { FUNC_RESET, FUNC_SHUTDOWN, FUNC_REBOOT };
 
-static struct of_device_id vexpress_reset_of_match[] = {
+static const struct of_device_id vexpress_reset_of_match[] = {
 	{
 		.compatible = "arm,vexpress-reset",
 		.data = (void *)FUNC_RESET,
diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index ecd55f8..b5542bf 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -83,7 +83,7 @@ static int xgene_reboot_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id xgene_reboot_of_match[] = {
+static const struct of_device_id xgene_reboot_of_match[] = {
 	{ .compatible = "apm,xgene-reboot" },
 	{}
 };
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 3e8ba97..48e402f 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -344,7 +344,7 @@ static int tps65090_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id of_tps65090_charger_match[] = {
+static const struct of_device_id of_tps65090_charger_match[] = {
 	{ .compatible = "ti,tps65090-charger", },
 	{ /* end */ }
 };
-- 
1.7.9.5

