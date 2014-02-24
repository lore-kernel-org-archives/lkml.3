Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBXIAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:00:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBXIAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:00:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 03/23] bfa: Cleanup bfad_setup_intr() function
Date: Mon, 24 Feb 2014 09:02:03 +0100
Message-Id: <c3fb3d552113a7c180741cf9f577081fc690366f.1393191330.git.agordeev@redhat.com>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 972ff8d..e7e4774 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1219,7 +1219,7 @@ bfad_install_msix_handler(struct bfad_s *bfad)
 int
 bfad_setup_intr(struct bfad_s *bfad)
 {
-	int error = 0;
+	int error;
 	u32 mask = 0, i, num_bit = 0, max_bit = 0;
 	struct msix_entry msix_entries[MAX_MSIX_ENTRY];
 	struct pci_dev *pdev = bfad->pcidev;
@@ -1279,20 +1279,18 @@ bfad_setup_intr(struct bfad_s *bfad)
 
 		bfad->bfad_flags |= BFAD_MSIX_ON;
 
-		return error;
+		return 0;
 	}
 
 line_based:
-	error = 0;
-	if (request_irq
-	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, BFAD_IRQ_FLAGS,
-	     BFAD_DRIVER_NAME, bfad) != 0) {
-		/* Enable interrupt handler failed */
-		return 1;
-	}
+	error = request_irq(bfad->pcidev->irq, (irq_handler_t)bfad_intx,
+			    BFAD_IRQ_FLAGS, BFAD_DRIVER_NAME, bfad);
+	if (error)
+		return error;
+
 	bfad->bfad_flags |= BFAD_INTX_ON;
 
-	return error;
+	return 0;
 }
 
 void
-- 
1.7.7.6

