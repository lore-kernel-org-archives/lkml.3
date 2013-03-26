Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3CZXN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:13:57 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:46410
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756382Ab3CZXNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:13:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] crypto: caam - change key gen functions to return signed int
Date: Tue, 26 Mar 2013 18:10:14 -0500
Message-ID: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2af8f4a "crypto: caam - coccicheck fixes" added error
return values yet neglected to change the type from unsigned.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
v1 posted here:
http://article.gmane.org/gmane.linux.kernel.cryptoapi/7664
v2: updated commit text with 'coccicheck fixes' commit id.

 drivers/crypto/caam/caamhash.c | 4 ++--
 drivers/crypto/caam/key_gen.c  | 2 +-
 drivers/crypto/caam/key_gen.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 32aba7a..5996521 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -411,7 +411,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	return 0;
 }
 
-static u32 gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
+static int gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			      u32 keylen)
 {
 	return gen_split_key(ctx->jrdev, ctx->key, ctx->split_key_len,
@@ -420,7 +420,7 @@ static u32 gen_split_hash_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 }
 
 /* Digest hash size if it is too large */
-static u32 hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
+static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			   u32 *keylen, u8 *key_out, u32 digestsize)
 {
 	struct device *jrdev = ctx->jrdev;
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index f6dba10..87138d2 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -44,7 +44,7 @@ Split key generation-----------------------------------------------
 [06] 0x64260028    fifostr: class2 mdsplit-jdk len=40
 			@0xffe04000
 */
-u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
+int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		  int split_key_pad_len, const u8 *key_in, u32 keylen,
 		  u32 alg_op)
 {
diff --git a/drivers/crypto/caam/key_gen.h b/drivers/crypto/caam/key_gen.h
index d95d290..c5588f6 100644
--- a/drivers/crypto/caam/key_gen.h
+++ b/drivers/crypto/caam/key_gen.h
@@ -12,6 +12,6 @@ struct split_key_result {
 
 void split_key_done(struct device *dev, u32 *desc, u32 err, void *context);
 
-u32 gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
+int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		    int split_key_pad_len, const u8 *key_in, u32 keylen,
 		    u32 alg_op);
-- 
1.8.1.5


