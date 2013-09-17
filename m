Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3IQB2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:28:06 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56347 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437Ab3IQB2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:28:03 -0400
X-Sasl-enc: nsJMWvCOf1mkqknol444LKrv1Wmxn62WJB3xWKKTQ/p1 1379381279
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, xuezhao.liu@emc.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: remove assignment in if conditions
Date: Mon, 16 Sep 2013 21:27:55 -0400
Message-Id: <1379381275-3244-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to lvfs_linux.c that removes the use of variable assignment
within an if condition found by checkpatch.pl.

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 18e1b47..7b03f4d 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -80,7 +80,8 @@ static void push_group_info(struct lvfs_run_ctxt *save,
 		struct cred *cred;
 		task_lock(current);
 		save->group_info = current_cred()->group_info;
-		if ((cred = prepare_creds())) {
+		cred = prepare_creds();
+		if (cred) {
 			cred->group_info = ginfo;
 			commit_creds(cred);
 		}
@@ -96,7 +97,8 @@ static void pop_group_info(struct lvfs_run_ctxt *save,
 	} else {
 		struct cred *cred;
 		task_lock(current);
-		if ((cred = prepare_creds())) {
+		cred = prepare_creds();
+		if (cred) {
 			cred->group_info = save->group_info;
 			commit_creds(cred);
 		}
@@ -137,7 +139,8 @@ void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
 		save->luc.luc_fsgid = current_fsgid();
 		save->luc.luc_cap = current_cap();
 
-		if ((cred = prepare_creds())) {
+		cred = prepare_creds();
+		if (cred) {
 			cred->uid = uc->luc_uid;
 			cred->gid = uc->luc_gid;
 			cred->fsuid = uc->luc_fsuid;
@@ -180,7 +183,8 @@ void pop_ctxt(struct lvfs_run_ctxt *saved, struct lvfs_run_ctxt *new_ctx,
 	current->fs->umask = saved->luc.luc_umask;
 	if (uc) {
 		struct cred *cred;
-		if ((cred = prepare_creds())) {
+		cred = prepare_creds();
+		if (cred) {
 			cred->uid = saved->luc.luc_uid;
 			cred->gid = saved->luc.luc_gid;
 			cred->fsuid = saved->luc.luc_fsuid;
-- 
1.8.4

