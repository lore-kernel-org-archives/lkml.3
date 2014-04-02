Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbaDBLvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382AbaDBLvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:51:14 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()
Date: Wed,  2 Apr 2014 13:52:56 +0200
Message-Id: <1396439576-10263-1-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/genwqe/card_utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 6b1a6ef..294f667 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -628,7 +628,7 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
 	int rc;
 	struct pci_dev *pci_dev = cd->pci_dev;
 
-	rc = pci_enable_msi_block(pci_dev, count);
+	rc = pci_enable_msi_exact(pci_dev, count);
 	if (rc == 0)
 		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
 	return rc;
-- 
1.7.7.6

