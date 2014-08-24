Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaHXR6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:58:40 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61095 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaHXR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:58:39 -0400
From: Janet Liu <jianhua.ljh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Janet Liu <jianhua.ljh@gmail.com>
Subject: [PATCH] staging:lustre: lib-md.c fix checkpath warnings and errors.
Date: Mon, 25 Aug 2014 01:58:23 +0800
Message-Id: <1408903103-8678-1-git-send-email-jianhua.ljh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sliences the following warning and error:

  WARNING: line over 80 characters
  WARNING: space prohibited between function name and open parenthesis '('
  ERROR: do not use C99 // comments
  ERROR: trailing statements should be on next line

Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-md.c |   44 ++++++++++++++++-------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-md.c b/drivers/staging/lustre/lnet/lnet/lib-md.c
index 1f386e0..ef3733d 100644
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
@@ -109,11 +110,12 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_niov = niov = umd->length;
 		memcpy(lmd->md_iov.iov, umd->start,
-		       niov * sizeof (lmd->md_iov.iov[0]));
+		       niov * sizeof(lmd->md_iov.iov[0]));
 
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the base address on trust */
-			if (lmd->md_iov.iov[i].iov_len <= 0) /* invalid length */
+			 /* invalid length */
+			if (lmd->md_iov.iov[i].iov_len <= 0)
 				return -EINVAL;
 
 			total_length += lmd->md_iov.iov[i].iov_len;
@@ -121,20 +123,21 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_length = total_length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
-		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
+
+			(umd->max_size < 0 ||
+			umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 
 	} else if ((umd->options & LNET_MD_KIOV) != 0) {
 		lmd->md_niov = niov = umd->length;
 		memcpy(lmd->md_iov.kiov, umd->start,
-		       niov * sizeof (lmd->md_iov.kiov[0]));
+		       niov * sizeof(lmd->md_iov.kiov[0]));
 
 		for (i = 0; i < (int)niov; i++) {
 			/* We take the page pointer on trust */
 			if (lmd->md_iov.kiov[i].kiov_offset +
-			    lmd->md_iov.kiov[i].kiov_len > PAGE_CACHE_SIZE )
+			    lmd->md_iov.kiov[i].kiov_len > PAGE_CACHE_SIZE)
 				return -EINVAL; /* invalid length */
 
 			total_length += lmd->md_iov.kiov[i].kiov_len;
@@ -142,9 +145,9 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 
 		lmd->md_length = total_length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
-		     umd->max_size > total_length)) // illegal max_size
+		     umd->max_size > total_length)) /* illegal max_size */
 			return -EINVAL;
 	} else {   /* contiguous */
 		lmd->md_length = umd->length;
@@ -152,9 +155,9 @@ lnet_md_build(lnet_libmd_t *lmd, lnet_md_t *umd, int unlink)
 		lmd->md_iov.iov[0].iov_base = umd->start;
 		lmd->md_iov.iov[0].iov_len = umd->length;
 
-		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /* max size used */
+		if ((umd->options & LNET_MD_MAX_SIZE) != 0 && /*max size used*/
 		    (umd->max_size < 0 ||
-		     umd->max_size > (int)umd->length)) // illegal max_size
+		     umd->max_size > (int)umd->length)) /* illegal max_size */
 			return -EINVAL;
 	}
 
@@ -206,7 +209,8 @@ lnet_md_deconstruct(lnet_libmd_t *lmd, lnet_md_t *umd)
 	 * and that's all.
 	 */
 	umd->start = lmd->md_start;
-	umd->length = ((lmd->md_options & (LNET_MD_IOVEC | LNET_MD_KIOV)) == 0) ?
+	umd->length = ((lmd->md_options &
+			(LNET_MD_IOVEC | LNET_MD_KIOV)) == 0) ?
 		      lmd->md_length : lmd->md_niov;
 	umd->threshold = lmd->md_threshold;
 	umd->max_size = lmd->md_max_size;
@@ -263,15 +267,15 @@ int
 LNetMDAttach(lnet_handle_me_t meh, lnet_md_t umd,
 	     lnet_unlink_t unlink, lnet_handle_md_t *handle)
 {
-	LIST_HEAD		(matches);
-	LIST_HEAD		(drops);
+	LIST_HEAD		matches;
+	LIST_HEAD		drops;
 	struct lnet_me		*me;
 	struct lnet_libmd	*md;
 	int			cpt;
 	int			rc;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	if (lnet_md_validate(&umd) != 0)
 		return -EINVAL;
@@ -347,8 +351,8 @@ LNetMDBind(lnet_md_t umd, lnet_unlink_t unlink, lnet_handle_md_t *handle)
 	int		cpt;
 	int		rc;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	if (lnet_md_validate(&umd) != 0)
 		return -EINVAL;
@@ -416,7 +420,7 @@ EXPORT_SYMBOL(LNetMDBind);
  * \retval -ENOENT If \a mdh does not point to a valid MD object.
  */
 int
-LNetMDUnlink (lnet_handle_md_t mdh)
+LNetMDUnlink(lnet_handle_md_t mdh)
 {
 	lnet_event_t	ev;
 	lnet_libmd_t	*md;
-- 
1.7.9.5

