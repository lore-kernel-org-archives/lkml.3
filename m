Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaCXU6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:58:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39963 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbaCXU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:58:06 -0400
Date: Mon, 24 Mar 2014 13:58:02 -0700
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Subject: [PATCH] drivers:staging:lustre Fixed sparse warning: plain integer
 as NULL pointer
Message-ID: <20140324205754.GA18927@vega.socal.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes these sparse warnings:
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:202:51: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:203:51: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:204:51: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:205:51: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:206:51: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:207:11: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:213:47: warning: Using plain integer as NULL pointer
drivers/staging/lustre/lustre/lmv/lproc_lmv.c:214:11: warning: Using plain integer as NULL pointer

Signed-off-by: John de la Garza <john@jjdev.com>
---
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index b355d01..5d75e8c 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -199,19 +199,19 @@ static int lmv_target_seq_open(struct inode *inode, struct file *file)
 LPROC_SEQ_FOPS_RO_TYPE(lmv, uuid);
 
 struct lprocfs_vars lprocfs_lmv_obd_vars[] = {
-	{ "numobd",	  &lmv_numobd_fops,	  0, 0 },
-	{ "placement",	  &lmv_placement_fops,    0, 0 },
-	{ "activeobd",	  &lmv_activeobd_fops,    0, 0 },
-	{ "uuid",	  &lmv_uuid_fops,	  0, 0 },
-	{ "desc_uuid",	  &lmv_desc_uuid_fops,    0, 0 },
-	{ 0 }
+	{ "numobd",	  &lmv_numobd_fops,	  NULL, 0 },
+	{ "placement",	  &lmv_placement_fops,    NULL, 0 },
+	{ "activeobd",	  &lmv_activeobd_fops,    NULL, 0 },
+	{ "uuid",	  &lmv_uuid_fops,	  NULL, 0 },
+	{ "desc_uuid",	  &lmv_desc_uuid_fops,    NULL, 0 },
+	{ NULL }
 };
 
 LPROC_SEQ_FOPS_RO_TYPE(lmv, numrefs);
 
 static struct lprocfs_vars lprocfs_lmv_module_vars[] = {
-	{ "num_refs",	   &lmv_numrefs_fops, 0, 0 },
-	{ 0 }
+	{ "num_refs",	   &lmv_numrefs_fops, NULL, 0 },
+	{ NULL }
 };
 
 struct file_operations lmv_proc_target_fops = {
-- 
1.9.0

