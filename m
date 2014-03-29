Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaC2SIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:08:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51449 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaC2SIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:08:13 -0400
Date: Sat, 29 Mar 2014 23:38:38 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 23/55] scsi: Mark functions as static in lpfc/lpfc_hbadisc.c
Message-ID: <164350d85014181d5a776518b1e04e9fde5a9abd.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in lpfc/lpfc_hbadisc.c because they are not
used outside this file.

This eliminates the following warnings in lpfc/lpfc_hbadisc.c:
drivers/scsi/lpfc/lpfc_hbadisc.c:2047:5: warning: no previous prototype for ‘lpfc_sli4_fcf_pri_list_add’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_hbadisc.c:2681:1: warning: no previous prototype for ‘lpfc_init_vfi_cmpl’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_hbadisc.c:4432:1: warning: no previous prototype for ‘lpfc_nlp_logo_unreg’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 883ea2d..0441d50 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2044,7 +2044,8 @@ lpfc_sli4_set_fcf_flogi_fail(struct lpfc_hba *phba, uint16_t fcf_index)
  * returns:
  * 0=success 1=failure
  **/
-int lpfc_sli4_fcf_pri_list_add(struct lpfc_hba *phba, uint16_t fcf_index,
+static int lpfc_sli4_fcf_pri_list_add(struct lpfc_hba *phba,
+	uint16_t fcf_index,
 	struct fcf_record *new_fcf_record)
 {
 	uint16_t current_fcf_pri;
@@ -2677,7 +2678,7 @@ out:
  *
  * This function handles completion of init vfi mailbox command.
  */
-void
+static void
 lpfc_init_vfi_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport = mboxq->vport;
@@ -4428,7 +4429,7 @@ lpfc_no_rpi(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
  * This function will issue an ELS LOGO command after completing
  * the UNREG_RPI.
  **/
-void
+static void
 lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport = pmb->vport;
-- 
1.7.9.5

