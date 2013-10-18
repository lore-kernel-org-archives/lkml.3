Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JSGTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:19:40 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11157 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750964Ab3JSGTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:19:38 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 07/29] PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
Date: Fri, 18 Oct 2013 19:12:07 +0200
Message-Id: <de85dc2f3aa27ff883504bd30d3f5f929145fe0d.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-by: Ben Hutchings <bhutchings@solarflare.com>
---
 include/linux/pci.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index d3a888a..5cfe54c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1148,13 +1148,13 @@ struct msix_entry {
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
@@ -1169,7 +1169,7 @@ static inline int pci_msix_table_size(struct pci_dev *dev)
 static inline int pci_enable_msix(struct pci_dev *dev,
 				  struct msix_entry *entries, int nvec)
 {
-	return -1;
+	return -ENOSYS;
 }
 
 static inline void pci_msix_shutdown(struct pci_dev *dev)
-- 
1.7.7.6

