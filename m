Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaHHFhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:37:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19194 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaHHFhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:37:12 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 1/4] PCI: introduce helper functions for device flag operation
Date: Fri,  8 Aug 2014 13:36:04 +0800
Message-Id: <1407476167-18935-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
References: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduced three helper functions to hide direct
device flag operation.

void pci_set_dev_assigned(struct pci_dev *pdev);
void pci_clear_dev_assigned(struct pci_dev *pdev);
bool pci_is_dev_assigned(struct pci_dev *pdev);

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 v2: simplify unnecessory ternary operation in function pci_is_dev_assigned();
 v3: amend helper functions naming.
---
 include/linux/pci.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 466bcd1..b610ab3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1829,4 +1829,17 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
  */
 struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
 
+/* helper functions for operation of device flag */
+static inline void pci_set_dev_assigned(struct pci_dev *pdev)
+{
+	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
+}
+static inline void pci_clear_dev_assigned(struct pci_dev *pdev)
+{
+	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+}
+static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
+{
+	return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED;
+}
 #endif /* LINUX_PCI_H */
-- 
1.7.1

