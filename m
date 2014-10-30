Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaJ3AOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:14:19 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:50618 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbaJ3AOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:14:17 -0400
Date: Wed, 29 Oct 2014 19:12:08 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] staging: skein: Removes skein_debug include
Message-ID: <20141030001207.GA5219@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes skein_debug.h include since skein_debug.h is nonexistent.
Removes unneeded debug empty macro defines and their uses.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_base.c  | 18 -------------
 drivers/staging/skein/skein_base.h  | 17 -------------
 drivers/staging/skein/skein_block.c | 51 +------------------------------------
 3 files changed, 1 insertion(+), 85 deletions(-)

diff --git a/drivers/staging/skein/skein_base.c b/drivers/staging/skein/skein_base.c
index ebc436a..7e700a6 100644
--- a/drivers/staging/skein/skein_base.c
+++ b/drivers/staging/skein/skein_base.c
@@ -124,8 +124,6 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 	cfg.w[2] = skein_swap64(tree_info);
 
-	skein_show_key(256, &ctx->h, key, key_bytes);
-
 	/* compute the initial chaining values from config block */
 	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
@@ -232,8 +230,6 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
@@ -353,8 +349,6 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 	cfg.w[2] = skein_swap64(tree_info);
 
-	skein_show_key(512, &ctx->h, key, key_bytes);
-
 	/* compute the initial chaining values from config block */
 	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
@@ -461,8 +455,6 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(512, &ctx->h, n,
-				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
@@ -577,8 +569,6 @@ int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
 	cfg.w[2] = skein_swap64(tree_info);
 
-	skein_show_key(1024, &ctx->h, key, key_bytes);
-
 	/* compute the initial chaining values from config block */
 	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
@@ -685,8 +675,6 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(1024, &ctx->h, n,
-				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
@@ -794,8 +782,6 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
@@ -833,8 +819,6 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
@@ -872,8 +856,6 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 		/* "output" the ctr mode bytes */
 		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->x,
 				      n);
-		skein_show_final(256, &ctx->h, n,
-				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->x, x, sizeof(x));
 	}
diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index 0111fa4..993b951 100644
--- a/drivers/staging/skein/skein_base.h
+++ b/drivers/staging/skein/skein_base.h
@@ -15,10 +15,6 @@
 **
 ** The "default" note explains what happens when the switch is not defined.
 **
-**  SKEIN_DEBUG            -- make callouts from inside Skein code
-**                            to examine/display intermediate values.
-**                            [default: no callouts (no overhead)]
-**
 **  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
 **                            code. If not defined, most error checking
 **                            is disabled (for performance). Otherwise,
@@ -279,19 +275,6 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 		(hdr).tweak[1] |= SKEIN_T1_TREE_LEVEL(height); \
 	}
 
-/*****************************************************************
-** "Internal" Skein definitions for debugging and error checking
-******************************************************************/
-#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
-#include "skein_debug.h"
-#else                           /* default is no callouts */
-#define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
-#define skein_show_round(bits, ctx, r, x)
-#define skein_show_r_ptr(bits, ctx, r, x_ptr)
-#define skein_show_final(bits, ctx, cnt, out_ptr)
-#define skein_show_key(bits, ctx, key, key_bytes)
-#endif
-
 /* ignore all asserts, for performance */
 #define skein_assert_ret(x, ret_code)
 #define skein_assert(x)
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 36b0b40..66261ab 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -70,7 +70,6 @@ do {                                         \
 #define R256(p0, p1, p2, p3, ROT, r_num) /* fully unrolled */ \
 do {                                                          \
 	ROUND256(p0, p1, p2, p3, ROT, r_num);                 \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, r_num, X_ptr);    \
 } while (0)
 
 #define I256(R)                                                           \
@@ -80,14 +79,12 @@ do {                                                                      \
 	X1   += ks[((R) + 2) % 5] + ts[((R) + 1) % 3];                    \
 	X2   += ks[((R) + 3) % 5] + ts[((R) + 2) % 3];                    \
 	X3   += ks[((R) + 4) % 5] + (R) + 1;                              \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else
 /* looping version */
 #define R256(p0, p1, p2, p3, ROT, r_num) \
 do { \
 	ROUND256(p0, p1, p2, p3, ROT, r_num); \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I256(R) \
@@ -100,7 +97,6 @@ do { \
 	/* rotate key schedule */                                         \
 	ks[r + (R) + 4] = ks[r + (R) - 1];                                \
 	ts[r + (R) + 2] = ts[r + (R) - 1];                                \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #endif
 #define R256_8_ROUNDS(R)                                 \
@@ -160,8 +156,7 @@ do {                                                         \
 #if SKEIN_UNROLL_512 == 0
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) /* unrolled */ \
 do {                                                                    \
-	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)            \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, r_num, X_ptr);              \
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);           \
 } while (0)
 
 #define I512(R)                                                           \
@@ -175,14 +170,12 @@ do {                                                                      \
 	X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3];                    \
 	X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3];                    \
 	X7   += ks[((R) + 8) % 9] + (R) + 1;                              \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 #else /* looping version */
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)                 \
 do {                                                                     \
 	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);            \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I512(R)                                                           \
@@ -199,7 +192,6 @@ do {                                                                      \
 	/* rotate key schedule */                                         \
 	ks[r + (R) + 8] = ks[r + (R) - 1];                                \
 	ts[r + (R) + 2] = ts[r + (R) - 1];                                \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #endif /* end of looped code definitions */
 #define R512_8_ROUNDS(R)  /* do 8 full rounds */                      \
@@ -274,7 +266,6 @@ do {                                                                          \
 do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 		  pF, ROT, rn);                                               \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, rn, X_ptr);                       \
 } while (0)
 
 #define I1024(R)                                                          \
@@ -296,7 +287,6 @@ do {                                                                      \
 	X13 += ks[((R) + 14) % 17] + ts[((R) + 1) % 3];                   \
 	X14 += ks[((R) + 15) % 17] + ts[((R) + 2) % 3];                   \
 	X15 += ks[((R) + 16) % 17] + (R) + 1;                             \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
@@ -304,7 +294,6 @@ do {                                                                      \
 do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 		  pF, ROT, rn);                                               \
-	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, X_ptr);         \
 } while (0)
 
 #define I1024(R)                                                           \
@@ -329,7 +318,6 @@ do {                                                                       \
 	/* rotate key schedule */                                          \
 	ks[r + (R) + 16] = ks[r + (R) - 1];                                \
 	ts[r + (R) + 2] = ts[r + (R) - 1];                                 \
-	skein_show_r_ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 #endif
@@ -413,7 +401,6 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		/* do the first full key injection */
 		X0 = w[0] + ks[0];
@@ -421,10 +408,6 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		X2 = w[2] + ks[2] + ts[1];
 		X3 = w[3] + ks[3];
 
-		/* show starting state values */
-		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 x_ptr);
-
 		blk_ptr += SKEIN_256_BLOCK_BYTES;
 
 		/* run the rounds */
@@ -481,8 +464,6 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		ctx->x[2] = X2 ^ w[2];
 		ctx->x[3] = X3 ^ w[3];
 
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
-
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
 	ctx->h.tweak[0] = ts[0];
@@ -558,7 +539,6 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		/* do the first full key injection */
 		X0 = w[0] + ks[0];
@@ -572,8 +552,6 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 
 		blk_ptr += SKEIN_512_BLOCK_BYTES;
 
-		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 X_ptr);
 		/* run the rounds */
 		for (r = 1;
 			r < (SKEIN_UNROLL_512 ? 2 * RCNT : 2);
@@ -634,7 +612,6 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		ctx->x[5] = X5 ^ w[5];
 		ctx->x[6] = X6 ^ w[6];
 		ctx->x[7] = X7 ^ w[7];
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
@@ -674,26 +651,6 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 	u64  X00, X01, X02, X03, X04, X05, X06, X07,
 	     X08, X09, X10, X11, X12, X13, X14, X15;
 	u64  w[WCNT]; /* local copy of input block */
-#ifdef SKEIN_DEBUG
-	const u64 *X_ptr[16]; /* use for debugging (help cc put Xn in regs) */
-
-	X_ptr[0] = &X00;
-	X_ptr[1] = &X01;
-	X_ptr[2] = &X02;
-	X_ptr[3] = &X03;
-	X_ptr[4] = &X04;
-	X_ptr[5] = &X05;
-	X_ptr[6] = &X06;
-	X_ptr[7] = &X07;
-	X_ptr[8] = &X08;
-	X_ptr[9] = &X09;
-	X_ptr[10] = &X10;
-	X_ptr[11] = &X11;
-	X_ptr[12] = &X12;
-	X_ptr[13] = &X13;
-	X_ptr[14] = &X14;
-	X_ptr[15] = &X15;
-#endif
 
 	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.tweak[0];
@@ -732,7 +689,6 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		/* get input block in little-endian format */
 		skein_get64_lsb_first(w, blk_ptr, WCNT);
 		debug_save_tweak(ctx);
-		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		/* do the first full key injection */
 		X00 = w[0] + ks[0];
@@ -752,9 +708,6 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		X14 = w[14] + ks[14] + ts[1];
 		X15 = w[15] + ks[15];
 
-		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 X_ptr);
-
 		for (r = 1;
 			r < (SKEIN_UNROLL_1024 ? 2 * RCNT : 2);
 			r += (SKEIN_UNROLL_1024 ? 2 * SKEIN_UNROLL_1024 : 1)) {
@@ -821,8 +774,6 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		ctx->x[14] = X14 ^ w[14];
 		ctx->x[15] = X15 ^ w[15];
 
-		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->x);
-
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 		blk_ptr += SKEIN_1024_BLOCK_BYTES;
 	} while (--blk_cnt);
-- 
2.1.1

