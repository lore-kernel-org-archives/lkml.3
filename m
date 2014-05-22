Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaEVJSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:18:51 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:43276 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaEVJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:18:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: abx500-core: Remove unused function abx500_dump_all_banks()
Date: Thu, 22 May 2014 10:18:29 +0100
Message-Id: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abx500_dump_all_banks() has no callers in the kernel, so it's probably
safe to remove it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/abx500-core.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index d6d0ec4..fe41899 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -151,26 +151,6 @@ int abx500_startup_irq_enabled(struct device *dev, unsigned int irq)
 }
 EXPORT_SYMBOL(abx500_startup_irq_enabled);
 
-int abx500_dump_all_banks(void)
-{
-	struct abx500_ops *ops;
-	struct device *dummy_child;
-	struct abx500_device_entry *dev_entry;
-
-	dummy_child = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!dummy_child)
-		return -ENOMEM;
-	list_for_each_entry(dev_entry, &abx500_list, list) {
-		dummy_child->parent = dev_entry->dev;
-		ops = &dev_entry->ops;
-
-		if ((ops != NULL) && (ops->dump_all_banks != NULL))
-			ops->dump_all_banks(dummy_child);
-	}
-	kfree(dummy_child);
-}
-EXPORT_SYMBOL(abx500_dump_all_banks);
-
 MODULE_AUTHOR("Mattias Wallin <mattias.wallin@stericsson.com>");
 MODULE_DESCRIPTION("ABX500 core driver");
 MODULE_LICENSE("GPL");
-- 
1.8.3.2

