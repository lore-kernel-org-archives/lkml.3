Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3LPSmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:42:39 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:28503 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754939Ab3LPSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:42:36 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 5/9] PCI/MSI: Make pci_enable_msi/msix() 'nvec' argument type as int
Date: Mon, 16 Dec 2013 09:34:58 +0100
Message-Id: <e06648adc93d616db3e4a3541bdff0078e28d4a6.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_enable_msi_block(), pci_enable_msi_block_auto() and
pci_enable_msix() consistent with regard to the type of 'nvec'
argument.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 Documentation/PCI/MSI-HOWTO.txt |    2 +-
 drivers/pci/msi.c               |    4 ++--
 include/linux/pci.h             |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a091780..a4d174e 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -129,7 +129,7 @@ call to succeed.
 
 4.2.3 pci_enable_msi_block_auto
 
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *count)
+int pci_enable_msi_block_auto(struct pci_dev *dev, int *count)
 
 This variation on pci_enable_msi() call allows a device driver to request
 the maximum possible number of MSIs.  The MSI specification only allows
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 623322d..c0e2259 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -846,7 +846,7 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
  * updates the @dev's irq member to the lowest new interrupt number; the
  * other interrupt numbers allocated to this device are consecutive.
  */
-int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
+int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 {
 	int status, maxvec;
 	u16 msgctl;
@@ -877,7 +877,7 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
 {
 	int ret, nvec;
 	u16 msgctl;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 39493b7..8cf7b15 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1154,13 +1154,13 @@ struct msix_entry {
 
 
 #ifndef CONFIG_PCI_MSI
-static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
+static inline int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 {
 	return -ENOSYS;
 }
 
 static inline int
-pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec)
 {
 	return -ENOSYS;
 }
@@ -1195,8 +1195,8 @@ static inline int pci_msi_enabled(void)
 	return 0;
 }
 #else
-int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
+int pci_enable_msi_block(struct pci_dev *dev, int nvec);
+int pci_enable_msi_block_auto(struct pci_dev *dev, int *maxvec);
 void pci_msi_shutdown(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
 int pci_msix_table_size(struct pci_dev *dev);
-- 
1.7.7.6

