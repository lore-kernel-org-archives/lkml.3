Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaGVLN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:13:27 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53007 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaGVLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:12:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/19] mfd: tc6387xb: Remove unnecessary braces and correct style warnings
Date: Tue, 22 Jul 2014 12:11:21 +0100
Message-Id: <1406027485-15657-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: braces {} are not necessary for single statement blocks
+       if (!iomem) {
+               return -EINVAL;
+       }

WARNING: sizeof *tc6387xb should be sizeof(*tc6387xb)
+       tc6387xb = kzalloc(sizeof *tc6387xb, GFP_KERNEL);

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
+       printk(KERN_INFO "Toshiba tc6387xb initialised\n");

total: 0 errors, 3 warnings, 242 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tc6387xb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 591a331..e71f880 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -147,11 +147,10 @@ static int tc6387xb_probe(struct platform_device *dev)
 	int irq, ret;
 
 	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!iomem) {
+	if (!iomem)
 		return -EINVAL;
-	}
 
-	tc6387xb = kzalloc(sizeof *tc6387xb, GFP_KERNEL);
+	tc6387xb = kzalloc(sizeof(*tc6387xb), GFP_KERNEL);
 	if (!tc6387xb)
 		return -ENOMEM;
 
@@ -189,7 +188,7 @@ static int tc6387xb_probe(struct platform_device *dev)
 	if (pdata && pdata->enable)
 		pdata->enable(dev);
 
-	printk(KERN_INFO "Toshiba tc6387xb initialised\n");
+	dev_info(&dev->dev, "Toshiba tc6387xb initialised\n");
 
 	ret = mfd_add_devices(&dev->dev, dev->id, tc6387xb_cells,
 			      ARRAY_SIZE(tc6387xb_cells), iomem, irq, NULL);
-- 
1.8.3.2

