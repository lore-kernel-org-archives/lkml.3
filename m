Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3BDPmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:42:17 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44571 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3BDPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:14 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: sameo@linux.intel.com, qingx@marvell.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: patches@linaro.org
Subject: [PATCH 3/6] mfd: max8925: fix onkey driver irq base
Date: Mon,  4 Feb 2013 23:40:44 +0800
Message-Id: <1359992448-22229-3-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
References: <1359992448-22229-1-git-send-email-haojian.zhuang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

update onkey driver's irq base, it should get from max8925,
but not save in a private value

Signed-off-by: Qing Xu <qingx@marvell.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/max8925_onkey.c |    3 ---
 drivers/mfd/max8925-core.c         |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
index 369a39d..f9179b2 100644
--- a/drivers/input/misc/max8925_onkey.c
+++ b/drivers/input/misc/max8925_onkey.c
@@ -100,9 +100,6 @@ static int max8925_onkey_probe(struct platform_device *pdev)
 	input->dev.parent = &pdev->dev;
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	irq[0] += chip->irq_base;
-	irq[1] += chip->irq_base;
-
 	error = request_threaded_irq(irq[0], NULL, max8925_onkey_handler,
 				     IRQF_ONESHOT, "onkey-down", info);
 	if (error < 0) {
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index d7abbb3..f0cc402 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -867,7 +867,7 @@ int max8925_device_init(struct max8925_chip *chip,
 
 	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
 			      ARRAY_SIZE(onkey_devs),
-			      NULL, 0, NULL);
+			      NULL, chip->irq_base, NULL);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to add onkey subdev\n");
 		goto out_dev;
-- 
1.7.10.4

