Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaC2SLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:11:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64281 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaC2SLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:11:39 -0400
Date: Sat, 29 Mar 2014 23:42:04 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 26/55] scsi: Mark function as static in lpfc/lpfc_bsg.c
Message-ID: <a9d15b00d960134818a399665442070030e9458f.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in lpfc/lpfc_bsg.c because it is not used
outside this file.

This eliminates the following warning in lpfc/lpfc_bsg.c:
drivers/scsi/lpfc/lpfc_bsg.c:3348:1: warning: no previous prototype for ‘lpfc_bsg_issue_mbox_cmpl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 82134d2..4735de5 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3344,7 +3344,7 @@ job_error:
  * will wake up thread waiting on the wait queue pointed by context1
  * of the mailbox.
  **/
-void
+static void
 lpfc_bsg_issue_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
-- 
1.7.9.5

