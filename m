Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaBDLUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:20:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaBDLPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:15:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 11/22] lpfc: Remove superfluous call to pci_disable_msix()
Date: Tue,  4 Feb 2014 12:16:57 +0100
Message-Id: <6341596a5594023854c22f5ab6ad0a439d26d762.1391512266.git.agordeev@redhat.com>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 68c94cc..a9df97a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8078,7 +8078,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 	if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0420 PCI enable MSI-X failed (%d)\n", rc);
-		goto msi_fail_out;
+		goto vec_fail_out;
 	}
 	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -8156,6 +8156,8 @@ irq_fail_out:
 msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
 	pci_disable_msix(phba->pcidev);
+
+vec_fail_out:
 	return rc;
 }
 
@@ -8644,7 +8646,7 @@ enable_msix_vectors:
 	} else if (rc) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0484 PCI enable MSI-X failed (%d)\n", rc);
-		goto msi_fail_out;
+		goto vec_fail_out;
 	}
 
 	/* Log MSI-X vector assignment */
@@ -8696,9 +8698,10 @@ cfg_fail_out:
 			 &phba->sli4_hba.fcp_eq_hdl[index]);
 	}
 
-msi_fail_out:
 	/* Unconfigure MSI-X capability structure */
 	pci_disable_msix(phba->pcidev);
+
+vec_fail_out:
 	return rc;
 }
 
-- 
1.7.7.6

