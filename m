Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936070Ab3DINrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:47:41 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54035 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab3DINrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:47:40 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: herbert@gondor.apana.org.a, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] crypto: proc - Clean up
Date: Tue,  9 Apr 2013 16:47:31 +0300
Message-Id: <1365515251-2060-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove trailing whitespaces
Replace seq_puts with seq_printf when there are no extra parameters.
Fix indentation problems

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 crypto/proc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 4a0a7aa..8a22f17 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -8,7 +8,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -80,7 +80,7 @@ static void c_stop(struct seq_file *m, void *p)
 static int c_show(struct seq_file *m, void *p)
 {
 	struct crypto_alg *alg = list_entry(p, struct crypto_alg, cra_list);
-	
+
 	seq_printf(m, "name         : %s\n", alg->cra_name);
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
 	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
@@ -91,7 +91,7 @@ static int c_show(struct seq_file *m, void *p)
 		   "passed" : "unknown");
 
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
-		seq_printf(m, "type         : larval\n");
+		seq_puts(m, "type         : larval\n");
 		seq_printf(m, "flags        : 0x%x\n", alg->cra_flags);
 		goto out;
 	}
@@ -100,10 +100,10 @@ static int c_show(struct seq_file *m, void *p)
 		alg->cra_type->show(m, alg);
 		goto out;
 	}
-	
+
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
-		seq_printf(m, "type         : cipher\n");
+		seq_puts(m, "type         : cipher\n");
 		seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 		seq_printf(m, "min keysize  : %u\n",
 					alg->cra_cipher.cia_min_keysize);
@@ -111,10 +111,10 @@ static int c_show(struct seq_file *m, void *p)
 					alg->cra_cipher.cia_max_keysize);
 		break;
 	case CRYPTO_ALG_TYPE_COMPRESS:
-		seq_printf(m, "type         : compression\n");
+		seq_puts(m, "type         : compression\n");
 		break;
 	default:
-		seq_printf(m, "type         : unknown\n");
+		seq_puts(m, "type         : unknown\n");
 		break;
 	}
 
@@ -134,7 +134,7 @@ static int crypto_info_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &crypto_seq_ops);
 }
-        
+
 static const struct file_operations proc_crypto_ops = {
 	.open		= crypto_info_open,
 	.read		= seq_read,
-- 
1.7.10.4

