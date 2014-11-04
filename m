Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaKDOUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:20:51 -0500
Received: from mail.eperm.de ([89.247.134.16]:54282 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbaKDOUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:20:48 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: drbg - add MODULE_ALIAS for all DRBG types
Date: Tue, 04 Nov 2014 03:08:09 +0100
Message-ID: <6130984.PGBGVNdX6r@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel module drbg.ko is currently not loaded automatically when a
DRBG is requested by a consumer. This is due to missing MODULE_ALIAS
flags for each of the implemented DRBG types.

This patch adds aliases for each of the 22 defined DRBGs.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8c0a742..9fb38a5 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -291,6 +291,13 @@ static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 #define CRYPTO_DRBG_CTR_STRING "CTR "
+MODULE_ALIAS("drbg_pr_ctr_aes256");
+MODULE_ALIAS("drbg_nopr_ctr_aes256");
+MODULE_ALIAS("drbg_pr_ctr_aes192");
+MODULE_ALIAS("drbg_nopr_ctr_aes192");
+MODULE_ALIAS("drbg_pr_ctr_aes128");
+MODULE_ALIAS("drbg_nopr_ctr_aes128");
+
 static int drbg_kcapi_sym(struct drbg_state *drbg, const unsigned char *key,
 			  unsigned char *outval, const struct drbg_string *in);
 static int drbg_init_sym_kernel(struct drbg_state *drbg);
@@ -651,6 +658,15 @@ static int drbg_fini_hash_kernel(struct drbg_state *drbg);
 
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 #define CRYPTO_DRBG_HMAC_STRING "HMAC "
+MODULE_ALIAS("drbg_pr_hmac_sha512");
+MODULE_ALIAS("drbg_nopr_hmac_sha512");
+MODULE_ALIAS("drbg_pr_hmac_sha384");
+MODULE_ALIAS("drbg_nopr_hmac_sha384");
+MODULE_ALIAS("drbg_pr_hmac_sha256");
+MODULE_ALIAS("drbg_nopr_hmac_sha256");
+MODULE_ALIAS("drbg_pr_hmac_sha1");
+MODULE_ALIAS("drbg_nopr_hmac_sha1");
+
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 			    int reseed)
@@ -762,6 +778,15 @@ static struct drbg_state_ops drbg_hmac_ops = {
 
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 #define CRYPTO_DRBG_HASH_STRING "HASH "
+MODULE_ALIAS("drbg_pr_sha512");
+MODULE_ALIAS("drbg_nopr_sha512");
+MODULE_ALIAS("drbg_pr_sha384");
+MODULE_ALIAS("drbg_nopr_sha384");
+MODULE_ALIAS("drbg_pr_sha256");
+MODULE_ALIAS("drbg_nopr_sha256");
+MODULE_ALIAS("drbg_pr_sha1");
+MODULE_ALIAS("drbg_nopr_sha1");
+
 /*
  * Increment buffer
  *
-- 
2.1.0


