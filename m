Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3BZVyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:54:06 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:57801 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:54:04 -0500
From: maxin.john@gmail.com
To: jacmet@sunsite.dk
Cc: wsa@the-dreams.de, ben-linux@fluff.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH] i2c: busses: i2c-ocores: Fix PM-related warning
Date: Tue, 26 Feb 2013 23:53:45 +0200
Message-Id: <1361915625-24294-1-git-send-email-maxin.john@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

Fixes this warning:
  CC      drivers/i2c/busses/i2c-ocores.o
drivers/i2c/busses/i2c-ocores.c:460:12: warning: 'ocores_i2c_suspend'
 defined but not used [-Wunused-function]
drivers/i2c/busses/i2c-ocores.c:471:12: warning: 'ocores_i2c_resume'
defined but not used [-Wunused-function]

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/i2c/busses/i2c-ocores.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0e1f824..1ecea5e 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -456,7 +456,7 @@ static int ocores_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ocores_i2c_suspend(struct device *dev)
 {
 	struct ocores_i2c *i2c = dev_get_drvdata(dev);
@@ -476,12 +476,9 @@ static int ocores_i2c_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend, ocores_i2c_resume);
-#define OCORES_I2C_PM	(&ocores_i2c_pm)
-#else
-#define OCORES_I2C_PM	NULL
-#endif
 
 static struct platform_driver ocores_i2c_driver = {
 	.probe   = ocores_i2c_probe,
@@ -490,7 +487,7 @@ static struct platform_driver ocores_i2c_driver = {
 		.owner = THIS_MODULE,
 		.name = "ocores-i2c",
 		.of_match_table = ocores_i2c_match,
-		.pm = OCORES_I2C_PM,
+		.pm = &ocores_i2c_pm,
 	},
 };
 
-- 
1.7.7

