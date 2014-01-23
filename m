Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaAWPIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:08:36 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:62946 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaAWPIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:08:34 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] mfd: max8997: Naturalise cross-architecture discrepancies
Date: Thu, 23 Jan 2014 15:05:53 +0000
Message-Id: <1390489556-9434-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we compile the MAX8997 for a 64bit architecture we receive the following
warnings:

  drivers/mfd/max8997.c: In function ‘max8997_i2c_get_driver_data’:
  drivers/mfd/max8997.c:173:10:
    warning: cast from pointer to integer of different size
     return (int)match->data;
            ^

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max8997.c               | 6 +++---
 include/linux/mfd/max8997-private.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index be88a3b..5adede0 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -164,15 +164,15 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
 	return pd;
 }
 
-static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
+static inline unsigned long max8997_i2c_get_driver_data(struct i2c_client *i2c,
 						const struct i2c_device_id *id)
 {
 	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (unsigned long)match->data;
 	}
-	return (int)id->driver_data;
+	return id->driver_data;
 }
 
 static int max8997_i2c_probe(struct i2c_client *i2c,
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index ad1ae7f..78c76cd 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -387,7 +387,7 @@ struct max8997_dev {
 	struct i2c_client *muic; /* slave addr 0x4a */
 	struct mutex iolock;
 
-	int type;
+	unsigned long type;
 	struct platform_device *battery; /* battery control (not fuel gauge) */
 
 	int irq;
-- 
1.8.3.2

