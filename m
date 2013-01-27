Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3A0I7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 03:59:36 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4461 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab3A0I7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:59:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 27 Jan 2013 00:59:08 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 4/4] mfd: tps65090: remove suspend/resume callbacks
Date: Sun, 27 Jan 2013 14:27:15 +0530
Message-ID: <1359277035-16854-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1359277035-16854-1-git-send-email-ldewangan@nvidia.com>
References: <1359277035-16854-1-git-send-email-ldewangan@nvidia.com>
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
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
This change is based on Mark Brown's comment when reviewing tps80031 mfd driver
as we do not need suspend/resume just for disabling/enabling interrupts.

Resending the patch wth Mark Acks.

 drivers/mfd/tps65090.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 3e987be..995e7b3 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -262,28 +262,6 @@ static int tps65090_i2c_remove(struct i2c_client *client)
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
@@ -295,7 +273,6 @@ static struct i2c_driver tps65090_driver = {
 		.name	= "tps65090",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(tps65090_of_match),
-		.pm	= &tps65090_pm_ops,
 	},
 	.probe		= tps65090_i2c_probe,
 	.remove		= tps65090_i2c_remove,
-- 
1.7.1.1

