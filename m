Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaBDGzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:55:44 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53708 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaBDGzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:55:35 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] drivers/mfd: fix pointer-integer size mismatch warnings
Date: Tue,  4 Feb 2014 15:42:23 +0900
Message-Id: <1391496143-6660-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the pointer-integer size mismatch warnings below:
	drivers/mfd/wm8994-core.c: In function ‘wm8994_i2c_probe’:
	mfd/wm8994-core.c:639:19: warning: cast from pointer to integer of
			different size [-Wpointer-to-int-cast]
	    wm8994->type = (int)of_id->data;
	                   ^
	drivers/mfd/max8997.c: In function ‘max8997_i2c_get_driver_data’:
	drivers/mfd/max8997.c:173:10: warning: cast from pointer to integer of
			different size [-Wpointer-to-int-cast]
	   return (int)match->data;
	          ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/mfd/max8997.c     | 2 +-
 drivers/mfd/wm8994-core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index be88a3b..768bcb1 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -170,7 +170,7 @@ static inline int max8997_i2c_get_driver_data(struct i2c_client *i2c,
 	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(max8997_pmic_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (int)(long)match->data;
 	}
 	return (int)id->driver_data;
 }
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index ba04f1b..1b25335 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -636,7 +636,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.of_node) {
 		of_id = of_match_device(wm8994_of_match, &i2c->dev);
 		if (of_id)
-			wm8994->type = (int)of_id->data;
+			wm8994->type = (int)(long)of_id->data;
 	} else {
 		wm8994->type = id->driver_data;
 	}
-- 
1.8.3.2

