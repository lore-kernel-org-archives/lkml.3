Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaESEMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:12:38 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53854 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaESEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:05 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/06] staging: crypto: skein: rename macros
Date: Mon, 19 May 2014 12:09:58 +0400
Message-Id: <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
 <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixing upper and lower case in names of macros like It_Is_Macro is
not accepted in the Linux Kernel. To prepare skein driver for mainline
inclusion, we rename all macros to uppercase or lowercase names.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/include/skein.h        |  75 +++----
 drivers/staging/skein/include/skein_iv.h     |   6 +-
 drivers/staging/skein/include/threefishApi.h |   2 +-
 drivers/staging/skein/skein.c                | 262 +++++++++++------------
 drivers/staging/skein/skeinApi.c             |  22 +-
 drivers/staging/skein/skeinBlockNo3F.c       |  20 +-
 drivers/staging/skein/skein_block.c          | 308 +++++++++++++--------------
 drivers/staging/skein/threefishApi.c         |  10 +-
 8 files changed, 353 insertions(+), 352 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 8ecd720..2c87ff7 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -28,15 +28,15 @@
 **
 ***************************************************************************/
 
-#ifndef RotL_64
-#define RotL_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
+#ifndef rotl_64
+#define rotl_64(x, N)    (((x) << (N)) | ((x) >> (64-(N))))
 #endif
 
 /* below two prototype assume we are handed aligned data */
-#define Skein_Put64_LSB_First(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
-#define Skein_Get64_LSB_First(dst64, src08, w_cnt) \
+#define skein_put64_lsb_first(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
+#define skein_get64_lsb_first(dst64, src08, w_cnt) \
 		memcpy(dst64, src08, 8*(w_cnt))
-#define Skein_Swap64(w64)  (w64)
+#define skein_swap64(w64)  (w64)
 
 enum {
 	SKEIN_SUCCESS         =      0, /* return codes from Skein calls */
@@ -48,20 +48,20 @@ enum {
 
 #define  SKEIN_256_STATE_WORDS  (4)
 #define  SKEIN_512_STATE_WORDS  (8)
-#define  SKEIN1024_STATE_WORDS (16)
+#define  SKEIN_1024_STATE_WORDS (16)
 #define  SKEIN_MAX_STATE_WORDS (16)
 
 #define  SKEIN_256_STATE_BYTES  (8*SKEIN_256_STATE_WORDS)
 #define  SKEIN_512_STATE_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_STATE_BYTES  (8*SKEIN1024_STATE_WORDS)
+#define  SKEIN_1024_STATE_BYTES  (8*SKEIN_1024_STATE_WORDS)
 
 #define  SKEIN_256_STATE_BITS  (64*SKEIN_256_STATE_WORDS)
 #define  SKEIN_512_STATE_BITS  (64*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_STATE_BITS  (64*SKEIN1024_STATE_WORDS)
+#define  SKEIN_1024_STATE_BITS  (64*SKEIN_1024_STATE_WORDS)
 
 #define  SKEIN_256_BLOCK_BYTES  (8*SKEIN_256_STATE_WORDS)
 #define  SKEIN_512_BLOCK_BYTES  (8*SKEIN_512_STATE_WORDS)
-#define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
+#define  SKEIN_1024_BLOCK_BYTES  (8*SKEIN_1024_STATE_WORDS)
 
 struct skein_ctx_hdr {
 	size_t hash_bit_len;		/* size of hash result, in bits */
@@ -83,8 +83,8 @@ struct skein_512_ctx { /* 512-bit Skein hash context structure */
 
 struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64 X[SKEIN1024_STATE_WORDS];	/* chaining variables */
-	u8 b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+	u64 X[SKEIN_1024_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 /* Skein APIs for (incremental) "straight hashing" */
@@ -232,44 +232,44 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 **   Skein macros for getting/setting tweak words, etc.
 **   These are useful for partial input bytes, hash tree init/update, etc.
 **/
-#define Skein_Get_Tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.T[TWK_NUM])
-#define Skein_Set_Tweak(ctx_ptr, TWK_NUM, t_val) { \
+#define skein_get_tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.T[TWK_NUM])
+#define skein_set_tweak(ctx_ptr, TWK_NUM, t_val) { \
 		(ctx_ptr)->h.T[TWK_NUM] = (t_val); \
 	}
 
-#define Skein_Get_T0(ctx_ptr)     Skein_Get_Tweak(ctx_ptr, 0)
-#define Skein_Get_T1(ctx_ptr)     Skein_Get_Tweak(ctx_ptr, 1)
-#define Skein_Set_T0(ctx_ptr, T0) Skein_Set_Tweak(ctx_ptr, 0, T0)
-#define Skein_Set_T1(ctx_ptr, T1) Skein_Set_Tweak(ctx_ptr, 1, T1)
+#define skein_get_T0(ctx_ptr)     skein_get_tweak(ctx_ptr, 0)
+#define skein_get_T1(ctx_ptr)     skein_get_tweak(ctx_ptr, 1)
+#define skein_set_T0(ctx_ptr, T0) skein_set_tweak(ctx_ptr, 0, T0)
+#define skein_set_T1(ctx_ptr, T1) skein_set_tweak(ctx_ptr, 1, T1)
 
 /* set both tweak words at once */
-#define Skein_Set_T0_T1(ctx_ptr, T0, T1)           \
-	{                                           \
-	Skein_Set_T0(ctx_ptr, (T0));                  \
-	Skein_Set_T1(ctx_ptr, (T1));                  \
+#define skein_set_T0_T1(ctx_ptr, T0, T1)           \
+	{                                          \
+	skein_set_T0(ctx_ptr, (T0));               \
+	skein_set_T1(ctx_ptr, (T1));               \
 	}
 
-#define Skein_Set_Type(ctx_ptr, BLK_TYPE)         \
-	Skein_Set_T1(ctx_ptr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+#define skein_set_type(ctx_ptr, BLK_TYPE)         \
+	skein_set_T1(ctx_ptr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
 
 /*
  * setup for starting with a new type:
  * h.T[0]=0; h.T[1] = NEW_TYPE; h.b_cnt=0;
  */
-#define Skein_Start_New_Type(ctx_ptr, BLK_TYPE) { \
-		Skein_Set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
+#define skein_start_new_type(ctx_ptr, BLK_TYPE) { \
+		skein_set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
 				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
 		(ctx_ptr)->h.b_cnt = 0; \
 	}
 
-#define Skein_Clear_First_Flag(hdr) { \
+#define skein_clear_first_flag(hdr) { \
 		(hdr).T[1] &= ~SKEIN_T1_FLAG_FIRST; \
 	}
-#define Skein_Set_Bit_Pad_Flag(hdr) { \
+#define skein_set_bit_pad_flag(hdr) { \
 		(hdr).T[1] |=  SKEIN_T1_FLAG_BIT_PAD; \
 	}
 
-#define Skein_Set_Tree_Level(hdr, height) { \
+#define skein_set_tree_level(hdr, height) { \
 		(hdr).T[1] |= SKEIN_T1_TREE_LEVEL(height); \
 	}
 
@@ -279,15 +279,16 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 #ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
 #include "skein_debug.h"
 #else                           /* default is no callouts */
-#define Skein_Show_Block(bits, ctx, X, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
-#define Skein_Show_Round(bits, ctx, r, X)
-#define Skein_Show_R_Ptr(bits, ctx, r, X_ptr)
-#define Skein_Show_Final(bits, ctx, cnt, out_ptr)
-#define Skein_Show_Key(bits, ctx, key, key_bytes)
+#define skein_show_block(bits, ctx, X, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
+#define skein_show_round(bits, ctx, r, X)
+#define skein_show_r_ptr(bits, ctx, r, X_ptr)
+#define skein_show_final(bits, ctx, cnt, out_ptr)
+#define skein_show_key(bits, ctx, key, key_bytes)
 #endif
 
-#define Skein_Assert(x, ret_code)/* ignore all Asserts, for performance */
-#define Skein_assert(x)
+/* ignore all asserts, for performance */
+#define skein_assert_ret(x, ret_code)
+#define skein_assert(x)
 
 /*****************************************************************
 ** Skein block function constants (shared across Ref and Opt code)
@@ -335,11 +336,11 @@ enum {
 #ifndef SKEIN_ROUNDS
 #define SKEIN_256_ROUNDS_TOTAL (72)	/* # rounds for diff block sizes */
 #define SKEIN_512_ROUNDS_TOTAL (72)
-#define SKEIN1024_ROUNDS_TOTAL (80)
+#define SKEIN_1024_ROUNDS_TOTAL (80)
 #else			/* allow command-line define in range 8*(5..14)   */
 #define SKEIN_256_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/100) + 5) % 10) + 5))
 #define SKEIN_512_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS/10)  + 5) % 10) + 5))
-#define SKEIN1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
+#define SKEIN_1024_ROUNDS_TOTAL (8*((((SKEIN_ROUNDS)     + 5) % 10) + 5))
 #endif
 
 #endif  /* ifndef _SKEIN_H_ */
diff --git a/drivers/staging/skein/include/skein_iv.h b/drivers/staging/skein/include/skein_iv.h
index 8dd5e4d..7ff93df 100644
--- a/drivers/staging/skein/include/skein_iv.h
+++ b/drivers/staging/skein/include/skein_iv.h
@@ -124,7 +124,7 @@ const u64 SKEIN_512_IV_512[] = {
 };
 
 /* blkSize = 1024 bits. hashSize =  384 bits */
-const u64 SKEIN1024_IV_384[] = {
+const u64 SKEIN_1024_IV_384[] = {
 	MK_64(0x5102B6B8, 0xC1894A35),
 	MK_64(0xFEEBC9E3, 0xFE8AF11A),
 	MK_64(0x0C807F06, 0xE32BED71),
@@ -144,7 +144,7 @@ const u64 SKEIN1024_IV_384[] = {
 };
 
 /* blkSize = 1024 bits. hashSize =  512 bits */
-const u64 SKEIN1024_IV_512[] = {
+const u64 SKEIN_1024_IV_512[] = {
 	MK_64(0xCAEC0E5D, 0x7C1B1B18),
 	MK_64(0xA01B0E04, 0x5F03E802),
 	MK_64(0x33840451, 0xED912885),
@@ -164,7 +164,7 @@ const u64 SKEIN1024_IV_512[] = {
 };
 
 /* blkSize = 1024 bits. hashSize = 1024 bits */
-const u64 SKEIN1024_IV_1024[] = {
+const u64 SKEIN_1024_IV_1024[] = {
 	MK_64(0xD593DA07, 0x41E72355),
 	MK_64(0x15B5E511, 0xAC73E00C),
 	MK_64(0x5180E5AE, 0xBAF2C4F0),
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 63030e5..96cc0e8 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -31,7 +31,7 @@
 #include <linux/types.h>
 #include <skein.h>
 
-#define KeyScheduleConst 0x1BD11BDAA9FC1A22L
+#define KEY_SCHEDULE_CONST 0x1BD11BDAA9FC1A22L
 
 /**
  * Which Threefish size to use
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 43e7757..2a2da98 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -28,7 +28,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 		u64 w[SKEIN_256_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
@@ -51,13 +51,13 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 		 * precomputed)
 		 */
 		/* set tweaks: T0=0; T1=CFG | FINAL */
-		Skein_Start_New_Type(ctx, CFG_FINAL);
+		skein_start_new_type(ctx, CFG_FINAL);
 
 		/* set the schema, version */
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hash_bit_len);
-		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
@@ -69,7 +69,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 	}
 	/* The chaining vars ctx->X are now initialized for hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
 
 	return SKEIN_SUCCESS;
 }
@@ -86,20 +86,20 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 		u64 w[SKEIN_256_STATE_WORDS];
 	} cfg; /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
-		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
 		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
-		Skein_Start_New_Type(ctx, KEY);
+		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
@@ -115,24 +115,24 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 	 */
 	/* output hash bit count */
 	ctx->h.hash_bit_len = hash_bit_len;
-	Skein_Start_New_Type(ctx, CFG_FINAL);
+	skein_start_new_type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hash_bit_len);
+	cfg.w[1] = skein_swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(tree_info);
+	cfg.w[2] = skein_swap64(tree_info);
 
-	Skein_Show_Key(256, &ctx->h, key, key_bytes);
+	skein_show_key(256, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);
+	skein_start_new_type(ctx, MSG);
 
 	return SKEIN_SUCCESS;
 }
@@ -145,7 +145,7 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
 	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_256_BLOCK_BYTES) {
@@ -155,13 +155,13 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 			n = SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msg_byte_cnt);
+				skein_assert(n < msg_byte_cnt);
 				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
 				msg_byte_cnt  -= n;
 				msg         += n;
 				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.b_cnt == SKEIN_256_BLOCK_BYTES);
+			skein_assert(ctx->h.b_cnt == SKEIN_256_BLOCK_BYTES);
 			skein_256_process_block(ctx, ctx->b, 1,
 						SKEIN_256_BLOCK_BYTES);
 			ctx->h.b_cnt = 0;
@@ -178,12 +178,12 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 			msg_byte_cnt -= n * SKEIN_256_BLOCK_BYTES;
 			msg        += n * SKEIN_256_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.b_cnt == 0);
+		skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
 	if (msg_byte_cnt) {
-		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
 			     SKEIN_256_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
 		ctx->h.b_cnt += msg_byte_cnt;
@@ -199,7 +199,7 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
@@ -222,8 +222,8 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
@@ -231,9 +231,9 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(256, &ctx->h, n,
+		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
@@ -254,7 +254,7 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 		u64 w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
@@ -277,13 +277,13 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 		 * precomputed)
 		 */
 		/* set tweaks: T0=0; T1=CFG | FINAL */
-		Skein_Start_New_Type(ctx, CFG_FINAL);
+		skein_start_new_type(ctx, CFG_FINAL);
 
 		/* set the schema, version */
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hash_bit_len);
-		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
@@ -299,7 +299,7 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 	 * hash_bit_len.
 	 */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
 
 	return SKEIN_SUCCESS;
 }
@@ -316,20 +316,20 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 		u64 w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
-		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
 		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
-		Skein_Start_New_Type(ctx, KEY);
+		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
@@ -344,24 +344,24 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 	 * precomputed for each key)
 	 */
 	ctx->h.hash_bit_len = hash_bit_len;          /* output hash bit count */
-	Skein_Start_New_Type(ctx, CFG_FINAL);
+	skein_start_new_type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hash_bit_len);
+	cfg.w[1] = skein_swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(tree_info);
+	cfg.w[2] = skein_swap64(tree_info);
 
-	Skein_Show_Key(512, &ctx->h, key, key_bytes);
+	skein_show_key(512, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);
+	skein_start_new_type(ctx, MSG);
 
 	return SKEIN_SUCCESS;
 }
@@ -374,7 +374,7 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
 	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_512_BLOCK_BYTES) {
@@ -384,13 +384,13 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 			n = SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msg_byte_cnt);
+				skein_assert(n < msg_byte_cnt);
 				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
 				msg_byte_cnt  -= n;
 				msg         += n;
 				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.b_cnt == SKEIN_512_BLOCK_BYTES);
+			skein_assert(ctx->h.b_cnt == SKEIN_512_BLOCK_BYTES);
 			skein_512_process_block(ctx, ctx->b, 1,
 						SKEIN_512_BLOCK_BYTES);
 			ctx->h.b_cnt = 0;
@@ -407,12 +407,12 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 			msg_byte_cnt -= n * SKEIN_512_BLOCK_BYTES;
 			msg        += n * SKEIN_512_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.b_cnt == 0);
+		skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
 	if (msg_byte_cnt) {
-		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
 			     SKEIN_512_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
 		ctx->h.b_cnt += msg_byte_cnt;
@@ -428,7 +428,7 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
@@ -451,8 +451,8 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
@@ -460,9 +460,9 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(512, &ctx->h, n,
+		skein_show_final(512, &ctx->h, n,
 				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
@@ -479,22 +479,22 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 {
 	union {
-		u8 b[SKEIN1024_STATE_BYTES];
-		u64 w[SKEIN1024_STATE_WORDS];
+		u8 b[SKEIN_1024_STATE_BYTES];
+		u64 w[SKEIN_1024_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
 	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
 	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  512:
-		memcpy(ctx->X, SKEIN1024_IV_512, sizeof(ctx->X));
+		memcpy(ctx->X, SKEIN_1024_IV_512, sizeof(ctx->X));
 		break;
 	case  384:
-		memcpy(ctx->X, SKEIN1024_IV_384, sizeof(ctx->X));
+		memcpy(ctx->X, SKEIN_1024_IV_384, sizeof(ctx->X));
 		break;
 	case 1024:
-		memcpy(ctx->X, SKEIN1024_IV_1024, sizeof(ctx->X));
+		memcpy(ctx->X, SKEIN_1024_IV_1024, sizeof(ctx->X));
 		break;
 	default:
 		/* here if there is no precomputed IV value available */
@@ -503,13 +503,13 @@ int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 		 * (could be precomputed)
 		 */
 		/* set tweaks: T0=0; T1=CFG | FINAL */
-		Skein_Start_New_Type(ctx, CFG_FINAL);
+		skein_start_new_type(ctx, CFG_FINAL);
 
 		/* set the schema, version */
-		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+		cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hash_bit_len);
-		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
+		cfg.w[1] = skein_swap64(hash_bit_len);
+		cfg.w[2] = skein_swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
 
@@ -522,7 +522,7 @@ int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 
 	/* The chaining vars ctx->X are now initialized for the hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
+	skein_start_new_type(ctx, MSG);              /* T0=0, T1= MSG type */
 
 	return SKEIN_SUCCESS;
 }
@@ -535,24 +535,24 @@ int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 			u64 tree_info, const u8 *key, size_t key_bytes)
 {
 	union {
-		u8 b[SKEIN1024_STATE_BYTES];
-		u64 w[SKEIN1024_STATE_WORDS];
+		u8 b[SKEIN_1024_STATE_BYTES];
+		u64 w[SKEIN_1024_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
+	skein_assert_ret(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
 	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
-		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
+		skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
 		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
-		Skein_Start_New_Type(ctx, KEY);
+		skein_start_new_type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
@@ -568,24 +568,24 @@ int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 	 */
 	/* output hash bit count */
 	ctx->h.hash_bit_len = hash_bit_len;
-	Skein_Start_New_Type(ctx, CFG_FINAL);
+	skein_start_new_type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
-	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
+	cfg.w[0] = skein_swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hash_bit_len);
+	cfg.w[1] = skein_swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(tree_info);
+	cfg.w[2] = skein_swap64(tree_info);
 
-	Skein_Show_Key(1024, &ctx->h, key, key_bytes);
+	skein_show_key(1024, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
-	Skein_Start_New_Type(ctx, MSG);
+	skein_start_new_type(ctx, MSG);
 
 	return SKEIN_SUCCESS;
 }
@@ -598,46 +598,46 @@ int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN1024_BLOCK_BYTES) {
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_1024_BLOCK_BYTES) {
 		/* finish up any buffered message data */
 		if (ctx->h.b_cnt) {
 			/* # bytes free in buffer b[] */
-			n = SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt;
+			n = SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msg_byte_cnt);
+				skein_assert(n < msg_byte_cnt);
 				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
 				msg_byte_cnt  -= n;
 				msg         += n;
 				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.b_cnt == SKEIN1024_BLOCK_BYTES);
+			skein_assert(ctx->h.b_cnt == SKEIN_1024_BLOCK_BYTES);
 			skein_1024_process_block(ctx, ctx->b, 1,
-						 SKEIN1024_BLOCK_BYTES);
+						 SKEIN_1024_BLOCK_BYTES);
 			ctx->h.b_cnt = 0;
 		}
 		/*
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msg_byte_cnt > SKEIN1024_BLOCK_BYTES) {
+		if (msg_byte_cnt > SKEIN_1024_BLOCK_BYTES) {
 			/* number of full blocks to process */
-			n = (msg_byte_cnt-1) / SKEIN1024_BLOCK_BYTES;
+			n = (msg_byte_cnt-1) / SKEIN_1024_BLOCK_BYTES;
 			skein_1024_process_block(ctx, msg, n,
-						 SKEIN1024_BLOCK_BYTES);
-			msg_byte_cnt -= n * SKEIN1024_BLOCK_BYTES;
-			msg        += n * SKEIN1024_BLOCK_BYTES;
+						 SKEIN_1024_BLOCK_BYTES);
+			msg_byte_cnt -= n * SKEIN_1024_BLOCK_BYTES;
+			msg        += n * SKEIN_1024_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.b_cnt == 0);
+		skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
 	if (msg_byte_cnt) {
-		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
-			     SKEIN1024_BLOCK_BYTES);
+		skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_1024_BLOCK_BYTES);
 		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
 		ctx->h.b_cnt += msg_byte_cnt;
 	}
@@ -650,16 +650,16 @@ int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
 int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN1024_STATE_WORDS];
+	u64 X[SKEIN_1024_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN1024_BLOCK_BYTES)
+	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt);
+			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
 
 	/* process the final block */
 	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
@@ -673,21 +673,21 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byte_cnt; i++) {
+	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN1024_BLOCK_BYTES;
-		if (n >= SKEIN1024_BLOCK_BYTES)
-			n  = SKEIN1024_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
+		if (n >= SKEIN_1024_BLOCK_BYTES)
+			n  = SKEIN_1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(1024, &ctx->h, n,
-				 hash_val+i*SKEIN1024_BLOCK_BYTES);
+		skein_show_final(1024, &ctx->h, n,
+				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -702,7 +702,7 @@ int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
@@ -714,7 +714,7 @@ int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN_256_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_256_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -724,7 +724,7 @@ int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
@@ -736,7 +736,7 @@ int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN_512_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_512_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -746,19 +746,19 @@ int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.b_cnt < SKEIN1024_BLOCK_BYTES)
+	if (ctx->h.b_cnt < SKEIN_1024_BLOCK_BYTES)
 		memset(&ctx->b[ctx->h.b_cnt], 0,
-			SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt);
+			SKEIN_1024_BLOCK_BYTES - ctx->h.b_cnt);
 	/* process the final block */
 	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN1024_BLOCK_BYTES);
+	skein_put64_lsb_first(hash_val, ctx->X, SKEIN_1024_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -771,7 +771,7 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -784,8 +784,8 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
@@ -793,9 +793,9 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(256, &ctx->h, n,
+		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
@@ -810,7 +810,7 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -823,8 +823,8 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 	memcpy(X, ctx->X, sizeof(X));
 	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
@@ -832,9 +832,9 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(256, &ctx->h, n,
+		skein_show_final(256, &ctx->h, n,
 				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
@@ -847,9 +847,9 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
-	u64 X[SKEIN1024_STATE_WORDS];
+	u64 X[SKEIN_1024_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	skein_assert_ret(ctx->h.b_cnt <= SKEIN_1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -860,21 +860,21 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byte_cnt; i++) {
+	for (i = 0; i*SKEIN_1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
-		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
-		Skein_Start_New_Type(ctx, OUT_FINAL);
+		((u64 *)ctx->b)[0] = skein_swap64((u64) i);
+		skein_start_new_type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byte_cnt - i*SKEIN1024_BLOCK_BYTES;
-		if (n >= SKEIN1024_BLOCK_BYTES)
-			n  = SKEIN1024_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_1024_BLOCK_BYTES;
+		if (n >= SKEIN_1024_BLOCK_BYTES)
+			n  = SKEIN_1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hash_val+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+		skein_put64_lsb_first(hash_val+i*SKEIN_1024_BLOCK_BYTES, ctx->X,
 				      n);
-		Skein_Show_Final(256, &ctx->h, n,
-				 hash_val+i*SKEIN1024_BLOCK_BYTES);
+		skein_show_final(256, &ctx->h, n,
+				 hash_val+i*SKEIN_1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 87b3ff2..16d596b 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -29,7 +29,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 
 int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 {
-	Skein_Assert(ctx && size, SKEIN_FAIL);
+	skein_assert_ret(ctx && size, SKEIN_FAIL);
 
 	memset(ctx , 0, sizeof(struct skein_ctx));
 	ctx->skein_size = size;
@@ -44,7 +44,7 @@ int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 	u64 *X = NULL;
 	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
-	Skein_Assert(ctx, SKEIN_FAIL);
+	skein_assert_ret(ctx, SKEIN_FAIL);
 	/*
 	 * The following two lines rely of the fact that the real Skein
 	 * contexts are a union in out context and thus have tha maximum
@@ -89,12 +89,12 @@ int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
 	size_t X_len = 0;
 	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
-	Skein_Assert(ctx, SKEIN_FAIL);
+	skein_assert_ret(ctx, SKEIN_FAIL);
 
 	X = ctx->m.s256.X;
 	X_len = ctx->skein_size/8;
 
-	Skein_Assert(hash_bit_len, SKEIN_BAD_HASHLEN);
+	skein_assert_ret(hash_bit_len, SKEIN_BAD_HASHLEN);
 
 	switch (ctx->skein_size) {
 	case SKEIN_256:
@@ -141,7 +141,7 @@ void skein_reset(struct skein_ctx *ctx)
 	memcpy(X, ctx->X_save, X_len);
 
 	/* Setup context to process the message */
-	Skein_Start_New_Type(&ctx->m, MSG);
+	skein_start_new_type(&ctx->m, MSG);
 }
 
 int skein_update(struct skein_ctx *ctx, const u8 *msg,
@@ -149,7 +149,7 @@ int skein_update(struct skein_ctx *ctx, const u8 *msg,
 {
 	int ret = SKEIN_FAIL;
 
-	Skein_Assert(ctx, SKEIN_FAIL);
+	skein_assert_ret(ctx, SKEIN_FAIL);
 
 	switch (ctx->skein_size) {
 	case SKEIN_256:
@@ -185,8 +185,8 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 	 * only the final Update() call is allowed do partial bytes, else
 	 * assert an error
 	 */
-	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
-			msg_bit_cnt == 0, SKEIN_FAIL);
+	skein_assert_ret((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
+			 msg_bit_cnt == 0, SKEIN_FAIL);
 
 	/* if number of bits is a multiple of bytes - that's easy */
 	if ((msg_bit_cnt & 0x7) == 0)
@@ -203,13 +203,13 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 	up = (u8 *)ctx->m.s256.X + ctx->skein_size / 8;
 
 	/* set tweak flag for the skein_final call */
-	Skein_Set_Bit_Pad_Flag(ctx->m.h);
+	skein_set_bit_pad_flag(ctx->m.h);
 
 	/* now "pad" the final partial byte the way NIST likes */
 	/* get the b_cnt value (same location for all block sizes) */
 	length = ctx->m.h.b_cnt;
 	/* internal sanity check: there IS a partial byte in the buffer! */
-	Skein_assert(length != 0);
+	skein_assert(length != 0);
 	/* partial byte bit mask */
 	mask = (u8) (1u << (7 - (msg_bit_cnt & 7)));
 	/* apply bit padding on final byte (in the buffer) */
@@ -222,7 +222,7 @@ int skein_final(struct skein_ctx *ctx, u8 *hash)
 {
 	int ret = SKEIN_FAIL;
 
-	Skein_Assert(ctx, SKEIN_FAIL);
+	skein_assert_ret(ctx, SKEIN_FAIL);
 
 	switch (ctx->skein_size) {
 	case SKEIN_256:
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 716b78e..4ee7f9f 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -11,10 +11,10 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 	struct threefish_key key;
 	u64 tweak[2];
 	int i;
-	u64  w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
+	u64 w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
 	u64 words[3];
 
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -37,7 +37,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		threefish_set_key(&key, THREEFISH_256, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_256_STATE_WORDS);
+		skein_get64_lsb_first(w, blk_ptr, SKEIN_256_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
@@ -63,9 +63,9 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 	u64 tweak[2];
 	int i;
 	u64 words[3];
-	u64  w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
+	u64 w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -88,7 +88,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		threefish_set_key(&key, THREEFISH_512, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_512_STATE_WORDS);
+		skein_get64_lsb_first(w, blk_ptr, SKEIN_512_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
@@ -118,9 +118,9 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 	u64 tweak[2];
 	int i;
 	u64 words[3];
-	u64  w[SKEIN1024_STATE_WORDS]; /* local copy of input block */
+	u64 w[SKEIN_1024_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
@@ -143,11 +143,11 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		threefish_set_key(&key, THREEFISH_1024, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, SKEIN1024_STATE_WORDS);
+		skein_get64_lsb_first(w, blk_ptr, SKEIN_1024_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
-		blk_ptr += SKEIN1024_BLOCK_BYTES;
+		blk_ptr += SKEIN_1024_BLOCK_BYTES;
 
 		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0]  = ctx->X[0]  ^ w[0];
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index ebd4af1..7b66ec5 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -32,9 +32,9 @@
 #define ts              (kw + KW_TWK_BASE)
 
 #ifdef SKEIN_DEBUG
-#define DebugSaveTweak(ctx) { ctx->h.T[0] = ts[0]; ctx->h.T[1] = ts[1]; }
+#define debug_save_tweak(ctx) { ctx->h.T[0] = ts[0]; ctx->h.T[1] = ts[1]; }
 #else
-#define DebugSaveTweak(ctx)
+#define debug_save_tweak(ctx)
 #endif
 
 /*****************************  SKEIN_256 ******************************/
@@ -70,7 +70,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 
 	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
 #endif
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -90,9 +90,9 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		ts[2] = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
-		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_get64_lsb_first(w, blk_ptr, WCNT);
+		debug_save_tweak(ctx);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X0 = w[0] + ks[0]; /* do the first full key injection */
 		X1 = w[1] + ks[1] + ts[0];
@@ -100,24 +100,24 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		X3 = w[3] + ks[3];
 
 		/* show starting state values */
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
 				 X_ptr);
 
 		blk_ptr += SKEIN_256_BLOCK_BYTES;
 
 		/* run the rounds */
 
-#define Round256(p0, p1, p2, p3, ROT, r_num)                              \
+#define ROUND256(p0, p1, p2, p3, ROT, r_num)                              \
 do { \
-	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
-	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
+	X##p0 += X##p1; X##p1 = rotl_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
+	X##p2 += X##p3; X##p3 = rotl_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 } while (0)
 
 #if SKEIN_UNROLL_256 == 0
 #define R256(p0, p1, p2, p3, ROT, r_num) /* fully unrolled */ \
 do { \
-	Round256(p0, p1, p2, p3, ROT, r_num); \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
+	ROUND256(p0, p1, p2, p3, ROT, r_num); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
 } while (0)
 
 #define I256(R) \
@@ -127,13 +127,13 @@ do { \
 	X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3]; \
 	X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3]; \
 	X3   += ks[((R)+4) % 5] +     (R)+1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
 #define R256(p0, p1, p2, p3, ROT, r_num) \
 do { \
-	Round256(p0, p1, p2, p3, ROT, r_num); \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
+	ROUND256(p0, p1, p2, p3, ROT, r_num); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I256(R) \
@@ -146,13 +146,13 @@ do { \
 	/* rotate key schedule */ \
 	ks[r + (R) + 4]   = ks[r + (R) - 1]; \
 	ts[r + (R) + 2]   = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
 #endif
 		{
-#define R256_8_rounds(R)                  \
+#define R256_8_ROUNDS(R)                  \
 do { \
 		R256(0, 1, 2, 3, R_256_0, 8 * (R) + 1);  \
 		R256(0, 3, 2, 1, R_256_1, 8 * (R) + 2);  \
@@ -166,54 +166,54 @@ do { \
 		I256(2 * (R) + 1); \
 } while (0)
 
-		R256_8_rounds(0);
+		R256_8_ROUNDS(0);
 
-#define R256_Unroll_R(NN) \
+#define R256_UNROLL_R(NN) \
 	((SKEIN_UNROLL_256 == 0 && \
 	  SKEIN_256_ROUNDS_TOTAL/8 > (NN)) || \
 	 (SKEIN_UNROLL_256 > (NN)))
 
-	#if   R256_Unroll_R(1)
-		R256_8_rounds(1);
+	#if   R256_UNROLL_R(1)
+		R256_8_ROUNDS(1);
 	#endif
-	#if   R256_Unroll_R(2)
-		R256_8_rounds(2);
+	#if   R256_UNROLL_R(2)
+		R256_8_ROUNDS(2);
 	#endif
-	#if   R256_Unroll_R(3)
-		R256_8_rounds(3);
+	#if   R256_UNROLL_R(3)
+		R256_8_ROUNDS(3);
 	#endif
-	#if   R256_Unroll_R(4)
-		R256_8_rounds(4);
+	#if   R256_UNROLL_R(4)
+		R256_8_ROUNDS(4);
 	#endif
-	#if   R256_Unroll_R(5)
-		R256_8_rounds(5);
+	#if   R256_UNROLL_R(5)
+		R256_8_ROUNDS(5);
 	#endif
-	#if   R256_Unroll_R(6)
-		R256_8_rounds(6);
+	#if   R256_UNROLL_R(6)
+		R256_8_ROUNDS(6);
 	#endif
-	#if   R256_Unroll_R(7)
-		R256_8_rounds(7);
+	#if   R256_UNROLL_R(7)
+		R256_8_ROUNDS(7);
 	#endif
-	#if   R256_Unroll_R(8)
-		R256_8_rounds(8);
+	#if   R256_UNROLL_R(8)
+		R256_8_ROUNDS(8);
 	#endif
-	#if   R256_Unroll_R(9)
-		R256_8_rounds(9);
+	#if   R256_UNROLL_R(9)
+		R256_8_ROUNDS(9);
 	#endif
-	#if   R256_Unroll_R(10)
-		R256_8_rounds(10);
+	#if   R256_UNROLL_R(10)
+		R256_8_ROUNDS(10);
 	#endif
-	#if   R256_Unroll_R(11)
-		R256_8_rounds(11);
+	#if   R256_UNROLL_R(11)
+		R256_8_ROUNDS(11);
 	#endif
-	#if   R256_Unroll_R(12)
-		R256_8_rounds(12);
+	#if   R256_UNROLL_R(12)
+		R256_8_ROUNDS(12);
 	#endif
-	#if   R256_Unroll_R(13)
-		R256_8_rounds(13);
+	#if   R256_UNROLL_R(13)
+		R256_8_ROUNDS(13);
 	#endif
-	#if   R256_Unroll_R(14)
-		R256_8_rounds(14);
+	#if   R256_UNROLL_R(14)
+		R256_8_ROUNDS(14);
 	#endif
 	#if  (SKEIN_UNROLL_256 > 14)
 #error  "need more unrolling in skein_256_process_block"
@@ -225,7 +225,7 @@ do { \
 		ctx->X[2] = X2 ^ w[2];
 		ctx->X[3] = X3 ^ w[3];
 
-		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
@@ -281,7 +281,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 	X_ptr[4] = &X4;  X_ptr[5] = &X5;  X_ptr[6] = &X6;  X_ptr[7] = &X7;
 #endif
 
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -306,9 +306,9 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		ts[2] = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
-		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_get64_lsb_first(w, blk_ptr, WCNT);
+		debug_save_tweak(ctx);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X0   = w[0] + ks[0]; /* do the first full key injection */
 		X1   = w[1] + ks[1];
@@ -321,22 +321,22 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 
 		blk_ptr += SKEIN_512_BLOCK_BYTES;
 
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
 				 X_ptr);
 		/* run the rounds */
-#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
+#define ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
 do { \
-	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
-	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
-	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
-	X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
+	X##p0 += X##p1; X##p1 = rotl_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
+	X##p2 += X##p3; X##p3 = rotl_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
+	X##p4 += X##p5; X##p5 = rotl_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
+	X##p6 += X##p7; X##p7 = rotl_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
 } while (0)
 
 #if SKEIN_UNROLL_512 == 0
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) /* unrolled */ \
 do { \
-	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
 } while (0)
 
 #define I512(R) \
@@ -350,13 +350,13 @@ do { \
 	X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3]; \
 	X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3]; \
 	X7   += ks[((R) + 8) % 9] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
 do { \
-	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num); \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I512(R) \
@@ -373,13 +373,13 @@ do { \
 	/* rotate key schedule */ \
 	ks[r +         (R) + 8] = ks[r + (R) - 1]; \
 	ts[r +         (R) + 2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
 #endif /* end of looped code definitions */
 		{
-#define R512_8_rounds(R)  /* do 8 full rounds */  \
+#define R512_8_ROUNDS(R)  /* do 8 full rounds */  \
 do { \
 		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
 		R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_1, 8 * (R) + 2);   \
@@ -393,54 +393,54 @@ do { \
 		I512(2 * (R) + 1);        /* and key injection */ \
 } while (0)
 
-			R512_8_rounds(0);
+			R512_8_ROUNDS(0);
 
-#define R512_Unroll_R(NN) \
+#define R512_UNROLL_R(NN) \
 		((SKEIN_UNROLL_512 == 0 && \
 		  SKEIN_512_ROUNDS_TOTAL/8 > (NN)) || \
 		 (SKEIN_UNROLL_512 > (NN)))
 
-	#if   R512_Unroll_R(1)
-			R512_8_rounds(1);
+	#if   R512_UNROLL_R(1)
+			R512_8_ROUNDS(1);
 	#endif
-	#if   R512_Unroll_R(2)
-			R512_8_rounds(2);
+	#if   R512_UNROLL_R(2)
+			R512_8_ROUNDS(2);
 	#endif
-	#if   R512_Unroll_R(3)
-			R512_8_rounds(3);
+	#if   R512_UNROLL_R(3)
+			R512_8_ROUNDS(3);
 	#endif
-	#if   R512_Unroll_R(4)
-			R512_8_rounds(4);
+	#if   R512_UNROLL_R(4)
+			R512_8_ROUNDS(4);
 	#endif
-	#if   R512_Unroll_R(5)
-			R512_8_rounds(5);
+	#if   R512_UNROLL_R(5)
+			R512_8_ROUNDS(5);
 	#endif
-	#if   R512_Unroll_R(6)
-			R512_8_rounds(6);
+	#if   R512_UNROLL_R(6)
+			R512_8_ROUNDS(6);
 	#endif
-	#if   R512_Unroll_R(7)
-			R512_8_rounds(7);
+	#if   R512_UNROLL_R(7)
+			R512_8_ROUNDS(7);
 	#endif
-	#if   R512_Unroll_R(8)
-			R512_8_rounds(8);
+	#if   R512_UNROLL_R(8)
+			R512_8_ROUNDS(8);
 	#endif
-	#if   R512_Unroll_R(9)
-			R512_8_rounds(9);
+	#if   R512_UNROLL_R(9)
+			R512_8_ROUNDS(9);
 	#endif
-	#if   R512_Unroll_R(10)
-			R512_8_rounds(10);
+	#if   R512_UNROLL_R(10)
+			R512_8_ROUNDS(10);
 	#endif
-	#if   R512_Unroll_R(11)
-			R512_8_rounds(11);
+	#if   R512_UNROLL_R(11)
+			R512_8_ROUNDS(11);
 	#endif
-	#if   R512_Unroll_R(12)
-			R512_8_rounds(12);
+	#if   R512_UNROLL_R(12)
+			R512_8_ROUNDS(12);
 	#endif
-	#if   R512_Unroll_R(13)
-			R512_8_rounds(13);
+	#if   R512_UNROLL_R(13)
+			R512_8_ROUNDS(13);
 	#endif
-	#if   R512_Unroll_R(14)
-			R512_8_rounds(14);
+	#if   R512_UNROLL_R(14)
+			R512_8_ROUNDS(14);
 	#endif
 	#if  (SKEIN_UNROLL_512 > 14)
 #error  "need more unrolling in skein_512_process_block"
@@ -456,7 +456,7 @@ do { \
 		ctx->X[5] = X5 ^ w[5];
 		ctx->X[6] = X6 ^ w[6];
 		ctx->X[7] = X7 ^ w[7];
-		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
 	} while (--blk_cnt);
@@ -483,10 +483,10 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 			      size_t blk_cnt, size_t byte_cnt_add)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
-		WCNT = SKEIN1024_STATE_WORDS
+		WCNT = SKEIN_1024_STATE_WORDS
 	};
 #undef  RCNT
-#define RCNT  (SKEIN1024_ROUNDS_TOTAL/8)
+#define RCNT  (SKEIN_1024_ROUNDS_TOTAL/8)
 
 #ifdef SKEIN_LOOP /* configure how much to unroll the loop */
 #define SKEIN_UNROLL_1024 ((SKEIN_LOOP)%10)
@@ -519,7 +519,7 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 	X_ptr[15] = &X15;
 #endif
 
-	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
+	skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -554,9 +554,9 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		ts[2]  = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
-		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
+		skein_get64_lsb_first(w, blk_ptr, WCNT);
+		debug_save_tweak(ctx);
+		skein_show_block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X00    =  w[0] +  ks[0]; /* do the first full key injection */
 		X01    =  w[1] +  ks[1];
@@ -575,29 +575,29 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		X14    = w[14] + ks[14] + ts[1];
 		X15    = w[15] + ks[15];
 
-		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
+		skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
 				 X_ptr);
 
-#define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+#define ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, r_num) \
 do { \
-	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
-	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
-	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
-	X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6;   \
-	X##p8 += X##p9; X##p9 = RotL_64(X##p9, ROT##_4); X##p9 ^= X##p8;   \
-	X##pA += X##pB; X##pB = RotL_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
-	X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
-	X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
+	X##p0 += X##p1; X##p1 = rotl_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
+	X##p2 += X##p3; X##p3 = rotl_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
+	X##p4 += X##p5; X##p5 = rotl_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
+	X##p6 += X##p7; X##p7 = rotl_64(X##p7, ROT##_3); X##p7 ^= X##p6;   \
+	X##p8 += X##p9; X##p9 = rotl_64(X##p9, ROT##_4); X##p9 ^= X##p8;   \
+	X##pA += X##pB; X##pB = rotl_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
+	X##pC += X##pD; X##pD = rotl_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
+	X##pE += X##pF; X##pF = rotl_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
 } while (0)
 
 #if SKEIN_UNROLL_1024 == 0
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 		ROT, rn) \
 do { \
-	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, X_ptr); \
+	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+			pF, ROT, rn); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, rn, X_ptr); \
 } while (0)
 
 #define I1024(R) \
@@ -619,15 +619,15 @@ do { \
 	X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3]; \
 	X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3]; \
 	X15   += ks[((R) + 16) % 17] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 		ROT, rn) \
 do { \
-	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, X_ptr); \
+	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
+			pF, ROT, rn); \
+	skein_show_r_ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, X_ptr); \
 } while (0)
 
 #define I1024(R) \
@@ -652,13 +652,13 @@ do { \
 	/* rotate key schedule */ \
 	ks[r  +         (R) + 16] = ks[r + (R) - 1]; \
 	ts[r  +         (R) +  2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
+	skein_show_r_ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
 #endif
 		{
-#define R1024_8_rounds(R) \
+#define R1024_8_ROUNDS(R) \
 do { \
 	R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, \
 		R1024_0, 8*(R) + 1); \
@@ -680,54 +680,54 @@ do { \
 	I1024(2*(R)+1); \
 } while (0)
 
-			R1024_8_rounds(0);
+			R1024_8_ROUNDS(0);
 
-#define R1024_Unroll_R(NN) \
+#define R1024_UNROLL_R(NN) \
 		((SKEIN_UNROLL_1024 == 0 && \
-		  SKEIN1024_ROUNDS_TOTAL/8 > (NN)) || \
+		  SKEIN_1024_ROUNDS_TOTAL/8 > (NN)) || \
 		 (SKEIN_UNROLL_1024 > (NN)))
 
-	#if   R1024_Unroll_R(1)
-			R1024_8_rounds(1);
+	#if   R1024_UNROLL_R(1)
+			R1024_8_ROUNDS(1);
 	#endif
-	#if   R1024_Unroll_R(2)
-			R1024_8_rounds(2);
+	#if   R1024_UNROLL_R(2)
+			R1024_8_ROUNDS(2);
 	#endif
-	#if   R1024_Unroll_R(3)
-			R1024_8_rounds(3);
+	#if   R1024_UNROLL_R(3)
+			R1024_8_ROUNDS(3);
 	#endif
-	#if   R1024_Unroll_R(4)
-			R1024_8_rounds(4);
+	#if   R1024_UNROLL_R(4)
+			R1024_8_ROUNDS(4);
 	#endif
-	#if   R1024_Unroll_R(5)
-			R1024_8_rounds(5);
+	#if   R1024_UNROLL_R(5)
+			R1024_8_ROUNDS(5);
 	#endif
-	#if   R1024_Unroll_R(6)
-			R1024_8_rounds(6);
+	#if   R1024_UNROLL_R(6)
+			R1024_8_ROUNDS(6);
 	#endif
-	#if   R1024_Unroll_R(7)
-			R1024_8_rounds(7);
+	#if   R1024_UNROLL_R(7)
+			R1024_8_ROUNDS(7);
 	#endif
-	#if   R1024_Unroll_R(8)
-			R1024_8_rounds(8);
+	#if   R1024_UNROLL_R(8)
+			R1024_8_ROUNDS(8);
 	#endif
-	#if   R1024_Unroll_R(9)
-			R1024_8_rounds(9);
+	#if   R1024_UNROLL_R(9)
+			R1024_8_ROUNDS(9);
 	#endif
-	#if   R1024_Unroll_R(10)
-			R1024_8_rounds(10);
+	#if   R1024_UNROLL_R(10)
+			R1024_8_ROUNDS(10);
 	#endif
-	#if   R1024_Unroll_R(11)
-			R1024_8_rounds(11);
+	#if   R1024_UNROLL_R(11)
+			R1024_8_ROUNDS(11);
 	#endif
-	#if   R1024_Unroll_R(12)
-			R1024_8_rounds(12);
+	#if   R1024_UNROLL_R(12)
+			R1024_8_ROUNDS(12);
 	#endif
-	#if   R1024_Unroll_R(13)
-			R1024_8_rounds(13);
+	#if   R1024_UNROLL_R(13)
+			R1024_8_ROUNDS(13);
 	#endif
-	#if   R1024_Unroll_R(14)
-			R1024_8_rounds(14);
+	#if   R1024_UNROLL_R(14)
+			R1024_8_ROUNDS(14);
 	#endif
 #if  (SKEIN_UNROLL_1024 > 14)
 #error  "need more unrolling in Skein_1024_Process_Block"
@@ -752,10 +752,10 @@ do { \
 		ctx->X[14] = X14 ^ w[14];
 		ctx->X[15] = X15 ^ w[15];
 
-		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
+		skein_show_round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-		blk_ptr += SKEIN1024_BLOCK_BYTES;
+		blk_ptr += SKEIN_1024_BLOCK_BYTES;
 	} while (--blk_cnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 17a314b..0ba42fa 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -9,7 +9,7 @@ void threefish_set_key(struct threefish_key *key_ctx,
 {
 	int key_words = state_size / 64;
 	int i;
-	u64 parity = KeyScheduleConst;
+	u64 parity = KEY_SCHEDULE_CONST;
 
 	key_ctx->tweak[0] = tweak[0];
 	key_ctx->tweak[1] = tweak[1];
@@ -29,9 +29,9 @@ void threefish_encrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(plain, in, key_ctx->state_size / 64);
+	skein_get64_lsb_first(plain, in, key_ctx->state_size / 64);
 	threefish_encrypt_block_words(key_ctx, plain, cipher);
-	Skein_Put64_LSB_First(out, cipher, key_ctx->state_size / 8);
+	skein_put64_lsb_first(out, cipher, key_ctx->state_size / 8);
 }
 
 void threefish_encrypt_block_words(struct threefish_key *key_ctx, u64 *in,
@@ -56,9 +56,9 @@ void threefish_decrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(cipher, in, key_ctx->state_size / 64);
+	skein_get64_lsb_first(cipher, in, key_ctx->state_size / 64);
 	threefish_decrypt_block_words(key_ctx, cipher, plain);
-	Skein_Put64_LSB_First(out, plain, key_ctx->state_size / 8);
+	skein_put64_lsb_first(out, plain, key_ctx->state_size / 8);
 }
 
 void threefish_decrypt_block_words(struct threefish_key *key_ctx, u64 *in,
-- 
1.9.2

