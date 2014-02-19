Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaBSI4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaBSI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:32 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com, linux-pci@vger.kernel.org
Subject: [PATCH 1/9] cciss: Fallback to MSI rather than to INTx if MSI-X failed
Date: Wed, 19 Feb 2014 09:58:13 +0100
Message-Id: <2b4fbd561d282fb3301e2a72d8ebce9f35a81514.1392799751.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-pci@vger.kernel.org
---
 drivers/block/cciss.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 036e8ab..fc5b0a4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4092,13 +4092,14 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 		if (err > 0) {
 			dev_warn(&h->pdev->dev,
 				"only %d MSI-X vectors available\n", err);
-			goto default_int_mode;
+			goto single_msi_mode;
 		} else {
 			dev_warn(&h->pdev->dev,
 				"MSI-X init failed %d\n", err);
-			goto default_int_mode;
+			goto single_msi_mode;
 		}
 	}
+single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
-- 
1.7.7.6

