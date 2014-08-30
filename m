Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaH3GxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 02:53:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64230 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaH3GxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 02:53:07 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCHv1 1/4] staging:lustre:lnet: lib-md.c make line not over 80 characters
Date: Sat, 30 Aug 2014 14:52:55 +0800
Message-Id: <1409381575-2211-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following checkpatch warning:
  WARNING: line over 80 characters

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index 1f386e0..efd1b82 100644
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
@@ -121,7 +123,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_length = total_length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
 		     umd->max_size > total_length)) // illegal max_size
 			return -EINVAL;
@@ -142,7 +144,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_length = total_length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
 		     umd->max_size > total_length)) // illegal max_size
 			return -EINVAL;
@@ -152,7 +154,7 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 		lmd->md_iov.iov[0].iov_base = umd->start;
 		lmd->md_iov.iov[0].iov_len = umd->length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
 		     umd->max_size > (int)umd->length)) // illegal max_size
 			return -EINVAL;
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

