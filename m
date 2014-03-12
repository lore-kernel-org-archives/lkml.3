Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaCLVVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:21:12 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40182 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaCLVVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:21:10 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] Scsi: lpfc: lpfc_init: Remove useless casting value
Date: Wed, 12 Mar 2014 23:20:47 +0200
Message-Id: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless casting value returned by k[cmz]alloc
to (struct lpfc_sli_ring *).

Found using coccinelle

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 68c94cc..47d2c20 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4731,8 +4731,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
-- 
1.7.9.5

