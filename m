Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3A2JIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:08:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13911 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3A2JHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:07:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 29 Jan 2013 01:07:50 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 4/4] mfd: tps65090: remove suspend/resume callbacks
Date: Tue, 29 Jan 2013 14:35:18 +0530
Message-ID: <1359450318-24912-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
References: <1359450318-24912-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65090 mfd driver implement the suspend/resume callbacks
which just disable and enable irqs in suspend/resume respectively.

This operation is already done in irq suspend and irq_resume and
hence it is not require to implement the same in the driver.

Remove this non-require code.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- No change.

 drivers/mfd/tps65090.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 2ad0a15..98edb5b 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -230,28 +230,6 @@ static int tps65090_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int tps65090_suspend(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	if (client->irq)
-		disable_irq(client->irq);
-	return 0;
-}
-
-static int tps65090_resume(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	if (client->irq)
-		enable_irq(client->irq);
-	return 0;
-}
-#endif
-
-static const struct dev_pm_ops tps65090_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps65090_suspend, tps65090_resume)
-};
-
 static const struct i2c_device_id tps65090_id_table[] = {
 	{ "tps65090", 0 },
 	{ },
@@ -263,7 +241,6 @@ static struct i2c_driver tps65090_driver = {
 		.name	= "tps65090",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(tps65090_of_match),
-		.pm	= &tps65090_pm_ops,
 	},
 	.probe		= tps65090_i2c_probe,
 	.remove		= tps65090_i2c_remove,
-- 
1.7.1.1

