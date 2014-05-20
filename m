Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaETOCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:02:32 -0400
Received: from tex.lwn.net ([70.33.254.29]:33382 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaETOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:02:30 -0400
Date: Tue, 20 May 2014 08:02:28 -0600
From: Jake Edge <jake@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: [PATCH 3/3] staging/skein: variable/member name cleanup
Message-ID: <20140520080228.126b8e58@chukar.edge2.net>
In-Reply-To: <20140520075612.220a13ae@chukar.edge2.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename a few more variables and structure member names to lower case.

Signed-off-by: Jake Edge <jake@lwn.net>
---

against staging-next branch of staging tree

 drivers/staging/skein/skein.c       | 148 +++++++++++++++++-----------------
 drivers/staging/skein/skein.h       |  34 ++++----
 drivers/staging/skein/skein_api.c   |  32 ++++----
 drivers/staging/skein/skein_api.h   |   2 +-
 drivers/staging/skein/skein_block.c | 155 ++++++++++++++++++------------------
 5 files changed, 186 insertions(+), 185 deletions(-)

diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index f76d585..8cc8358 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -33,16 +33,16 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  256:
-		memcpy(ctx->X, SKEIN_256_IV_256, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_256_IV_256, sizeof(ctx->x));
 		break;
 	case  224:
-		memcpy(ctx->X, SKEIN_256_IV_224, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_256_IV_224, sizeof(ctx->x));
 		break;
 	case  160:
-		memcpy(ctx->X, SKEIN_256_IV_160, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_256_IV_160, sizeof(ctx->x));
 		break;
 	case  128:
-		memcpy(ctx->X, SKEIN_256_IV_128, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_256_IV_128, sizeof(ctx->x));
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
@@ -63,11 +63,11 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
-	/* The chaining vars ctx->X are now initialized for hash_bit_len. */
+	/* The chaining vars ctx->x are now initialized for hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
 	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -89,25 +89,25 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
-	/* compute the initial chaining values ctx->X[], based on key */
+	/* compute the initial chaining values ctx->x[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		/* hash the key */
 		skein_256_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_256_final_pad(ctx, cfg.b);
-		/* copy over into ctx->X[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
 	}
 	/*
 	 * build/process the config block, type == CONFIG (could be
@@ -130,7 +130,7 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 	/* compute the initial chaining values from config block */
 	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
-	/* The chaining vars ctx->X are now initialized */
+	/* The chaining vars ctx->x are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
 	skein_start_new_type(ctx, MSG);
 
@@ -197,12 +197,12 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_256_STATE_WORDS];
+	u64 x[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -219,7 +219,7 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -231,12 +231,12 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -259,16 +259,16 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  512:
-		memcpy(ctx->X, SKEIN_512_IV_512, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_512_IV_512, sizeof(ctx->x));
 		break;
 	case  384:
-		memcpy(ctx->X, SKEIN_512_IV_384, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_512_IV_384, sizeof(ctx->x));
 		break;
 	case  256:
-		memcpy(ctx->X, SKEIN_512_IV_256, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_512_IV_256, sizeof(ctx->x));
 		break;
 	case  224:
-		memcpy(ctx->X, SKEIN_512_IV_224, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_512_IV_224, sizeof(ctx->x));
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
@@ -289,13 +289,13 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
 	/*
-	 * The chaining vars ctx->X are now initialized for the given
+	 * The chaining vars ctx->x are now initialized for the given
 	 * hash_bit_len.
 	 */
 	/* Set up to process the data message portion of the hash (default) */
@@ -319,25 +319,25 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
-	/* compute the initial chaining values ctx->X[], based on key */
+	/* compute the initial chaining values ctx->x[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		/* hash the key */
 		skein_512_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_512_final_pad(ctx, cfg.b);
-		/* copy over into ctx->X[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
 	}
 	/*
 	 * build/process the config block, type == CONFIG (could be
@@ -359,7 +359,7 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 	/* compute the initial chaining values from config block */
 	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
-	/* The chaining vars ctx->X are now initialized */
+	/* The chaining vars ctx->x are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
 	skein_start_new_type(ctx, MSG);
 
@@ -426,12 +426,12 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_512_STATE_WORDS];
+	u64 x[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -448,7 +448,7 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -460,12 +460,12 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(512, &ctx->h, n,
 				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -488,13 +488,13 @@ int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  512:
-		memcpy(ctx->X, SKEIN_1024_IV_512, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_1024_IV_512, sizeof(ctx->x));
 		break;
 	case  384:
-		memcpy(ctx->X, SKEIN_1024_IV_384, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_1024_IV_384, sizeof(ctx->x));
 		break;
 	case 1024:
-		memcpy(ctx->X, SKEIN_1024_IV_1024, sizeof(ctx->X));
+		memcpy(ctx->x, SKEIN_1024_IV_1024, sizeof(ctx->x));
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
@@ -515,12 +515,12 @@ int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
-	/* The chaining vars ctx->X are now initialized for the hash_bit_len. */
+	/* The chaining vars ctx->x are now initialized for the hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
 	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -542,25 +542,25 @@ int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
-	/* compute the initial chaining values ctx->X[], based on key */
+	/* compute the initial chaining values ctx->x[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 	} else { /* here to pre-process a key */
-		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->x));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->x);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
-		memset(ctx->X, 0, sizeof(ctx->X));
+		memset(ctx->x, 0, sizeof(ctx->x));
 		/* hash the key */
 		skein_1024_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_1024_final_pad(ctx, cfg.b);
-		/* copy over into ctx->X[] */
-		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
+		/* copy over into ctx->x[] */
+		memcpy(ctx->x, cfg.b, sizeof(cfg.b));
 	}
 	/*
 	 * build/process the config block, type == CONFIG (could be
@@ -583,7 +583,7 @@ int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 	/* compute the initial chaining values from config block */
 	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
-	/* The chaining vars ctx->X are now initialized */
+	/* The chaining vars ctx->x are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
 	skein_start_new_type(ctx, MSG);
 
@@ -650,12 +650,12 @@ int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
 int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_1024_STATE_WORDS];
+	u64 x[SKEIN_1024_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -672,7 +672,7 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -684,12 +684,12 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_1024_BLOCK_BYTES)
 			n  = SKEIN_1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(1024, &ctx->h, n,
 				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -705,7 +705,7 @@ int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -714,7 +714,7 @@ int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_256_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_256_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -727,7 +727,7 @@ int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -736,7 +736,7 @@ int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_512_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_512_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -749,7 +749,7 @@ int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
-	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
+	ctx->h.tweak[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
 	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
@@ -758,7 +758,7 @@ int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
 	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_1024_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->x, SKEIN_1024_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -769,7 +769,7 @@ int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
 int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_256_STATE_WORDS];
+	u64 x[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
@@ -781,7 +781,7 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -793,12 +793,12 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -808,7 +808,7 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_512_STATE_WORDS];
+	u64 x[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
@@ -820,7 +820,7 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -832,12 +832,12 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
@@ -847,7 +847,7 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN_1024_STATE_WORDS];
+	u64 x[SKEIN_1024_STATE_WORDS];
 	/* catch uninitialized context */
 	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
@@ -859,7 +859,7 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
-	memcpy(X, ctx->X, sizeof(X));
+	memcpy(x, ctx->x, sizeof(x));
 	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
@@ -871,12 +871,12 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_1024_BLOCK_BYTES)
 			n  = SKEIN_1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
 				      n);
 		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
-		memcpy(ctx->X, X, sizeof(X));
+		memcpy(ctx->x, x, sizeof(x));
 	}
 	return SKEIN_SUCCESS;
 }
diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein.h
index 2c87ff7..e6669f1 100644
--- a/drivers/staging/skein/skein.h
+++ b/drivers/staging/skein/skein.h
@@ -66,24 +66,24 @@ enum {
 struct skein_ctx_hdr {
 	size_t hash_bit_len;		/* size of hash result, in bits */
 	size_t b_cnt;			/* current byte count in buffer b[] */
-	u64 T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
+	u64 tweak[SKEIN_MODIFIER_WORDS]; /* tweak[0]=byte cnt, tweak[1]=flags */
 };
 
 struct skein_256_ctx { /* 256-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 X[SKEIN_256_STATE_WORDS];	/* chaining variables */
+	u64 x[SKEIN_256_STATE_WORDS];	/* chaining variables */
 	u8 b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 struct skein_512_ctx { /* 512-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 X[SKEIN_512_STATE_WORDS];	/* chaining variables */
+	u64 x[SKEIN_512_STATE_WORDS];	/* chaining variables */
 	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 X[SKEIN_1024_STATE_WORDS];	/* chaining variables */
+	u64 x[SKEIN_1024_STATE_WORDS];	/* chaining variables */
 	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
@@ -150,7 +150,7 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 **           reference and optimized code.
 ******************************************************************/
 
-/* tweak word T[1]: bit field starting positions */
+/* tweak word tweak[1]: bit field starting positions */
 #define SKEIN_T1_BIT(BIT)       ((BIT) - 64)      /* second word  */
 
 #define SKEIN_T1_POS_TREE_LVL   SKEIN_T1_BIT(112) /* 112..118 hash tree level */
@@ -159,16 +159,16 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 #define SKEIN_T1_POS_FIRST      SKEIN_T1_BIT(126) /* 126      first blk flag */
 #define SKEIN_T1_POS_FINAL      SKEIN_T1_BIT(127) /* 127      final blk flag */
 
-/* tweak word T[1]: flag bit definition(s) */
+/* tweak word tweak[1]: flag bit definition(s) */
 #define SKEIN_T1_FLAG_FIRST     (((u64)  1) << SKEIN_T1_POS_FIRST)
 #define SKEIN_T1_FLAG_FINAL     (((u64)  1) << SKEIN_T1_POS_FINAL)
 #define SKEIN_T1_FLAG_BIT_PAD   (((u64)  1) << SKEIN_T1_POS_BIT_PAD)
 
-/* tweak word T[1]: tree level bit field mask */
+/* tweak word tweak[1]: tree level bit field mask */
 #define SKEIN_T1_TREE_LVL_MASK  (((u64)0x7F) << SKEIN_T1_POS_TREE_LVL)
 #define SKEIN_T1_TREE_LEVEL(n)  (((u64) (n)) << SKEIN_T1_POS_TREE_LVL)
 
-/* tweak word T[1]: block type field */
+/* tweak word tweak[1]: block type field */
 #define SKEIN_BLK_TYPE_KEY       (0) /* key, for MAC and KDF */
 #define SKEIN_BLK_TYPE_CFG       (4) /* configuration block */
 #define SKEIN_BLK_TYPE_PERS      (8) /* personalization string */
@@ -232,9 +232,9 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 **   Skein macros for getting/setting tweak words, etc.
 **   These are useful for partial input bytes, hash tree init/update, etc.
 **/
-#define skein_get_tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.T[TWK_NUM])
+#define skein_get_tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.tweak[TWK_NUM])
 #define skein_set_tweak(ctx_ptr, TWK_NUM, t_val) { \
-		(ctx_ptr)->h.T[TWK_NUM] = (t_val); \
+		(ctx_ptr)->h.tweak[TWK_NUM] = (t_val); \
 	}
 
 #define skein_get_T0(ctx_ptr)     skein_get_tweak(ctx_ptr, 0)
@@ -254,7 +254,7 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 
 /*
  * setup for starting with a new type:
- * h.T[0]=0; h.T[1] = NEW_TYPE; h.b_cnt=0;
+ * h.tweak[0]=0; h.tweak[1] = NEW_TYPE; h.b_cnt=0;
  */
 #define skein_start_new_type(ctx_ptr, BLK_TYPE) { \
 		skein_set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
@@ -263,14 +263,14 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 	}
 
 #define skein_clear_first_flag(hdr) { \
-		(hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST; \
+		(hdr).tweak[1] &= ~SKEIN_T1_FLAG_FIRST; \
 	}
 #define skein_set_bit_pad_flag(hdr) { \
-		(hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
+		(hdr).tweak[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
 	}
 
 #define skein_set_tree_level(hdr, height) { \
-		(hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); \
+		(hdr).tweak[1] |= SKEIN_T1_TREE_LEVEL(height); \
 	}
 
 /*****************************************************************
@@ -279,9 +279,9 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 #ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
 #include "skein_debug.h"
 #else                           /* default is no callouts */
-#define skein_show_block(bits, ctx, X, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
-#define skein_show_round(bits, ctx, r, X)
-#define skein_show_r_ptr(bits, ctx, r, X_ptr)
+#define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
+#define skein_show_round(bits, ctx, r, x)
+#define skein_show_r_ptr(bits, ctx, r, x_ptr)
 #define skein_show_final(bits, ctx, cnt, out_ptr)
 #define skein_show_key(bits, ctx, key, key_bytes)
 #endif
diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
index eaf7af4..6e700ee 100644
--- a/drivers/staging/skein/skein_api.c
+++ b/drivers/staging/skein/skein_api.c
@@ -40,8 +40,8 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 {
 	int ret = SKEIN_FAIL;
-	size_t X_len = 0;
-	u64 *X = NULL;
+	size_t x_len = 0;
+	u64 *x = NULL;
 	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
 	skein_assert_ret(ctx, SKEIN_FAIL);
@@ -50,8 +50,8 @@ int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 	 * contexts are a union in out context and thus have tha maximum
 	 * memory available.  The beauty of C :-) .
 	 */
-	X = ctx->m.s256.X;
-	X_len = ctx->skein_size/8;
+	x = ctx->m.s256.x;
+	x_len = ctx->skein_size/8;
 	/*
 	 * If size is the same and hash bit length is zero then reuse
 	 * the save chaining variables.
@@ -76,7 +76,7 @@ int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 		 * Save chaining variables for this combination of size and
 		 * hash_bit_len
 		 */
-		memcpy(ctx->X_save, X, X_len);
+		memcpy(ctx->x_save, x, x_len);
 	}
 	return ret;
 }
@@ -85,14 +85,14 @@ int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
 		   size_t hash_bit_len)
 {
 	int ret = SKEIN_FAIL;
-	u64 *X = NULL;
-	size_t X_len = 0;
+	u64 *x = NULL;
+	size_t x_len = 0;
 	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
 	skein_assert_ret(ctx, SKEIN_FAIL);
 
-	X = ctx->m.s256.X;
-	X_len = ctx->skein_size/8;
+	x = ctx->m.s256.x;
+	x_len = ctx->skein_size/8;
 
 	skein_assert_ret(hash_bit_len, SKEIN_BAD_HASHLEN);
 
@@ -120,25 +120,25 @@ int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
 		 * Save chaining variables for this combination of key,
 		 * key_len, hash_bit_len
 		 */
-		memcpy(ctx->X_save, X, X_len);
+		memcpy(ctx->x_save, x, x_len);
 	}
 	return ret;
 }
 
 void skein_reset(struct skein_ctx *ctx)
 {
-	size_t X_len = 0;
-	u64 *X = NULL;
+	size_t x_len = 0;
+	u64 *x = NULL;
 
 	/*
 	 * The following two lines rely of the fact that the real Skein
 	 * contexts are a union in out context and thus have tha maximum
 	 * memory available.  The beautiy of C :-) .
 	 */
-	X = ctx->m.s256.X;
-	X_len = ctx->skein_size/8;
+	x = ctx->m.s256.x;
+	x_len = ctx->skein_size/8;
 	/* Restore the chaing variable, reset byte counter */
-	memcpy(X, ctx->X_save, X_len);
+	memcpy(x, ctx->x_save, x_len);
 
 	/* Setup context to process the message */
 	skein_start_new_type(&ctx->m, MSG);
@@ -200,7 +200,7 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 	 * Skein's real partial block buffer.
 	 * If this layout ever changes we have to adapt this as well.
 	 */
-	up = (u8 *)ctx->m.s256.X + ctx->skein_size / 8;
+	up = (u8 *)ctx->m.s256.x + ctx->skein_size / 8;
 
 	/* set tweak flag for the skein_final call */
 	skein_set_bit_pad_flag(ctx->m.h);
diff --git a/drivers/staging/skein/skein_api.h b/drivers/staging/skein/skein_api.h
index db808ae..e02fa19 100644
--- a/drivers/staging/skein/skein_api.h
+++ b/drivers/staging/skein/skein_api.h
@@ -100,7 +100,7 @@ enum skein_size {
  */
 struct skein_ctx {
 	u64 skein_size;
-	u64 X_save[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
+	u64 x_save[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
 	union {
 		struct skein_ctx_hdr h;
 		struct skein_256_ctx s256;
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 76c4113e..f49eb2e 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -32,7 +32,8 @@
 #define ts              (kw + KW_TWK_BASE)
 
 #ifdef SKEIN_DEBUG
-#define debug_save_tweak(ctx) { ctx->h.T[0] = ts[0]; ctx->h.T[1] = ts[1]; }
+#define debug_save_tweak(ctx) { \
+                        ctx->h.tweak[0] = ts[0]; ctx->h.tweak[1] = ts[1]; }
 #else
 #define debug_save_tweak(ctx)
 #endif
@@ -71,8 +72,8 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
 #endif
 	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	ts[0] = ctx->h.T[0];
-	ts[1] = ctx->h.T[1];
+	ts[0] = ctx->h.tweak[0];
+	ts[1] = ctx->h.tweak[1];
 	do  {
 		/*
 		 * this implementation only supports 2**64 input bytes
@@ -81,10 +82,10 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
-		ks[0] = ctx->X[0];
-		ks[1] = ctx->X[1];
-		ks[2] = ctx->X[2];
-		ks[3] = ctx->X[3];
+		ks[0] = ctx->x[0];
+		ks[1] = ctx->x[1];
+		ks[2] = ctx->x[2];
+		ks[3] = ctx->x[3];
 		ks[4] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^ SKEIN_KS_PARITY;
 
 		ts[2] = ts[0] ^ ts[1];
@@ -92,7 +93,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		X0 = w[0] + ks[0]; /* do the first full key injection */
 		X1 = w[1] + ks[1] + ts[0];
@@ -101,7 +102,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 
 		/* show starting state values */
 		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 X_ptr);
+				 x_ptr);
 
 		blk_ptr += SKEIN_256_BLOCK_BYTES;
 
@@ -220,17 +221,17 @@ do { \
 	#endif
 		}
 		/* do the final "feedforward" xor, update context chaining */
-		ctx->X[0] = X0 ^ w[0];
-		ctx->X[1] = X1 ^ w[1];
-		ctx->X[2] = X2 ^ w[2];
-		ctx->X[3] = X3 ^ w[3];
+		ctx->x[0] = X0 ^ w[0];
+		ctx->x[1] = X1 ^ w[1];
+		ctx->x[2] = X2 ^ w[2];
+		ctx->x[3] = X3 ^ w[3];
 
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
-	ctx->h.T[0] = ts[0];
-	ctx->h.T[1] = ts[1];
+	ctx->h.tweak[0] = ts[0];
+	ctx->h.tweak[1] = ts[1];
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
@@ -282,8 +283,8 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 #endif
 
 	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	ts[0] = ctx->h.T[0];
-	ts[1] = ctx->h.T[1];
+	ts[0] = ctx->h.tweak[0];
+	ts[1] = ctx->h.tweak[1];
 	do  {
 		/*
 		 * this implementation only supports 2**64 input bytes
@@ -292,14 +293,14 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
-		ks[0] = ctx->X[0];
-		ks[1] = ctx->X[1];
-		ks[2] = ctx->X[2];
-		ks[3] = ctx->X[3];
-		ks[4] = ctx->X[4];
-		ks[5] = ctx->X[5];
-		ks[6] = ctx->X[6];
-		ks[7] = ctx->X[7];
+		ks[0] = ctx->x[0];
+		ks[1] = ctx->x[1];
+		ks[2] = ctx->x[2];
+		ks[3] = ctx->x[3];
+		ks[4] = ctx->x[4];
+		ks[5] = ctx->x[5];
+		ks[6] = ctx->x[6];
+		ks[7] = ctx->x[7];
 		ks[8] = ks[0] ^ ks[1] ^ ks[2] ^ ks[3] ^
 			ks[4] ^ ks[5] ^ ks[6] ^ ks[7] ^ SKEIN_KS_PARITY;
 
@@ -308,7 +309,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		X0   = w[0] + ks[0]; /* do the first full key injection */
 		X1   = w[1] + ks[1];
@@ -448,20 +449,20 @@ do { \
 		}
 
 		/* do the final "feedforward" xor, update context chaining */
-		ctx->X[0] = X0 ^ w[0];
-		ctx->X[1] = X1 ^ w[1];
-		ctx->X[2] = X2 ^ w[2];
-		ctx->X[3] = X3 ^ w[3];
-		ctx->X[4] = X4 ^ w[4];
-		ctx->X[5] = X5 ^ w[5];
-		ctx->X[6] = X6 ^ w[6];
-		ctx->X[7] = X7 ^ w[7];
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		ctx->x[0] = X0 ^ w[0];
+		ctx->x[1] = X1 ^ w[1];
+		ctx->x[2] = X2 ^ w[2];
+		ctx->x[3] = X3 ^ w[3];
+		ctx->x[4] = X4 ^ w[4];
+		ctx->x[5] = X5 ^ w[5];
+		ctx->x[6] = X6 ^ w[6];
+		ctx->x[7] = X7 ^ w[7];
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
-	ctx->h.T[0] = ts[0];
-	ctx->h.T[1] = ts[1];
+	ctx->h.tweak[0] = ts[0];
+	ctx->h.tweak[1] = ts[1];
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
@@ -520,8 +521,8 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 #endif
 
 	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
-	ts[0] = ctx->h.T[0];
-	ts[1] = ctx->h.T[1];
+	ts[0] = ctx->h.tweak[0];
+	ts[1] = ctx->h.tweak[1];
 	do  {
 		/*
 		 * this implementation only supports 2**64 input bytes
@@ -530,22 +531,22 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
-		ks[0]  = ctx->X[0];
-		ks[1]  = ctx->X[1];
-		ks[2]  = ctx->X[2];
-		ks[3]  = ctx->X[3];
-		ks[4]  = ctx->X[4];
-		ks[5]  = ctx->X[5];
-		ks[6]  = ctx->X[6];
-		ks[7]  = ctx->X[7];
-		ks[8]  = ctx->X[8];
-		ks[9]  = ctx->X[9];
-		ks[10] = ctx->X[10];
-		ks[11] = ctx->X[11];
-		ks[12] = ctx->X[12];
-		ks[13] = ctx->X[13];
-		ks[14] = ctx->X[14];
-		ks[15] = ctx->X[15];
+		ks[0]  = ctx->x[0];
+		ks[1]  = ctx->x[1];
+		ks[2]  = ctx->x[2];
+		ks[3]  = ctx->x[3];
+		ks[4]  = ctx->x[4];
+		ks[5]  = ctx->x[5];
+		ks[6]  = ctx->x[6];
+		ks[7]  = ctx->x[7];
+		ks[8]  = ctx->x[8];
+		ks[9]  = ctx->x[9];
+		ks[10] = ctx->x[10];
+		ks[11] = ctx->x[11];
+		ks[12] = ctx->x[12];
+		ks[13] = ctx->x[13];
+		ks[14] = ctx->x[14];
+		ks[15] = ctx->x[15];
 		ks[16] =  ks[0] ^  ks[1] ^  ks[2] ^  ks[3] ^
 			  ks[4] ^  ks[5] ^  ks[6] ^  ks[7] ^
 			  ks[8] ^  ks[9] ^ ks[10] ^ ks[11] ^
@@ -556,7 +557,7 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		X00    =  w[0] +  ks[0]; /* do the first full key injection */
 		X01    =  w[1] +  ks[1];
@@ -735,30 +736,30 @@ do { \
 		}
 		/* do the final "feedforward" xor, update context chaining */
 
-		ctx->X[0] = X00 ^ w[0];
-		ctx->X[1] = X01 ^ w[1];
-		ctx->X[2] = X02 ^ w[2];
-		ctx->X[3] = X03 ^ w[3];
-		ctx->X[4] = X04 ^ w[4];
-		ctx->X[5] = X05 ^ w[5];
-		ctx->X[6] = X06 ^ w[6];
-		ctx->X[7] = X07 ^ w[7];
-		ctx->X[8] = X08 ^ w[8];
-		ctx->X[9] = X09 ^ w[9];
-		ctx->X[10] = X10 ^ w[10];
-		ctx->X[11] = X11 ^ w[11];
-		ctx->X[12] = X12 ^ w[12];
-		ctx->X[13] = X13 ^ w[13];
-		ctx->X[14] = X14 ^ w[14];
-		ctx->X[15] = X15 ^ w[15];
-
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		ctx->x[0] = X00 ^ w[0];
+		ctx->x[1] = X01 ^ w[1];
+		ctx->x[2] = X02 ^ w[2];
+		ctx->x[3] = X03 ^ w[3];
+		ctx->x[4] = X04 ^ w[4];
+		ctx->x[5] = X05 ^ w[5];
+		ctx->x[6] = X06 ^ w[6];
+		ctx->x[7] = X07 ^ w[7];
+		ctx->x[8] = X08 ^ w[8];
+		ctx->x[9] = X09 ^ w[9];
+		ctx->x[10] = X10 ^ w[10];
+		ctx->x[11] = X11 ^ w[11];
+		ctx->x[12] = X12 ^ w[12];
+		ctx->x[13] = X13 ^ w[13];
+		ctx->x[14] = X14 ^ w[14];
+		ctx->x[15] = X15 ^ w[15];
+
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 		blk_ptr += SKEIN_1024_BLOCK_BYTES;
 	} while (--blk_cnt);
-	ctx->h.T[0] = ts[0];
-	ctx->h.T[1] = ts[1];
+	ctx->h.tweak[0] = ts[0];
+	ctx->h.tweak[1] = ts[1];
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
-- 
1.9.0



-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
