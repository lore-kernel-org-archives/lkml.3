Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3JSGzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:55:00 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14325 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751027Ab3JSGy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:54:59 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 08/29] PCI/MSI: Make pci_enable_msix() 'nvec' argument unsigned int
Date: Fri, 18 Oct 2013 19:12:08 +0200
Message-Id: <93e145deeb238ad805196762cae696d3ae67f812.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_enable_msix() and pci_enable_msi_block() consistent
with regard to the type of 'nvec' argument. Indeed, a number
of vectors to allocate is a natural value, so make it unsigned.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |    3 ++-
 drivers/pci/msi.c               |    3 ++-
 include/linux/pci.h             |    5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a091780..845edb5 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -190,7 +190,8 @@ same number.
 
 4.3.1 pci_enable_msix
 
-int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
+int pci_enable_msix(struct pci_dev *dev,
+		    struct msix_entry *entries, unsigned int nvec)
 
 Calling this function asks the PCI subsystem to allocate 'nvec' MSIs.
 The 'entries' argument is a pointer to an array of msix_entry structs
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index bbe3d3d..fdae3a4 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -932,7 +932,8 @@ int pci_msix_table_size(struct pci_dev *dev)
  * of irqs or MSI-X vectors available. Driver should use the returned value to
  * re-send its request.
  **/
-int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
+int pci_enable_msix(struct pci_dev *dev,
+		    struct msix_entry *entries, unsigned int nvec)
 {
 	int status, nr_entries;
 	int i, j;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5cfe54c..d6832de 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1167,7 +1167,7 @@ static inline int pci_msix_table_size(struct pci_dev *dev)
 	return 0;
 }
 static inline int pci_enable_msix(struct pci_dev *dev,
-				  struct msix_entry *entries, int nvec)
+				  struct msix_entry *entries, int unsigned nvec)
 {
 	return -ENOSYS;
 }
@@ -1192,7 +1192,8 @@ int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
 int pci_msix_table_size(struct pci_dev *dev);
-int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec);
+int pci_enable_msix(struct pci_dev *dev,
+		    struct msix_entry *entries, unsigned int nvec);
 void pci_msix_shutdown(struct pci_dev *dev);
 void pci_disable_msix(struct pci_dev *dev);
 void msi_remove_pci_irq_vectors(struct pci_dev *dev);
-- 
1.7.7.6

