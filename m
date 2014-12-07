Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaLGRX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:23:27 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54217 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaLGRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:23:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bfa: bfa_fcpim.c:  Remove unused function
Date: Sun,  7 Dec 2014 18:26:02 +0100
Message-Id: <1417973162-13148-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function bfa_tskim_iodone() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcpim.c |    9 ---------
 drivers/scsi/bfa/bfa_fcpim.h |    1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index d7385d1..ceb18ef 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -3477,15 +3477,6 @@ bfa_tskim_iocdisable_ios(struct bfa_tskim_s *tskim)
 }
 
 /*
- * Notification on completions from related ioim.
- */
-void
-bfa_tskim_iodone(struct bfa_tskim_s *tskim)
-{
-	bfa_wc_down(&tskim->wc);
-}
-
-/*
  * Handle IOC h/w failure notification from itnim.
  */
 void
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index e693af6..8ab548f 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -286,7 +286,6 @@ void	bfa_ioim_tov(struct bfa_ioim_s *ioim);
 
 void	bfa_tskim_attach(struct bfa_fcpim_s *fcpim);
 void	bfa_tskim_isr(struct bfa_s *bfa, struct bfi_msg_s *msg);
-void	bfa_tskim_iodone(struct bfa_tskim_s *tskim);
 void	bfa_tskim_iocdisable(struct bfa_tskim_s *tskim);
 void	bfa_tskim_cleanup(struct bfa_tskim_s *tskim);
 void	bfa_tskim_res_recfg(struct bfa_s *bfa, u16 num_tskim_fw);
-- 
1.7.10.4

