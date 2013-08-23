Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3HWKLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:11:31 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49559 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3HWKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:11:25 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 3/3] mfd: timberdale: Use module_pci_driver
Date: Fri, 23 Aug 2013 15:41:05 +0530
Message-Id: <1377252665-7152-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
References: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_pci_driver removes some boilerplate and makes the code
simple.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/timberdale.c |   29 +----------------------------
 1 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 57dd89d..a6755ec 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -868,34 +868,7 @@ static struct pci_driver timberdale_pci_driver = {
 	.remove = timb_remove,
 };
 
-static int __init timberdale_init(void)
-{
-	int err;
-
-	err = pci_register_driver(&timberdale_pci_driver);
-	if (err < 0) {
-		printk(KERN_ERR
-			"Failed to register PCI driver for %s device.\n",
-			timberdale_pci_driver.name);
-		return -ENODEV;
-	}
-
-	printk(KERN_INFO "Driver for %s has been successfully registered.\n",
-		timberdale_pci_driver.name);
-
-	return 0;
-}
-
-static void __exit timberdale_exit(void)
-{
-	pci_unregister_driver(&timberdale_pci_driver);
-
-	printk(KERN_INFO "Driver for %s has been successfully unregistered.\n",
-		timberdale_pci_driver.name);
-}
-
-module_init(timberdale_init);
-module_exit(timberdale_exit);
+module_pci_driver(timberdale_pci_driver);
 
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
 MODULE_VERSION(DRV_VERSION);
-- 
1.7.4.1

