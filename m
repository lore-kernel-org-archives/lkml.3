Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab3EWP3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:29:33 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39619 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3EWPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/16] mfd: abx500-core: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:07 +0100
Message-Id: <1369322717-30429-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/abx500-core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index 3714acb..f3a15aa 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -36,7 +36,9 @@ int abx500_register_ops(struct device *dev, struct abx500_ops *ops)
 {
 	struct abx500_device_entry *dev_entry;
 
-	dev_entry = kzalloc(sizeof(struct abx500_device_entry), GFP_KERNEL);
+	dev_entry = devm_kzalloc(dev,
+				 sizeof(struct abx500_device_entry),
+				 GFP_KERNEL);
 	if (!dev_entry) {
 		dev_err(dev, "register_ops kzalloc failed");
 		return -ENOMEM;
@@ -54,12 +56,8 @@ void abx500_remove_ops(struct device *dev)
 	struct abx500_device_entry *dev_entry, *tmp;
 
 	list_for_each_entry_safe(dev_entry, tmp, &abx500_list, list)
-	{
-		if (dev_entry->dev == dev) {
+		if (dev_entry->dev == dev)
 			list_del(&dev_entry->list);
-			kfree(dev_entry);
-		}
-	}
 }
 EXPORT_SYMBOL(abx500_remove_ops);
 
-- 
1.7.10.4

