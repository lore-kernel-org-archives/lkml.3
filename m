Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3CWLA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:00:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab3CWLA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:00:26 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <dmitry.torokhov@gmail.com>, <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>,
        <u.kleine-koenig@pengutronix.de>, <rmk+kernel@arm.linux.org.uk>,
        <manishv.b@ti.com>
Subject: [PATCH] tps6507x-ts: update to devm_* API
Date: Sat, 23 Mar 2013 16:30:23 +0530
Message-ID: <1364036423-2057-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver
core will manage resources.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:100644 100644 820a066... 65e0f9a... M	drivers/input/touchscreen/tps6507x-ts.c
 drivers/input/touchscreen/tps6507x-ts.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 820a066..65e0f9a 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -261,7 +261,7 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 	init_data = tps_board->tps6507x_ts_init_data;
 
-	tsc = kzalloc(sizeof(struct tps6507x_ts), GFP_KERNEL);
+	tsc = devm_kzalloc(&pdev->dev, sizeof(struct tps6507x_ts), GFP_KERNEL);
 	if (!tsc) {
 		dev_err(tps6507x_dev->dev, "failed to allocate driver data\n");
 		error = -ENOMEM;
@@ -339,7 +339,6 @@ err2:
 	cancel_delayed_work_sync(&tsc->work);
 	input_free_device(input_dev);
 err1:
-	kfree(tsc);
 	tps6507x_dev->ts = NULL;
 err0:
 	return error;
@@ -356,7 +355,6 @@ static int tps6507x_ts_remove(struct platform_device *pdev)
 	input_unregister_device(input_dev);
 
 	tps6507x_dev->ts = NULL;
-	kfree(tsc);
 
 	return 0;
 }
-- 
1.7.4.1

