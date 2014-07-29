Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaG2WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:16:26 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64460 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaG2WQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:16:24 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v5 1/4] Staging: rts5208: Remove useless debug prints
Date: Wed, 30 Jul 2014 00:15:52 +0200
Message-Id: <1406672155-13187-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all debug printks used just to mark when we enter a function.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/ms.c        | 24 ------------------------
 drivers/staging/rts5208/rtsx_scsi.c |  4 ----
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c
index d22916a..160d449 100644
--- a/drivers/staging/rts5208/ms.c
+++ b/drivers/staging/rts5208/ms.c
@@ -2473,8 +2473,6 @@ void mspro_stop_seq_mode(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	if (ms_card->seq_mode) {
 		retval = ms_switch_clock(chip);
 		if (retval != STATUS_SUCCESS)
@@ -2493,8 +2491,6 @@ static inline int ms_auto_tune_clock(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	if (chip->asic_code) {
 		if (ms_card->ms_clock > 30)
 			ms_card->ms_clock -= 20;
@@ -2783,8 +2779,6 @@ int mspro_format(struct scsi_cmnd *srb, struct rtsx_chip *chip,
 	u8 buf[8], tmp;
 	u16 para;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	retval = ms_switch_clock(chip);
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
@@ -3664,8 +3658,6 @@ static int mg_set_tpc_para_sub(struct rtsx_chip *chip, int type,
 	int retval;
 	u8 buf[6];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	if (type == 0)
 		retval = ms_set_rw_reg_addr(chip, 0, 0, Pro_TPCParm, 1);
 	else
@@ -3697,8 +3689,6 @@ int mg_set_leaf_id(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf1[32], buf2[12];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	if (scsi_bufflen(srb) < 12) {
 		set_sense_type(chip, lun, SENSE_TYPE_MEDIA_INVALID_CMD_FIELD);
 		TRACE_RET(chip, STATUS_FAIL);
@@ -3743,8 +3733,6 @@ int mg_get_local_EKB(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -3796,8 +3784,6 @@ int mg_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf[32];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -3872,8 +3858,6 @@ int mg_get_rsp_chg(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf1[32], buf2[36];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -3929,8 +3913,6 @@ int mg_rsp(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 buf[32];
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -3977,8 +3959,6 @@ int mg_get_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -4032,8 +4012,6 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	unsigned int lun = SCSI_LUN(srb);
 	u8 *buf = NULL;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	ms_cleanup_work(chip);
 
 	retval = ms_switch_clock(chip);
@@ -4182,8 +4160,6 @@ int release_ms_card(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 
-	RTSX_DEBUGP("release_ms_card\n");
-
 #ifdef MS_DELAY_WRITE
 	ms_card->delay_write.delay_write_flag = 0;
 #endif
diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index bbfa665..72b4c26 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -3030,8 +3030,6 @@ static int mg_report_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	int retval;
 	u8 key_format;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	rtsx_disable_aspm(chip);
 
 	if (chip->ss_en && (rtsx_get_stat(chip) == RTSX_STAT_SS)) {
@@ -3131,8 +3129,6 @@ static int mg_send_key(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 	int retval;
 	u8 key_format;
 
-	RTSX_DEBUGP("--%s--\n", __func__);
-
 	rtsx_disable_aspm(chip);
 
 	if (chip->ss_en && (rtsx_get_stat(chip) == RTSX_STAT_SS)) {
-- 
2.0.0

