Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3JRXPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:15:06 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47440 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JRXPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:15:04 -0400
From: Felipe Pena <felipensp@gmail.com>
To: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: scsi: lpfc_debugfs: Fix wrong assignment
Date: Fri, 18 Oct 2013 20:15:37 -0300
Message-Id: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lpfc_debugfs_initialize function the dumpHostSlim member setup happens
when 'phba->sli_rev < LPFC_SLI_REV4' is true, however when it is false NULL
has been assigned to debug_dumpHBASlim instead of debug_dumpHostSlim.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 60084e6..b800cc9 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -4001,7 +4001,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 		} else
-			phba->debug_dumpHBASlim = NULL;
+			phba->debug_dumpHostSlim = NULL;

 		/* Setup dumpData */
 		snprintf(name, sizeof(name), "dumpData");
--
1.7.10.4

