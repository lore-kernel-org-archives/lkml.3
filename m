Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaGVQT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:19:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaGVQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:19:57 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 1/4] PCI: introduce helper functions for device flag operation
Date: Wed, 23 Jul 2014 00:19:01 +0800
Message-Id: <1406045944-1587-2-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduced three helper functions to hide direct
device flag operation.

void pci_set_dev_assigned(struct pci_dev *pdev);
void pci_set_dev_deassigned(struct pci_dev *pdev);
bool pci_is_dev_assigned(struct pci_dev *pdev);

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
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
+static inline void pci_set_dev_deassigned(struct pci_dev *pdev)
+{
+	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
+}
+static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
+{
+	return pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED ? true : false;
+}
 /* kmem_cache style wrapper around pci_alloc_consistent() */
 
 #include <linux/pci-dma.h>
-- 
1.7.1

