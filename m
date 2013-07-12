Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3GLHKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:10:23 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63946 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3GLHKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:10:20 -0400
From: Vladimir Cernov <gg.kaspersky@gmail.com>
To: james.smart@emulex.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vladimir Cernov <gg.kaspersky@gmail.com>
Subject: [PATCH] [SCSI] lpfc 8.3.40: Remove useless cast
Date: Fri, 12 Jul 2013 10:10:09 +0300
Message-Id: <1373613009-8435-1-git-send-email-gg.kaspersky@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using coccinelle tool.
Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e0b20fa..b7621f6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4721,8 +4721,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
-- 
1.7.10.4

