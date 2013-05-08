Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3EHLSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:18:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42865 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3EHLSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:18:23 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        sundar.iyer@stericsson.com
Subject: [PATCH 1/1] regulator: dbx500: Make local symbol static
Date: Wed,  8 May 2013 16:35:10 +0530
Message-Id: <1368011110-4049-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_state_active_get is used only in this file. Make it static.
While at it also move this function definition inside the
CONFIG_REGULATOR_DEBUG macro as it is called only from within it.
This also avoids further build warning related to unused definition.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/dbx500-prcmu.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index 89bd2fa..ce89f78 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -24,18 +24,6 @@
 static int power_state_active_cnt; /* will initialize to zero */
 static DEFINE_SPINLOCK(power_state_active_lock);
 
-int power_state_active_get(void)
-{
-	unsigned long flags;
-	int cnt;
-
-	spin_lock_irqsave(&power_state_active_lock, flags);
-	cnt = power_state_active_cnt;
-	spin_unlock_irqrestore(&power_state_active_lock, flags);
-
-	return cnt;
-}
-
 void power_state_active_enable(void)
 {
 	unsigned long flags;
@@ -65,6 +53,18 @@ out:
 
 #ifdef CONFIG_REGULATOR_DEBUG
 
+static int power_state_active_get(void)
+{
+	unsigned long flags;
+	int cnt;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	cnt = power_state_active_cnt;
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+
+	return cnt;
+}
+
 static struct ux500_regulator_debug {
 	struct dentry *dir;
 	struct dentry *status_file;
-- 
1.7.9.5

