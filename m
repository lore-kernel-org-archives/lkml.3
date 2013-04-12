Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3DLWrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:47:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3DLWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:47:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 04/29] PCI: Add pci_dev_resource_idx() helper
Date: Fri, 12 Apr 2013 15:44:18 -0700
Message-Id: <1365806683-26717-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource pointer to get index in pci resources array/list.

-v2: export symbol for acpiphp compiling error, found by
       Steven Newbury <steve@snewbury.org.uk>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c | 9 +++++++++
 include/linux/pci.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9cb3eb3..1df75f7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -114,6 +114,15 @@ struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
 }
 EXPORT_SYMBOL(pci_dev_resource_n);
 
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
+{
+	if (res >= dev->resource &&
+	    res <= dev->resource + (PCI_NUM_RESOURCES - 1))
+		return res - dev->resource;
+
+	return -1;
+}
+
 static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 {
 	u64 size = mask & maxbase;	/* Find the significant bits */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6d450d2..f4da78d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -354,6 +354,7 @@ struct pci_dev {
 };
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
-- 
1.8.1.4

