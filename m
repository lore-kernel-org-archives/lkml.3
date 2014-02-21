Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbaBUBKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:10:36 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47661 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaBUBKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:10:34 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: JBottomley@parallels.com
Cc: james.smart@emulex.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
Date: Fri, 21 Feb 2014 10:10:24 +0900
Message-ID: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9e7478f6e953fac5b2bef0f5abe76fe8dc9e59d1 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 21 Feb 2014 09:03:32 +0900
Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer

sparse says:
drivers/scsi/lpfc/lpfc_sli.c:16547:37: warning:
 Using plain integer as NULL pointer

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8f580fd..a218ecd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16544,7 +16544,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	struct lpfc_iocbq *piocbq = 0;
+	struct lpfc_iocbq *piocbq = NULL;
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
 	struct lpfc_sglq *sglq;
-- 
1.7.9.5

---
