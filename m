Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaC2SKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:10:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52127 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaC2SKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:10:35 -0400
Date: Sat, 29 Mar 2014 23:41:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 25/55] scsi: Mark functions as static in lpfc/lpfc_scsi.c
Message-ID: <5224416254456aaf9e27cc31b070543dda9ff7c9.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in lpfc/lpfc_scsi.c because they are not used
outside this file.

This eliminates the following warnings in lpfc/lpfc_scsi.c:
drivers/scsi/lpfc/lpfc_scsi.c:299:1: warning: no previous prototype for ‘lpfc_change_queue_depth’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:795:1: warning: no previous prototype for ‘lpfc_sli4_post_scsi_sgl_list’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3019:1: warning: no previous prototype for ‘lpfc_bg_crc’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3035:1: warning: no previous prototype for ‘lpfc_bg_csum’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_scsi.c:3048:1: warning: no previous prototype for ‘lpfc_calc_bg_err’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b2ede05..75844a8e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -295,7 +295,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
  * depth for a scsi device. This function sets the queue depth to the new
  * value and sends an event out to log the queue depth change.
  **/
-int
+static int
 lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
@@ -791,7 +791,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
  *
  * Returns: 0 = failure, non-zero number of successfully posted buffers.
  **/
-int
+static int
 lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 			     struct list_head *post_sblist, int sb_count)
 {
@@ -3015,7 +3015,7 @@ err:
  * on the specified data using a CRC algorithmn
  * using crc_t10dif.
  */
-uint16_t
+static uint16_t
 lpfc_bg_crc(uint8_t *data, int count)
 {
 	uint16_t crc = 0;
@@ -3031,7 +3031,7 @@ lpfc_bg_crc(uint8_t *data, int count)
  * on the specified data using a CSUM algorithmn
  * using ip_compute_csum.
  */
-uint16_t
+static uint16_t
 lpfc_bg_csum(uint8_t *data, int count)
 {
 	uint16_t ret;
@@ -3044,7 +3044,7 @@ lpfc_bg_csum(uint8_t *data, int count)
  * This function examines the protection data to try to determine
  * what type of T10-DIF error occurred.
  */
-void
+static void
 lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 {
 	struct scatterlist *sgpe; /* s/g prot entry */
-- 
1.7.9.5

