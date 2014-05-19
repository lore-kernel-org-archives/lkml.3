Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaESENd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:13:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59545 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaESEMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:01 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/06] staging: crypto: skein: rename skein1024_ctx to skein_1024_ctx
Date: Mon, 19 May 2014 12:09:56 +0400
Message-Id: <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code have skein_512_ctx and skein_256_ctx but skein1024_ctx.
It would be logical to convert these names to a single form.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/include/skein.h       | 14 +++++++-------
 drivers/staging/skein/include/skeinApi.h    |  2 +-
 drivers/staging/skein/include/skein_block.h |  2 +-
 drivers/staging/skein/skein.c               | 12 ++++++------
 drivers/staging/skein/skeinBlockNo3F.c      |  2 +-
 drivers/staging/skein/skein_block.c         |  2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index deaa9c8..09e96d6 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -81,7 +81,7 @@ struct skein_512_ctx { /* 512-bit Skein hash context structure */
 	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
-struct skein1024_ctx { /* 1024-bit Skein hash context structure */
+struct skein_1024_ctx { /* 1024-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
 	u64 X[SKEIN1024_STATE_WORDS];	/* chaining variables */
 	u8 b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
@@ -90,18 +90,18 @@ struct skein1024_ctx { /* 1024-bit Skein hash context structure */
 /* Skein APIs for (incremental) "straight hashing" */
 int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len);
 int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len);
-int skein_1024_init(struct skein1024_ctx *ctx, size_t hash_bit_len);
+int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len);
 
 int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 		     size_t msg_byte_cnt);
 int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 		     size_t msg_byte_cnt);
-int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
+int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
 		      size_t msg_byte_cnt);
 
 int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val);
 int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_final(struct skein1024_ctx *ctx, u8 *hash_val);
+int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
@@ -121,7 +121,7 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
 		       u64 tree_info, const u8 *key, size_t key_bytes);
 int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
 		       u64 tree_info, const u8 *key, size_t key_bytes);
-int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
+int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 			u64 tree_info, const u8 *key, size_t key_bytes);
 
 /*
@@ -131,7 +131,7 @@ int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
 */
 int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val);
 int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hash_val);
+int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
@@ -139,7 +139,7 @@ int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hash_val);
 #if  SKEIN_TREE_HASH
 int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val);
 int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val);
-int skein_1024_output(struct skein1024_ctx *ctx, u8 *hash_val);
+int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 #endif
 
 /*****************************************************************
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 11ecab8..850d5c9 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -105,7 +105,7 @@ struct skein_ctx {
 		struct skein_ctx_hdr h;
 		struct skein_256_ctx s256;
 		struct skein_512_ctx s512;
-		struct skein1024_ctx s1024;
+		struct skein_1024_ctx s1024;
 	} m;
 };
 
diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/include/skein_block.h
index ec787a3..a8dd083 100644
--- a/drivers/staging/skein/include/skein_block.h
+++ b/drivers/staging/skein/include/skein_block.h
@@ -16,7 +16,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add);
 void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add);
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 			      size_t blk_cnt, size_t byte_cnt_add);
 
 #endif
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index d4f3534..43e7757 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -476,7 +476,7 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int skein_1024_init(struct skein1024_ctx *ctx, size_t hash_bit_len)
+int skein_1024_init(struct skein_1024_ctx *ctx, size_t hash_bit_len)
 {
 	union {
 		u8 b[SKEIN1024_STATE_BYTES];
@@ -531,7 +531,7 @@ int skein_1024_init(struct skein1024_ctx *ctx, size_t hash_bit_len)
 /* init the context for a MAC and/or tree hash operation */
 /* [identical to skein_1024_init() when key_bytes == 0 && \
  *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
+int skein_1024_init_ext(struct skein_1024_ctx *ctx, size_t hash_bit_len,
 			u64 tree_info, const u8 *key, size_t key_bytes)
 {
 	union {
@@ -592,7 +592,7 @@ int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
+int skein_1024_update(struct skein_1024_ctx *ctx, const u8 *msg,
 		      size_t msg_byte_cnt)
 {
 	size_t n;
@@ -647,7 +647,7 @@ int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int skein_1024_final(struct skein1024_ctx *ctx, u8 *hash_val)
+int skein_1024_final(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN1024_STATE_WORDS];
@@ -743,7 +743,7 @@ int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hash_val)
+int skein_1024_final_pad(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
 	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
@@ -844,7 +844,7 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int skein_1024_output(struct skein1024_ctx *ctx, u8 *hash_val)
+int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val)
 {
 	size_t i, n, byte_cnt;
 	u64 X[SKEIN1024_STATE_WORDS];
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 041e5ae..55c6831 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -111,7 +111,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 	ctx->h.T[1] = tweak[1];
 }
 
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 			      size_t blk_cnt, size_t byte_cnt_add)
 {
 	struct threefish_key key;
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index a51aa57..c9db6d6 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -479,7 +479,7 @@ unsigned int skein_512_unroll_cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 			      size_t blk_cnt, size_t byte_cnt_add)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
-- 
1.9.2

