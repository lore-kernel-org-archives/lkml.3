Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaCENbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:31:23 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50795 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaCENbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:31:21 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 4/6] staging/lustre/libcfs: remove cfs_iswhite
Date: Wed,  5 Mar 2014 21:27:18 +0800
Message-Id: <1394026040-1968-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1394026040-1968-3-git-send-email-bergwolf@gmail.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-3-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel provides isspace().

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_string.h    |   15 ---------------
 drivers/staging/lustre/lnet/lnet/config.c          |   12 ++++++------
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   10 +++++-----
 3 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
index 83b7f42..73c251f 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
@@ -90,21 +90,6 @@ struct cfs_expr_list {
 	struct list_head	el_exprs;
 };
 
-static inline int
-cfs_iswhite(char c)
-{
-	switch (c) {
-	case ' ':
-	case '\t':
-	case '\n':
-	case '\r':
-		return 1;
-	default:
-		break;
-	}
-	return 0;
-}
-
 char *cfs_trimwhite(char *str);
 int cfs_gettok(struct cfs_lstr *next, char delim, struct cfs_lstr *res);
 int cfs_str2num_check(char *str, int nob, unsigned *num,
diff --git a/drivers/staging/lustre/lnet/lnet/config.c b/drivers/staging/lustre/lnet/lnet/config.c
index 6a07b0a..d97464e 100644
--- a/drivers/staging/lustre/lnet/lnet/config.c
+++ b/drivers/staging/lustre/lnet/lnet/config.c
@@ -443,7 +443,7 @@ lnet_str2tbs_sep(struct list_head *tbs, char *str)
 	/* Split 'str' into separate commands */
 	for (;;) {
 		/* skip leading whitespace */
-		while (cfs_iswhite(*str))
+		while (isspace(*str))
 			str++;
 
 		/* scan for separator or comment */
@@ -460,7 +460,7 @@ lnet_str2tbs_sep(struct list_head *tbs, char *str)
 			}
 
 			for (i = 0; i < nob; i++)
-				if (cfs_iswhite(str[i]))
+				if (isspace(str[i]))
 					ltb->ltb_text[i] = ' ';
 				else
 					ltb->ltb_text[i] = str[i];
@@ -667,7 +667,7 @@ lnet_parse_route(char *str, int *im_a_router)
 	sep = str;
 	for (;;) {
 		/* scan for token start */
-		while (cfs_iswhite(*sep))
+		while (isspace(*sep))
 			sep++;
 		if (*sep == 0) {
 			if (ntokens < (got_hops ? 3 : 2))
@@ -679,7 +679,7 @@ lnet_parse_route(char *str, int *im_a_router)
 		token = sep++;
 
 		/* scan for token end */
-		while (*sep != 0 && !cfs_iswhite(*sep))
+		while (*sep != 0 && !isspace(*sep))
 			sep++;
 		if (*sep != 0)
 			*sep++ = 0;
@@ -858,7 +858,7 @@ lnet_match_network_tokens(char *net_entry, __u32 *ipaddrs, int nip)
 	sep = tokens;
 	for (;;) {
 		/* scan for token start */
-		while (cfs_iswhite(*sep))
+		while (isspace(*sep))
 			sep++;
 		if (*sep == 0)
 			break;
@@ -866,7 +866,7 @@ lnet_match_network_tokens(char *net_entry, __u32 *ipaddrs, int nip)
 		token = sep++;
 
 		/* scan for token end */
-		while (*sep != 0 && !cfs_iswhite(*sep))
+		while (*sep != 0 && !isspace(*sep))
 			sep++;
 		if (*sep != 0)
 			*sep++ = 0;
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index b9ed2a89..ed0a6b5 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -143,12 +143,12 @@ cfs_trimwhite(char *str)
 {
 	char *end;
 
-	while (cfs_iswhite(*str))
+	while (isspace(*str))
 		str++;
 
 	end = str + strlen(str);
 	while (end > str) {
-		if (!cfs_iswhite(end[-1]))
+		if (!isspace(end[-1]))
 			break;
 		end--;
 	}
@@ -178,7 +178,7 @@ cfs_gettok(struct cfs_lstr *next, char delim, struct cfs_lstr *res)
 
 	/* skip leading white spaces */
 	while (next->ls_len) {
-		if (!cfs_iswhite(*next->ls_str))
+		if (!isspace(*next->ls_str))
 			break;
 		next->ls_str++;
 		next->ls_len--;
@@ -205,7 +205,7 @@ cfs_gettok(struct cfs_lstr *next, char delim, struct cfs_lstr *res)
 
 	/* skip ending whitespaces */
 	while (--end != res->ls_str) {
-		if (!cfs_iswhite(*end))
+		if (!isspace(*end))
 			break;
 	}
 
@@ -234,7 +234,7 @@ cfs_str2num_check(char *str, int nob, unsigned *num,
 		return 0;
 
 	for (; endp < str + nob; endp++) {
-		if (!cfs_iswhite(*endp))
+		if (!isspace(*endp))
 			return 0;
 	}
 
-- 
1.7.7.6

