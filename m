Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaLCVlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:41:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaLCVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:41:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 6/9] PCI: Expose pci_load_saved_state for public consumption.
Date: Wed,  3 Dec 2014 16:40:31 -0500
Message-Id: <1417642834-20350-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the pci_load_and_free_saved_state, and pci_store_saved_state
but are missing the functionality to just load the state
multiple times in the PCI device without having to free/save
the state.

This patch makes it possible to use this function.

CC: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/pci.c   | 5 +++--
 include/linux/pci.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 625a4ac..f00a9d6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1142,8 +1142,8 @@ EXPORT_SYMBOL_GPL(pci_store_saved_state);
  * @dev: PCI device that we're dealing with
  * @state: Saved state returned from pci_store_saved_state()
  */
-static int pci_load_saved_state(struct pci_dev *dev,
-				struct pci_saved_state *state)
+int pci_load_saved_state(struct pci_dev *dev,
+			 struct pci_saved_state *state)
 {
 	struct pci_cap_saved_data *cap;
 
@@ -1171,6 +1171,7 @@ static int pci_load_saved_state(struct pci_dev *dev,
 	dev->state_saved = true;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_load_saved_state);
 
 /**
  * pci_load_and_free_saved_state - Reload the save state pointed to by state,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5be8db4..08088cb1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1003,6 +1003,8 @@ void __iomem __must_check *pci_platform_rom(struct pci_dev *pdev, size_t *size);
 int pci_save_state(struct pci_dev *dev);
 void pci_restore_state(struct pci_dev *dev);
 struct pci_saved_state *pci_store_saved_state(struct pci_dev *dev);
+int pci_load_saved_state(struct pci_dev *dev,
+			 struct pci_saved_state *state);
 int pci_load_and_free_saved_state(struct pci_dev *dev,
 				  struct pci_saved_state **state);
 struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
-- 
1.9.3

