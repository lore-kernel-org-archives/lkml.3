Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3IMSyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:54:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58853 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3IMSyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:54:33 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 13 Sep 2013 19:54:05 +0100
Message-Id: <1379098445-22163-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379098445-22163-1-git-send-email-broonie@kernel.org>
References: <1379098445-22163-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] regulator: core: Remove unused regulator_use_dummy_regulator()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

No boards have used this functionality and the new default of providing
dummy regulators by default provides a better solution to the problem it
was trying to solve.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c          | 17 -----------------
 include/linux/regulator/machine.h |  5 -----
 2 files changed, 22 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c9740b5..b698e2b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -54,7 +54,6 @@ static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 static LIST_HEAD(regulator_ena_gpio_list);
 static bool has_full_constraints;
-static bool board_wants_dummy_regulator;
 
 static struct dentry *debugfs_root;
 
@@ -3432,22 +3431,6 @@ void regulator_has_full_constraints(void)
 EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
 
 /**
- * regulator_use_dummy_regulator - Provide a dummy regulator when none is found
- *
- * Calling this function will cause the regulator API to provide a
- * dummy regulator to consumers if no physical regulator is found,
- * allowing most consumers to proceed as though a regulator were
- * configured.  This allows systems such as those with software
- * controllable regulators for the CPU core only to be brought up more
- * readily.
- */
-void regulator_use_dummy_regulator(void)
-{
-	board_wants_dummy_regulator = true;
-}
-EXPORT_SYMBOL_GPL(regulator_use_dummy_regulator);
-
-/**
  * rdev_get_drvdata - get rdev regulator driver data
  * @rdev: regulator
  *
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 999b20c..a9f7c55 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -193,15 +193,10 @@ int regulator_suspend_finish(void);
 
 #ifdef CONFIG_REGULATOR
 void regulator_has_full_constraints(void);
-void regulator_use_dummy_regulator(void);
 #else
 static inline void regulator_has_full_constraints(void)
 {
 }
-
-static inline void regulator_use_dummy_regulator(void)
-{
-}
 #endif
 
 #endif
-- 
1.8.4.rc3

