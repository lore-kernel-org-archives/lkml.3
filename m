Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaJTP2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:28:21 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:60769 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaJTP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:28:19 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix "space prohibited before that close parenthesis ')'" errors
Date: Mon, 20 Oct 2014 10:27:40 -0500
Message-Id: <1413818860-19981-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "space prohibited before that close parenthesis ')'" errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre_capa.h | 2 +-
 drivers/staging/lustre/lustre/llite/dir.c           | 2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c        | 2 +-
 drivers/staging/lustre/lustre/obdclass/capa.c       | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_capa.h b/drivers/staging/lustre/lustre/include/lustre_capa.h
index ab6b9ea..fe19534 100644
--- a/drivers/staging/lustre/lustre/include/lustre_capa.h
+++ b/drivers/staging/lustre/lustre/include/lustre_capa.h
@@ -154,7 +154,7 @@ static inline __u32 capa_expiry(struct lustre_capa *capa)
 }
 
 void _debug_capa(struct lustre_capa *, struct libcfs_debug_msg_data *,
-		 const char *fmt, ... );
+		 const char *fmt, ...);
 #define DEBUG_CAPA(level, capa, fmt, args...)				  \
 do {									   \
 	if (((level) & D_CANTMASK) != 0 ||				     \
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 9e8bfdc..50fef90 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1384,7 +1384,7 @@ lmv_out_free:
 		if (copy_from_user(lumv1, lumv1p, sizeof(*lumv1)))
 			return -EFAULT;
 
-		if ((lumv1->lmm_magic == LOV_USER_MAGIC_V3) ) {
+		if (lumv1->lmm_magic == LOV_USER_MAGIC_V3) {
 			if (copy_from_user(&lumv3, lumv3p, sizeof(lumv3)))
 				return -EFAULT;
 		}
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index d3f967a..168aafb 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -709,7 +709,7 @@ static int vvp_io_fault_start(const struct lu_env *env,
 	}
 
 
-	if (fio->ft_mkwrite ) {
+	if (fio->ft_mkwrite) {
 		pgoff_t last_index;
 		/*
 		 * Capture the size while holding the lli_trunc_sem from above
diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index cd1abce..8d80ea4 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -302,7 +302,7 @@ int capa_encrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 
 	/* passing "aes" in a variable instead of a constant string keeps gcc
 	 * 4.3.2 happy */
-	tfm = crypto_alloc_blkcipher(alg, 0, 0 );
+	tfm = crypto_alloc_blkcipher(alg, 0, 0);
 	if (IS_ERR(tfm)) {
 		CERROR("failed to load transform for aes\n");
 		return PTR_ERR(tfm);
@@ -355,7 +355,7 @@ int capa_decrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 
 	/* passing "aes" in a variable instead of a constant string keeps gcc
 	 * 4.3.2 happy */
-	tfm = crypto_alloc_blkcipher(alg, 0, 0 );
+	tfm = crypto_alloc_blkcipher(alg, 0, 0);
 	if (IS_ERR(tfm)) {
 		CERROR("failed to load transform for aes\n");
 		return PTR_ERR(tfm);
@@ -407,7 +407,7 @@ EXPORT_SYMBOL(capa_cpy);
 
 void _debug_capa(struct lustre_capa *c,
 		 struct libcfs_debug_msg_data *msgdata,
-		 const char *fmt, ... )
+		 const char *fmt, ...)
 {
 	va_list args;
 	va_start(args, fmt);
-- 
1.9.1

