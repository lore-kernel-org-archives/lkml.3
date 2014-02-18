Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaBRMcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:32:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:65178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbaBRMcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:32:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="477007933"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: me: put pm callbacks under PM_SLEEP ifdef
Date: Tue, 18 Feb 2014 14:31:08 +0200
Message-Id: <1392726669-14724-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

This will eliminate compilation warning:

drivers/misc/mei/pci-me.c:303:12: warning: mei_me_pci_suspend defined but not used [-Wunused-function]
static int mei_me_pci_suspend(struct device *device)
drivers/misc/mei/pci-me.c:323:12: warning: mei_me_pci_resume defined but not used [-Wunused-function]
static int mei_me_pci_resume(struct device *device)

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 5434354..50d9cb5 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -269,7 +269,7 @@ static void mei_me_remove(struct pci_dev *pdev)
 
 
 }
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mei_me_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -329,11 +329,12 @@ static int mei_me_pci_resume(struct device *device)
 
 	return 0;
 }
+
 static SIMPLE_DEV_PM_OPS(mei_me_pm_ops, mei_me_pci_suspend, mei_me_pci_resume);
 #define MEI_ME_PM_OPS	(&mei_me_pm_ops)
 #else
 #define MEI_ME_PM_OPS	NULL
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 /*
  *  PCI driver structure
  */
-- 
1.8.5.3

