Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074AbaHaEzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 00:55:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36871 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaHaEzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 00:55:17 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv2 1/4] staging:lustre:lnet: lib-md.c make line not over 80 characters
Date: Sun, 31 Aug 2014 12:55:07 +0800
Message-Id: <1409460907-4859-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the following checkpatch warnings:
  WARNING: line over 80 characters

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index 1f386e0..b52ca0f 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-md.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-md.c
@@ -52,7 +52,8 @@ lnet_md_unlink(lnet_libmd_t *md)
 
 		md->md_flags |= LNET_MD_FLAG_ZOMBIE;
 
-		/* Disassociate from ME (if any), and unlink it if it was created
+		/* Disassociate from ME (if any),
+		 * and unlink it if it was created
 		 * with LNET_UNLINK */
 		if (me != NULL) {
 			/* detach MD from portal */
@@ -113,7 +114,8 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the base address on trust */
-			if (lmd->md_iov.iov[i].iov_len <= 0) /* invalid length */
+			/* invalid length */
+			if (lmd->md_iov.iov[i].iov_len <= 0)
 				return -EINVAL;
 
 			total_length += lmd->md_iov.iov[i].iov_len;
@@ -206,7 +208,8 @@ lnet_md_deconstruct(lnet_libmd_t *lmd, lnet_md_t *umd)
 	 * and that's all.
 	 */
 	umd->start = lmd->md_start;
-	umd->length = ((lmd->md_options & (LNET_MD_IOVEC | LNET_MD_KIOV)) == 0) ?
+	umd->length = ((lmd->md_options &
+			(LNET_MD_IOVEC | LNET_MD_KIOV)) == 0) ?
 		      lmd->md_length : lmd->md_niov;
 	umd->threshold = lmd->md_threshold;
 	umd->max_size = lmd->md_max_size;
-- 
1.7.9.5

