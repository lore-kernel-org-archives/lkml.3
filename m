Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3KSFXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:23:50 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:29095
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab3KSFXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:23:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>, <bhelgaas@google.com>,
        <agraf@suse.de>, <scottwood@freescale.com>,
        <stuart.yoder@freescale.com>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 2/9 v2] pci: msi: expose msi region information functions
Date: Tue, 19 Nov 2013 10:47:06 +0530
Message-ID: <1384838233-24847-3-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So by now we have defined all the interfaces for getting the msi region,
this patch expose the interface to linux subsystem. These will be used by
vfio subsystem for setting up iommu for MSI interrupt of direct assignment
devices.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v1->v2
 - None

 include/linux/pci.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index da172f9..c587034 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1142,6 +1142,7 @@ struct msix_entry {
 	u16	entry;	/* driver uses to specify entry, OS writes */
 };
 
+struct msi_region;
 
 #ifndef CONFIG_PCI_MSI
 static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
@@ -1184,6 +1185,16 @@ static inline int pci_msi_enabled(void)
 {
 	return 0;
 }
+
+static inline int msi_get_region_count(void)
+{
+	return 0;
+}
+
+static inline int msi_get_region(int region_num, struct msi_region *region)
+{
+	return 0;
+}
 #else
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
 int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
@@ -1196,6 +1207,8 @@ void pci_disable_msix(struct pci_dev *dev);
 void msi_remove_pci_irq_vectors(struct pci_dev *dev);
 void pci_restore_msi_state(struct pci_dev *dev);
 int pci_msi_enabled(void);
+int msi_get_region_count(void);
+int msi_get_region(int region_num, struct msi_region *region);
 #endif
 
 #ifdef CONFIG_PCIEPORTBUS
-- 
1.7.0.4


