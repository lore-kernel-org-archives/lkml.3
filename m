Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaEVLaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:30:16 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52805 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaEVLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:30:15 -0400
Date: Thu, 22 May 2014 12:30:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jay Aurabind <jay.aurabind@gmail.com>
Subject: [PATCH v2] mfd: abx500-core: Remove unused function
 abx500_dump_all_banks()
Message-ID: <20140522113010.GT6679@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abx500_dump_all_banks() has no callers in the kernel, so it's probably
safe to remove it.
    
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

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
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index df2508f..552cc1d 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -330,7 +330,6 @@ int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
 int abx500_get_chip_id(struct device *dev);
 int abx500_event_registers_startup_state_get(struct device *dev, u8 *event);
 int abx500_startup_irq_enabled(struct device *dev, unsigned int irq);
-int abx500_dump_all_banks(void);
 
 struct abx500_ops {
 	int (*get_chip_id) (struct device *);
