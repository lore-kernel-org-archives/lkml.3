Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab3DLWut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:50:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3DLWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:45:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 18/29] PCI: Use for_each_pci_resource() in pci resource release
Date: Fri, 12 Apr 2013 15:44:32 -0700
Message-Id: <1365806683-26717-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index cc875e6..af8ace9 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -6,15 +6,14 @@
 static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
  	msi_remove_pci_irq_vectors(dev);
 
 	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
+	for_each_pci_resource(dev, res, i, PCI_ALL_RES)
 		if (res->parent)
 			release_resource(res);
-	}
 }
 
 static void pci_stop_dev(struct pci_dev *dev)
-- 
1.8.1.4

