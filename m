Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbaDHUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:42:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38784 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbaDHUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:42:35 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue,  8 Apr 2014 23:42:26 +0300
Message-Id: <1396989746-29647-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's easier to use kcalloc for allocating arrays. While at it
also remove useless casting value.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 635eeb3..1528f34 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4742,12 +4742,14 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
 	}
 
-	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
-			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
-	if (!phba->sli.ring)
-		return -ENOMEM;
+	if (unlikely(!phba->sli.ring)) {
+		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
+				sizeof(struct lpfc_sli_ring),
+				GFP_KERNEL);
+
+		if (!phba->sli.ring)
+			return -ENOMEM;
+	}
 
 	/*
 	 * Since lpfc_sg_seg_cnt is module parameter, the sg_dma_buf_size
-- 
1.9.1

