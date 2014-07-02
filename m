Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaGBP3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:21 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:40155 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaGBP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/12] mfd: stmpe: Rid data size incompatibility warn when building for 64bit
Date: Wed,  2 Jul 2014 16:28:36 +0100
Message-Id: <1404314924-23564-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extinguishes:

../drivers/mfd/stmpe-i2c.c: In function ‘stmpe_i2c_probe’:
../drivers/mfd/stmpe-i2c.c:88:13:
	warning: cast from pointer to integer of different size
	partnum = (int)of_id->data;

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe-i2c.c | 4 ++--
 drivers/mfd/stmpe.c     | 2 +-
 drivers/mfd/stmpe.h     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index a45f9c0..5c05403 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -68,7 +68,7 @@ MODULE_DEVICE_TABLE(of, stmpe_of_match);
 static int
 stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 {
-	int partnum;
+	enum stmpe_partnum partnum;
 	const struct of_device_id *of_id;
 
 	i2c_ci.data = (void *)id;
@@ -85,7 +85,7 @@ stmpe_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		dev_info(&i2c->dev, "matching on node name, compatible is preferred\n");
 		partnum = id->driver_data;
 	} else
-		partnum = (int)of_id->data;
+		partnum = (enum stmpe_partnum)of_id->data;
 
 	return stmpe_probe(&i2c_ci, partnum);
 }
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3b6bfa7..02a17c3 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1147,7 +1147,7 @@ static void stmpe_of_probe(struct stmpe_platform_data *pdata,
 }
 
 /* Called from client specific probe routines */
-int stmpe_probe(struct stmpe_client_info *ci, int partnum)
+int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 {
 	struct stmpe_platform_data *pdata = dev_get_platdata(ci->dev);
 	struct device_node *np = ci->dev->of_node;
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 9e4d21d..2d045f2 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -97,7 +97,7 @@ struct stmpe_client_info {
 	void (*init)(struct stmpe *stmpe);
 };
 
-int stmpe_probe(struct stmpe_client_info *ci, int partnum);
+int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum);
 int stmpe_remove(struct stmpe *stmpe);
 
 #define STMPE_ICR_LSB_HIGH	(1 << 2)
-- 
1.8.3.2

