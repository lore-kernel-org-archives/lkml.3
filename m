Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbaFYODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:03:25 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44132 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbaFYODX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:03:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 16:04:19 +0200
Message-Id: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to different values without having used in between.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..fdf7bc3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1643,7 +1643,6 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
 	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
-	stats->custom_length = 3;
 	strcpy(stats->custom[2].desc, "eh_abort_cnt");
 	stats->custom[2].value = conn->eh_abort_cnt;
 	stats->digest_err = 0;
-- 
1.7.10.4

