Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbaLWR5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:57:10 -0500
Received: from www.osadl.org ([62.245.132.105]:33770 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaLWR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:57:08 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: James Smart <james.smart@emulex.com>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] scsi: incorrect use of init_completion fixup
Date: Tue, 23 Dec 2014 18:49:24 +0100
Message-Id: <1419356964-22793-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second init_completion call should be a reinit_completion here.

patch is against 3.18.0 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/lpfc/lpfc_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 2f9b968..7f42807 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -725,7 +725,7 @@ lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 		}
 	}

-	init_completion(&online_compl);
+	reinit_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl, type);
 	if (rc == 0)
 		return -ENOMEM;
--
1.7.10.4

