Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaAWPIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:08:44 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61672 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaAWPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:08:41 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/4] mfd: tps65217: Naturalise cross-architecture discrepancies
Date: Thu, 23 Jan 2014 15:05:56 +0000
Message-Id: <1390489556-9434-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390489556-9434-1-git-send-email-lee.jones@linaro.org>
References: <1390489556-9434-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we compile the TPS65217 for a 64bit architecture we receive the following
warnings:

drivers/mfd/tps65217.c: In function ‘tps65217_probe’:
drivers/mfd/tps65217.c:173:13:
  warning: cast from pointer to integer of different size
   chip_id = (unsigned int)match->data;
             ^

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tps65217.c       | 4 ++--
 include/linux/mfd/tps65217.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 6939ae5..3cc4c70 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -158,7 +158,7 @@ static int tps65217_probe(struct i2c_client *client,
 {
 	struct tps65217 *tps;
 	unsigned int version;
-	unsigned int chip_id = ids->driver_data;
+	unsigned long chip_id = ids->driver_data;
 	const struct of_device_id *match;
 	bool status_off = false;
 	int ret;
@@ -170,7 +170,7 @@ static int tps65217_probe(struct i2c_client *client,
 				"Failed to find matching dt id\n");
 			return -EINVAL;
 		}
-		chip_id = (unsigned int)match->data;
+		chip_id = (unsigned long)match->data;
 		status_off = of_property_read_bool(client->dev.of_node,
 					"ti,pmic-shutdown-controller");
 	}
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index a5a7f01..54b5458 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -252,7 +252,7 @@ struct tps65217_board {
 struct tps65217 {
 	struct device *dev;
 	struct tps65217_board *pdata;
-	unsigned int id;
+	unsigned long id;
 	struct regulator_desc desc[TPS65217_NUM_REGULATOR];
 	struct regulator_dev *rdev[TPS65217_NUM_REGULATOR];
 	struct regmap *regmap;
@@ -263,7 +263,7 @@ static inline struct tps65217 *dev_to_tps65217(struct device *dev)
 	return dev_get_drvdata(dev);
 }
 
-static inline int tps65217_chip_id(struct tps65217 *tps65217)
+static inline unsigned long tps65217_chip_id(struct tps65217 *tps65217)
 {
 	return tps65217->id;
 }
-- 
1.8.3.2

