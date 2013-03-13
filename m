Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab3CMX2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934428Ab3CMX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 02/27] PCI: Add pci_dev_resource_idx() helper
Date: Wed, 13 Mar 2013 16:27:57 -0700
Message-Id: <1363217302-14383-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource pointer to get index in pci resources array/list.

-v2: export symbol for acpiphp compiling error, found by
       Steven Newbury <steve@snewbury.org.uk>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    9 +++++++++
 include/linux/pci.h |    1 +
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
index 00d5367..aefff8b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -339,6 +339,7 @@ struct pci_dev {
 };
 
 struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
+int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 {
-- 
1.7.10.4

