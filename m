Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960Ab3CMXdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:33:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964870Ab3CMX2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 17/27] PCI: Use for_each_pci_resource() in pci resource release
Date: Wed, 13 Mar 2013 16:28:12 -0700
Message-Id: <1363217302-14383-18-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    5 ++---
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
1.7.10.4

