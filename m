Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3LPMFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:05:53 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39997 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LPMFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:05:52 -0500
From: Laszlo Papp <lpapp@kde.org>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] mfd: (max8997) Handle the potential error for mfd_add_devices
Date: Mon, 16 Dec 2013 12:01:11 +0000
Message-Id: <1387195271-2832-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/mfd/max8997.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 791aea3..c7cc235 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -227,19 +227,19 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	pm_runtime_set_active(max8997->dev);
 
 	max8997_irq_init(max8997);
-
-	mfd_add_devices(max8997->dev, -1, max8997_devs,
+	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
 			ARRAY_SIZE(max8997_devs),
 			NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(dev, "cannot add mfd cells\n");
+		goto err_mfd;
+	}
 
 	/*
 	 * TODO: enable others (flash, muic, rtc, battery, ...) and
 	 * check the return value
 	 */
 
-	if (ret < 0)
-		goto err_mfd;
-
 	/* MAX8997 has a power button input. */
 	device_init_wakeup(max8997->dev, pdata->wakeup);
 
-- 
1.8.5.1

