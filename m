Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaG2EHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 00:07:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22964 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaG2EH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 00:07:27 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 1/4 v3] PCI: introduce helper functions for device flag operation
Date: Tue, 29 Jul 2014 12:06:28 +0800
Message-Id: <1406606791-8834-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
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
 include/linux/pci.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index aab57b4..5f6f8fa 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1129,6 +1129,19 @@ resource_size_t pcibios_window_alignment(struct pci_bus *bus,
 
 int pci_set_vga_state(struct pci_dev *pdev, bool decode,
 		      unsigned int command_bits, u32 flags);
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
 /* kmem_cache style wrapper around pci_alloc_consistent() */
 
 #include <linux/pci-dma.h>
-- 
1.7.1

