Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbbACL3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 06:29:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54544 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbACL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 06:29:19 -0500
From: Andreas Ruprecht <rupran@einserver.de>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] staging: lustre: fid: Remove space before braces for defined() check
Date: Sat,  3 Jan 2015 12:29:05 +0100
Message-Id: <1420284545-29282-1-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch complains about three places where a space is prohibited
before the braces for an "#if defined()" check. This patch removes
the spaces.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/staging/lustre/lustre/fid/fid_internal.h | 2 +-
 drivers/staging/lustre/lustre/fid/fid_request.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/fid_internal.h b/drivers/staging/lustre/lustre/fid/fid_internal.h
index eb607c52ef3b..b5e8da8956f2 100644
--- a/drivers/staging/lustre/lustre/fid/fid_internal.h
+++ b/drivers/staging/lustre/lustre/fid/fid_internal.h
@@ -47,7 +47,7 @@
 int seq_client_alloc_super(struct lu_client_seq *seq,
 			   const struct lu_env *env);
 
-#if defined (CONFIG_PROC_FS)
+#if defined(CONFIG_PROC_FS)
 extern struct lprocfs_vars seq_client_proc_list[];
 #endif
 
diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index 64b1d80c64b0..063441abfcfc 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -402,7 +402,7 @@ EXPORT_SYMBOL(seq_client_flush);
 
 static void seq_client_proc_fini(struct lu_client_seq *seq)
 {
-#if defined (CONFIG_PROC_FS)
+#if defined(CONFIG_PROC_FS)
 	if (seq->lcs_proc_dir) {
 		if (!IS_ERR(seq->lcs_proc_dir))
 			lprocfs_remove(&seq->lcs_proc_dir);
@@ -413,7 +413,7 @@ static void seq_client_proc_fini(struct lu_client_seq *seq)
 
 static int seq_client_proc_init(struct lu_client_seq *seq)
 {
-#if defined (CONFIG_PROC_FS)
+#if defined(CONFIG_PROC_FS)
 	int rc;
 
 	seq->lcs_proc_dir = lprocfs_register(seq->lcs_name,
-- 
1.9.1

