Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaCEN3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:29:32 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36827 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaCEN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:29:27 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 3/6] staging/lustre/libcfs_string.h: don't export internal functions
Date: Wed,  5 Mar 2014 21:27:17 +0800
Message-Id: <1394026040-1968-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfs_expr_list_print is removed due to no callers. Other internal
functions are held unexported.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_string.h    |    3 ---
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   20 +-------------------
 2 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
index a6bac9c..83b7f42 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
@@ -109,8 +109,6 @@ char *cfs_trimwhite(char *str);
 int cfs_gettok(struct cfs_lstr *next, char delim, struct cfs_lstr *res);
 int cfs_str2num_check(char *str, int nob, unsigned *num,
 		      unsigned min, unsigned max);
-int cfs_range_expr_parse(struct cfs_lstr *src, unsigned min, unsigned max,
-			 int single_tok, struct cfs_range_expr **expr);
 int cfs_expr_list_match(__u32 value, struct cfs_expr_list *expr_list);
 int cfs_expr_list_values(struct cfs_expr_list *expr_list,
 			 int max, __u32 **values);
@@ -124,7 +122,6 @@ cfs_expr_list_values_free(__u32 *values, int num)
 }
 
 void cfs_expr_list_free(struct cfs_expr_list *expr_list);
-void cfs_expr_list_print(struct cfs_expr_list *expr_list);
 int cfs_expr_list_parse(char *str, int len, unsigned min, unsigned max,
 			struct cfs_expr_list **elpp);
 void cfs_expr_list_free_list(struct list_head *list);
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index dc6a59a..b9ed2a89 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -109,7 +109,6 @@ int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 	*oldmask = newmask;
 	return 0;
 }
-EXPORT_SYMBOL(cfs_str2mask);
 
 /* get the first string out of @str */
 char *cfs_firststr(char *str, size_t size)
@@ -213,7 +212,6 @@ cfs_gettok(struct cfs_lstr *next, char delim, struct cfs_lstr *res)
 	res->ls_len = end - res->ls_str + 1;
 	return 1;
 }
-EXPORT_SYMBOL(cfs_gettok);
 
 /**
  * Converts string to integer.
@@ -242,7 +240,6 @@ cfs_str2num_check(char *str, int nob, unsigned *num,
 
 	return (*num >= min && *num <= max);
 }
-EXPORT_SYMBOL(cfs_str2num_check);
 
 /**
  * Parses \<range_expr\> token of the syntax. If \a bracketed is false,
@@ -257,7 +254,7 @@ EXPORT_SYMBOL(cfs_str2num_check);
  * \retval 0 will be returned if it can be parsed, otherwise -EINVAL or
  * -ENOMEM will be returned.
  */
-int
+static int
 cfs_range_expr_parse(struct cfs_lstr *src, unsigned min, unsigned max,
 		     int bracketed, struct cfs_range_expr **expr)
 {
@@ -320,7 +317,6 @@ cfs_range_expr_parse(struct cfs_lstr *src, unsigned min, unsigned max,
 	LIBCFS_FREE(re, sizeof(*re));
 	return -EINVAL;
 }
-EXPORT_SYMBOL(cfs_range_expr_parse);
 
 /**
  * Matches value (\a value) against ranges expression list \a expr_list.
@@ -341,7 +337,6 @@ cfs_expr_list_match(__u32 value, struct cfs_expr_list *expr_list)
 
 	return 0;
 }
-EXPORT_SYMBOL(cfs_expr_list_match);
 
 /**
  * Convert express list (\a expr_list) to an array of all matched values
@@ -412,18 +407,6 @@ cfs_expr_list_free(struct cfs_expr_list *expr_list)
 }
 EXPORT_SYMBOL(cfs_expr_list_free);
 
-void
-cfs_expr_list_print(struct cfs_expr_list *expr_list)
-{
-	struct cfs_range_expr *expr;
-
-	list_for_each_entry(expr, &expr_list->el_exprs, re_link) {
-		CDEBUG(D_WARNING, "%d-%d/%d\n",
-		       expr->re_lo, expr->re_hi, expr->re_stride);
-	}
-}
-EXPORT_SYMBOL(cfs_expr_list_print);
-
 /**
  * Parses \<cfs_expr_list\> token of the syntax.
  *
@@ -506,7 +489,6 @@ cfs_expr_list_free_list(struct list_head *list)
 		cfs_expr_list_free(el);
 	}
 }
-EXPORT_SYMBOL(cfs_expr_list_free_list);
 
 int
 cfs_ip_addr_parse(char *str, int len, struct list_head *list)
-- 
1.7.7.6

