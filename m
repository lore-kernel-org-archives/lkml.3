Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaIICXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:23:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbaIICXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:23:20 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH V4 1/4 resend] PCI: introduce helper functions for device flag operation
Date: Tue,  9 Sep 2014 10:21:25 +0800
Message-Id: <1410229288-31829-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
References: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
 v4: fix incorrect type in return expression warning.
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
+	return (pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED) == PCI_DEV_FLAGS_ASSIGNED;
+}
 #endif /* LINUX_PCI_H */
-- 
1.7.1

