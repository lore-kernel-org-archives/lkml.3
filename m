Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaICTe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:34:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56230 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaICTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:34:27 -0400
From: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
Subject: [PATCH 1/1] staging - lustre: Fixed coding style issues
Date: Wed,  3 Sep 2014 20:33:46 +0100
Message-Id: <1409772826-3516-1-git-send-email-filipe@codinghighway.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes several coding style issues that were reported by checkpath on lproc_lmv.c.

Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
---
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index 310df44..ce6c14f 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -37,7 +37,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/seq_file.h>
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include "../include/lprocfs_status.h"
 #include "../include/obd_class.h"
 
@@ -52,7 +52,7 @@ static int lmv_numobd_seq_show(struct seq_file *m, void *v)
 }
 LPROC_SEQ_FOPS_RO(lmv_numobd);
 
-static const char *placement_name[] = {
+static const char *const placement_name[] = {
 	[PLACEMENT_CHAR_POLICY] = "CHAR",
 	[PLACEMENT_NID_POLICY]  = "NID",
 	[PLACEMENT_INVAL_POLICY]  = "INVAL"
@@ -91,7 +91,8 @@ static ssize_t lmv_placement_seq_write(struct file *file,
 					const char __user *buffer,
 					size_t count, loff_t *off)
 {
-	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
+	struct obd_device *dev =
+		((struct seq_file *)file->private_data)->private;
 	char		     dummy[MAX_POLICY_STRING_SIZE + 1];
 	int		      len = count;
 	placement_policy_t       policy;
@@ -149,12 +150,12 @@ static void *lmv_tgt_seq_start(struct seq_file *p, loff_t *pos)
 {
 	struct obd_device       *dev = p->private;
 	struct lmv_obd	  *lmv = &dev->u.lmv;
+
 	return (*pos >= lmv->desc.ld_tgt_count) ? NULL : lmv->tgts[*pos];
 }
 
 static void lmv_tgt_seq_stop(struct seq_file *p, void *v)
 {
-	return;
 }
 
 static void *lmv_tgt_seq_next(struct seq_file *p, void *v, loff_t *pos)
@@ -175,7 +176,7 @@ static int lmv_tgt_seq_show(struct seq_file *p, void *v)
 			  tgt->ltd_uuid.uuid, tgt->ltd_active ? "" : "IN");
 }
 
-struct seq_operations lmv_tgt_sops = {
+static const struct seq_operations lmv_tgt_sops = {
 	.start		 = lmv_tgt_seq_start,
 	.stop		  = lmv_tgt_seq_stop,
 	.next		  = lmv_tgt_seq_next,
@@ -215,7 +216,7 @@ static struct lprocfs_vars lprocfs_lmv_module_vars[] = {
 	{ NULL }
 };
 
-struct file_operations lmv_proc_target_fops = {
+static const struct file_operations lmv_proc_target_fops = {
 	.owner		= THIS_MODULE,
 	.open		 = lmv_target_seq_open,
 	.read		 = seq_read,
-- 
1.9.1

