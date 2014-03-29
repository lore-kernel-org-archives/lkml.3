Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaC2Sh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:37:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36497 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaC2Sh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:37:27 -0400
Date: Sun, 30 Mar 2014 00:07:52 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 44/55] scsi: Mark function as static in scsi/libiscsi.c
Message-ID: <eee20bd6ca50408da98bda77cf40180ba084c3e7.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in libiscsi.c because it is not used outside
this file. Also, unexport the function because it is used only in this
file.

This eliminates the following warning in libiscsi.c:
drivers/scsi/libiscsi.c:2386:5: warning: no previous prototype for ‘iscsi_eh_target_reset’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/libiscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4046241..3afc7b6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2383,7 +2383,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2455,7 +2455,6 @@ done:
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
 
 /**
  * iscsi_eh_recover_target - reset target and possibly the session
-- 
1.7.9.5

