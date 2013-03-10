Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3CJIKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:10:16 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35339 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3CJIKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:10:08 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH -mmotm] scsi: fix the wrong position of the comment
Date: Sun, 10 Mar 2013 17:09:50 +0900
Message-Id: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the wrong position of the comment introduced by
scsi-rename-random32-to-prandom_u32.patch in the -mm tree.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 04bf7b8..e44d47e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	}
 
 	/* No pending activities shall be there on the vha now */
-	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(prandom_u32() % 10);
+	if (ql2xextended_error_logging & ql_dbg_user) {
 		/*
 		 * Just to see if something falls on the net we have placed
 		 * below
 		 */
-
+		msleep(prandom_u32() % 10);
+	}
 	BUG_ON(atomic_read(&vha->vref_count));
 
 	qla2x00_free_fcports(vha);
-- 
1.8.1.4

