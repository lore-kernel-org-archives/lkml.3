Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab3CDM41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:56:27 -0500
Received: from sestofw01.enea.se ([192.36.1.252]:20434 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757118Ab3CDM40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:56:26 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 07:56:25 EST
From: <maxin.john@enea.com>
To: <jacmet@sunsite.dk>
CC: <wsa@the-dreams.de>, <ben-linux@fluff.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        "Maxin B. John" <maxin.john@enea.com>
Subject: [PATCH v2] i2c: busses: i2c-ocores: Fix PM-related warning
Date: Mon, 4 Mar 2013 13:50:15 +0100
Message-ID: <1362401415-63119-1-git-send-email-maxin.john@enea.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maxin B. John" <maxin.john@enea.com>

The suspend/resume callbacks are unused w/o PM_SLEEP

Fixes this warning:
  CC      drivers/i2c/busses/i2c-ocores.o
drivers/i2c/busses/i2c-ocores.c:460:12: warning: 'ocores_i2c_suspend'
 defined but not used [-Wunused-function]
drivers/i2c/busses/i2c-ocores.c:471:12: warning: 'ocores_i2c_resume'
defined but not used [-Wunused-function]

Signed-off-by: Maxin B. John <maxin.john@enea.com>
---
 drivers/i2c/busses/i2c-ocores.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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
1.7.9.5

