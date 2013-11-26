Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3KZUkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:40:04 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:52329 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452Ab3KZUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:40:01 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v3 06/11] PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
Date: Tue, 26 Nov 2013 10:09:55 +0100
Message-Id: <2606621e4b4286536eb3592bd03352bcf856ab48.1385399393.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1385399393.git.agordeev@redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-by: Ben Hutchings <bhutchings@solarflare.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 include/linux/pci.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 835ec7b..d5cc0d3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1157,13 +1157,13 @@ struct msix_entry {
 #ifndef CONFIG_PCI_MSI
 static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
-	return -1;
+	return -ENOSYS;
 }
 
 static inline int
 pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
 {
-	return -1;
+	return -ENOSYS;
 }
 
 static inline void pci_msi_shutdown(struct pci_dev *dev)
@@ -1178,7 +1178,7 @@ static inline int pci_msix_table_size(struct pci_dev *dev)
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int nvec)
 {
-	return -1;
+	return -ENOSYS;
 }
 
 static inline void pci_msix_shutdown(struct pci_dev *dev)
-- 
1.7.7.6

