Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3IJBYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:24:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:36287 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab3IJBYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,875,1371106800"; 
   d="scan'208";a="358160190"
Subject: [PATCH] PCI/PM: Removing the function pci_pm_complete()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: stern@rowland.harvard.edu, rjw@sisk.pl, bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Sep 2013 18:46:06 +0800
Message-ID: <1378809966.26153.23.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit(88d2613) removed the pm_runtime_put_sync() from pci_pm_complete()
to PM core code device_complete().

Here the pci_pm_complete() is doing the same work which can be done in
device_complete(), so we can remove it directly.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/pci/pci-driver.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 98f7b9b..736ef3f 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -599,18 +599,10 @@ static int pci_pm_prepare(struct device *dev)
 	return error;
 }
 
-static void pci_pm_complete(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-
-	if (drv && drv->pm && drv->pm->complete)
-		drv->pm->complete(dev);
-}
 
 #else /* !CONFIG_PM_SLEEP */
 
 #define pci_pm_prepare	NULL
-#define pci_pm_complete	NULL
 
 #endif /* !CONFIG_PM_SLEEP */
 
@@ -1123,7 +1115,6 @@ static int pci_pm_runtime_idle(struct device *dev)
 
 const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
-	.complete = pci_pm_complete,
 	.suspend = pci_pm_suspend,
 	.resume = pci_pm_resume,
 	.freeze = pci_pm_freeze,
-- 
1.7.0.4



