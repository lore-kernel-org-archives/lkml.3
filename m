Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaBRMcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:32:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:65178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbaBRMcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:32:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="477007935"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 2/2] mei: txe: put pm callbacks under PM_SLEEP ifdef
Date: Tue, 18 Feb 2014 14:31:09 +0200
Message-Id: <1392726669-14724-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392726669-14724-1-git-send-email-tomas.winkler@intel.com>
References: <1392726669-14724-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI suspend resume callbacks should be defined
under CONFIG_PM_SLEEP

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/pci-txe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index af4412c..a5bf39a 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -209,7 +209,7 @@ static void mei_txe_remove(struct pci_dev *pdev)
 }
 
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mei_txe_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -273,7 +273,7 @@ static SIMPLE_DEV_PM_OPS(mei_txe_pm_ops,
 #define MEI_TXE_PM_OPS	(&mei_txe_pm_ops)
 #else
 #define MEI_TXE_PM_OPS	NULL
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 /*
  *  PCI driver structure
  */
-- 
1.8.5.3

