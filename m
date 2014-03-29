Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaC2SHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:07:18 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58698 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaC2SHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:07:13 -0400
Date: Sat, 29 Mar 2014 23:37:39 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 22/55] scsi: Mark functions as static in lpfc/lpfc_sli.c
Message-ID: <40d8e4f4132458be216d54ba6aa027e594e65d03.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in lpfc/lpfc_sli.c because they are not used
outside this file.

This eliminates the following warnings in lpfc/lpfc_sli.c:
drivers/scsi/lpfc/lpfc_sli.c:13867:1: warning: no previous prototype for ‘lpfc_sli4_alloc_xri’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:13897:1: warning: no previous prototype for ‘__lpfc_sli4_free_xri’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:14317:1: warning: no previous prototype for ‘lpfc_update_rcv_time_stamp’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:14786:1: warning: no previous prototype for ‘lpfc_sli4_handle_unsol_abort’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:15331:1: warning: no previous prototype for ‘__lpfc_sli4_free_rpi’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:15769:1: warning: no previous prototype for ‘lpfc_check_next_fcf_pri_level’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_sli.c:16000:1: warning: no previous prototype for ‘lpfc_mbx_cmpl_redisc_fcf_table’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8f580fd..150095b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13863,7 +13863,7 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba,
  *	A nonzero rpi defined as rpi_base <= rpi < max_rpi if successful
  *	LPFC_RPI_ALLOC_ERROR if no rpis are available.
  **/
-uint16_t
+static uint16_t
 lpfc_sli4_alloc_xri(struct lpfc_hba *phba)
 {
 	unsigned long xri;
@@ -13893,7 +13893,7 @@ lpfc_sli4_alloc_xri(struct lpfc_hba *phba)
  * This routine is invoked to release an xri to the pool of
  * available rpis maintained by the driver.
  **/
-void
+static void
 __lpfc_sli4_free_xri(struct lpfc_hba *phba, int xri)
 {
 	if (test_and_clear_bit(xri, phba->sli4_hba.xri_bmask)) {
@@ -14313,7 +14313,7 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr,
  * the driver uses this time stamp to indicate if any received sequences have
  * timed out.
  **/
-void
+static void
 lpfc_update_rcv_time_stamp(struct lpfc_vport *vport)
 {
 	struct lpfc_dmabuf *h_buf;
@@ -14782,7 +14782,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
  * unsolicited sequence has been aborted. After that, it will issue a basic
  * accept to accept the abort.
  **/
-void
+static void
 lpfc_sli4_handle_unsol_abort(struct lpfc_vport *vport,
 			     struct hbq_dmabuf *dmabuf)
 {
@@ -15327,7 +15327,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phba)
  * This routine is invoked to release an rpi to the pool of
  * available rpis maintained by the driver.
  **/
-void
+static void
 __lpfc_sli4_free_rpi(struct lpfc_hba *phba, int rpi)
 {
 	if (test_and_clear_bit(rpi, phba->sli4_hba.rpi_bmask)) {
@@ -15765,7 +15765,7 @@ fail_fcf_read:
  * returns:
  * 1=success 0=failure
  **/
-int
+static int
 lpfc_check_next_fcf_pri_level(struct lpfc_hba *phba)
 {
 	uint16_t next_fcf_pri;
@@ -15996,7 +15996,7 @@ lpfc_sli4_fcf_rr_index_clear(struct lpfc_hba *phba, uint16_t fcf_index)
  * command. If the mailbox command returned failure, it will try to stop the
  * FCF rediscover wait timer.
  **/
-void
+static void
 lpfc_mbx_cmpl_redisc_fcf_table(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 {
 	struct lpfc_mbx_redisc_fcf_tbl *redisc_fcf;
-- 
1.7.9.5

