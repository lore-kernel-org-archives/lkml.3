Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaBSI60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:58:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbaBSI4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:40 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH 5/9] rsxx: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 09:58:17 +0100
Message-Id: <884e8e236ae1e7223230ee0de75f2f01817140cf.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Joshua Morris <josh.h.morris@us.ibm.com>
Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/rsxx/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2ee..76c8124 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -880,8 +880,8 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	spin_unlock_irq(&card->irq_lock);
 
 	if (!force_legacy) {
-		st = pci_enable_msi(dev);
-		if (st)
+		st = pci_enable_msi_range(dev, 1, 1);
+		if (st < 0)
 			dev_warn(CARD_TO_DEV(card),
 				"Failed to enable MSI\n");
 	}
-- 
1.7.7.6

