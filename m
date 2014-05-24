Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaEXDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 23:09:26 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63121 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEXDJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 23:09:25 -0400
From: Greg DeAngelis <gdeangel@gmail.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com
Cc: andreas.dilger@intel.com, sachin.kamat@linaro.org, gdeangel@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: Fixed warnings about using 0 as NULL ptr
Date: Fri, 23 May 2014 23:09:11 -0400
Message-Id: <1400900951-23497-1-git-send-email-gdeangel@gmail.com>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a bunch of warnings pointed out by sparse about using 0 to
represent a NULL pointer.

Signed-off-by: Greg DeAngelis <gdeangel@gmail.com>
---
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/mgc/lproc_mgc.c b/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
index 1506af1..6c877c5 100644
--- a/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
+++ b/drivers/staging/lustre/lustre/mgc/lproc_mgc.c
@@ -56,21 +56,21 @@ static int mgc_ir_state_seq_show(struct seq_file *m, void *v)
 LPROC_SEQ_FOPS_RO(mgc_ir_state);
 
 static struct lprocfs_vars lprocfs_mgc_obd_vars[] = {
-	{ "uuid",	     &mgc_uuid_fops,	  0, 0 },
-	{ "ping",	     &mgc_ping_fops,      0, 0222 },
-	{ "connect_flags",   &mgc_connect_flags_fops, 0, 0 },
-	{ "mgs_server_uuid", &mgc_server_uuid_fops,   0, 0 },
-	{ "mgs_conn_uuid",   &mgc_conn_uuid_fops,     0, 0 },
-	{ "import",	     &mgc_import_fops,	0, 0 },
-	{ "state",	     &mgc_state_fops,	 0, 0 },
-	{ "ir_state",	     &mgc_ir_state_fops,  0, 0 },
-	{ 0 }
+	{ "uuid",	     &mgc_uuid_fops,	  NULL, 0 },
+	{ "ping",	     &mgc_ping_fops,      NULL, 0222 },
+	{ "connect_flags",   &mgc_connect_flags_fops, NULL, 0 },
+	{ "mgs_server_uuid", &mgc_server_uuid_fops,   NULL, 0 },
+	{ "mgs_conn_uuid",   &mgc_conn_uuid_fops,     NULL, 0 },
+	{ "import",	     &mgc_import_fops,	NULL, 0 },
+	{ "state",	     &mgc_state_fops,	 NULL, 0 },
+	{ "ir_state",	     &mgc_ir_state_fops,  NULL, 0 },
+	{ NULL }
 };
 
 LPROC_SEQ_FOPS_RO_TYPE(mgc, numrefs);
 static struct lprocfs_vars lprocfs_mgc_module_vars[] = {
-	{ "num_refs",	&mgc_numrefs_fops,       0, 0 },
-	{ 0 }
+	{ "num_refs",	&mgc_numrefs_fops,       NULL, 0 },
+	{ NULL }
 };
 
 void lprocfs_mgc_init_vars(struct lprocfs_static_vars *lvars)
-- 
1.7.10.4

