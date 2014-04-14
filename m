Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaDNHMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaDNHMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:12:31 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/2] GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()
Date: Mon, 14 Apr 2014 09:14:06 +0200
Message-Id: <6e4ebc84c90c5f8e49a931e915ec373576ad416a.1397458024.git.agordeev@redhat.com>
In-Reply-To: <cover.1397458024.git.agordeev@redhat.com>
References: <cover.1397458024.git.agordeev@redhat.com>
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
Cc: linux-pci@vger.kernel.org
Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
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

