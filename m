Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaESEMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:12:09 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34564 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaESEMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:02 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/06] staging: crypto: skein: rename enums
Date: Mon, 19 May 2014 12:09:57 +0400
Message-Id: <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel use capitalized names for enum. To prepare skein
driver to mainline inclusion, we rename all enums to capitalized
names.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/include/skein.h        |  6 +++---
 drivers/staging/skein/include/skeinApi.h     |  8 ++++----
 drivers/staging/skein/include/threefishApi.h | 18 +++++++++---------
 drivers/staging/skein/skeinApi.c             | 24 ++++++++++++------------
 drivers/staging/skein/skeinBlockNo3F.c       |  6 +++---
 drivers/staging/skein/skein_block.c          |  6 +++---
 drivers/staging/skein/threefishApi.c         | 12 ++++++------
 7 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 09e96d6..8ecd720 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -293,7 +293,7 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 ** Skein block function constants (shared across Ref and Opt code)
 ******************************************************************/
 enum {
-	    /* Skein_256 round rotation constants */
+	    /* SKEIN_256 round rotation constants */
 	R_256_0_0 = 14, R_256_0_1 = 16,
 	R_256_1_0 = 52, R_256_1_1 = 57,
 	R_256_2_0 = 23, R_256_2_1 = 40,
@@ -303,7 +303,7 @@ enum {
 	R_256_6_0 = 58, R_256_6_1 = 22,
 	R_256_7_0 = 32, R_256_7_1 = 32,
 
-	    /* Skein_512 round rotation constants */
+	    /* SKEIN_512 round rotation constants */
 	R_512_0_0 = 46, R_512_0_1 = 36, R_512_0_2 = 19, R_512_0_3 = 37,
 	R_512_1_0 = 33, R_512_1_1 = 27, R_512_1_2 = 14, R_512_1_3 = 42,
 	R_512_2_0 = 17, R_512_2_1 = 49, R_512_2_2 = 36, R_512_2_3 = 39,
@@ -313,7 +313,7 @@ enum {
 	R_512_6_0 = 25, R_512_6_1 = 29, R_512_6_2 = 39, R_512_6_3 = 43,
 	R_512_7_0 =  8, R_512_7_1 = 35, R_512_7_2 = 56, R_512_7_3 = 22,
 
-	    /* Skein1024 round rotation constants */
+	    /* SKEIN_1024 round rotation constants */
 	R1024_0_0 = 24, R1024_0_1 = 13, R1024_0_2 =  8, R1024_0_3 = 47,
 	R1024_0_4 =  8, R1024_0_5 = 17, R1024_0_6 = 22, R1024_0_7 = 37,
 	R1024_1_0 = 38, R1024_1_1 = 19, R1024_1_2 = 10, R1024_1_3 = 55,
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index 850d5c9..b4e879d 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -50,7 +50,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  * struct skein_ctx ctx;             // a Skein hash or MAC context
  *
  * // prepare context, here for a Skein with a state size of 512 bits.
- * skein_ctx_prepare(&ctx, Skein512);
+ * skein_ctx_prepare(&ctx, SKEIN_512);
  *
  * // Initialize the context to set the requested hash length in bits
  * // here request a output hash size of 31 bits (Skein supports variable
@@ -85,9 +85,9 @@ OTHER DEALINGS IN THE SOFTWARE.
  * Which Skein size to use
  */
 enum skein_size {
-	Skein256 = 256,     /*!< Skein with 256 bit state */
-	Skein512 = 512,     /*!< Skein with 512 bit state */
-	Skein1024 = 1024    /*!< Skein with 1024 bit state */
+	SKEIN_256 = 256,     /*!< Skein with 256 bit state */
+	SKEIN_512 = 512,     /*!< Skein with 512 bit state */
+	SKEIN_1024 = 1024    /*!< Skein with 1024 bit state */
 };
 
 /**
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 37f6e63..63030e5 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -17,14 +17,14 @@
  * functions.
  *
 @code
-    // Threefish cipher context data
-    struct threefish_key key_ctx;
+	// Threefish cipher context data
+	struct threefish_key key_ctx;
 
-    // Initialize the context
-    threefish_set_key(&key_ctx, Threefish512, key, tweak);
+	// Initialize the context
+	threefish_set_key(&key_ctx, THREEFISH_512, key, tweak);
 
-    // Encrypt
-    threefish_encrypt_block_bytes(&key_ctx, input, cipher);
+	// Encrypt
+	threefish_encrypt_block_bytes(&key_ctx, input, cipher);
 @endcode
  */
 
@@ -37,9 +37,9 @@
  * Which Threefish size to use
  */
 enum threefish_size {
-	Threefish256 = 256,     /*!< Skein with 256 bit state */
-	Threefish512 = 512,     /*!< Skein with 512 bit state */
-	Threefish1024 = 1024    /*!< Skein with 1024 bit state */
+	THREEFISH_256 = 256,     /*!< Skein with 256 bit state */
+	THREEFISH_512 = 512,     /*!< Skein with 512 bit state */
+	THREEFISH_1024 = 1024    /*!< Skein with 1024 bit state */
 };
 
 /**
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index 3426392..87b3ff2 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -57,15 +57,15 @@ int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 	 * the save chaining variables.
 	 */
 	switch (ctx->skein_size) {
-	case Skein256:
+	case SKEIN_256:
 		ret = skein_256_init_ext(&ctx->m.s256, hash_bit_len,
 					 tree_info, NULL, 0);
 		break;
-	case Skein512:
+	case SKEIN_512:
 		ret = skein_512_init_ext(&ctx->m.s512, hash_bit_len,
 					 tree_info, NULL, 0);
 		break;
-	case Skein1024:
+	case SKEIN_1024:
 		ret = skein_1024_init_ext(&ctx->m.s1024, hash_bit_len,
 					  tree_info, NULL, 0);
 		break;
@@ -97,18 +97,18 @@ int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
 	Skein_Assert(hash_bit_len, SKEIN_BAD_HASHLEN);
 
 	switch (ctx->skein_size) {
-	case Skein256:
+	case SKEIN_256:
 		ret = skein_256_init_ext(&ctx->m.s256, hash_bit_len,
 					 tree_info,
 					 (const u8 *)key, key_len);
 
 		break;
-	case Skein512:
+	case SKEIN_512:
 		ret = skein_512_init_ext(&ctx->m.s512, hash_bit_len,
 					 tree_info,
 					 (const u8 *)key, key_len);
 		break;
-	case Skein1024:
+	case SKEIN_1024:
 		ret = skein_1024_init_ext(&ctx->m.s1024, hash_bit_len,
 					  tree_info,
 					  (const u8 *)key, key_len);
@@ -152,15 +152,15 @@ int skein_update(struct skein_ctx *ctx, const u8 *msg,
 	Skein_Assert(ctx, SKEIN_FAIL);
 
 	switch (ctx->skein_size) {
-	case Skein256:
+	case SKEIN_256:
 		ret = skein_256_update(&ctx->m.s256, (const u8 *)msg,
 				       msg_byte_cnt);
 		break;
-	case Skein512:
+	case SKEIN_512:
 		ret = skein_512_update(&ctx->m.s512, (const u8 *)msg,
 				       msg_byte_cnt);
 		break;
-	case Skein1024:
+	case SKEIN_1024:
 		ret = skein_1024_update(&ctx->m.s1024, (const u8 *)msg,
 					msg_byte_cnt);
 		break;
@@ -225,13 +225,13 @@ int skein_final(struct skein_ctx *ctx, u8 *hash)
 	Skein_Assert(ctx, SKEIN_FAIL);
 
 	switch (ctx->skein_size) {
-	case Skein256:
+	case SKEIN_256:
 		ret = skein_256_final(&ctx->m.s256, (u8 *)hash);
 		break;
-	case Skein512:
+	case SKEIN_512:
 		ret = skein_512_final(&ctx->m.s512, (u8 *)hash);
 		break;
-	case Skein1024:
+	case SKEIN_1024:
 		ret = skein_1024_final(&ctx->m.s1024, (u8 *)hash);
 		break;
 	}
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 55c6831..716b78e 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -34,7 +34,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefish_set_key(&key, Threefish256, ctx->X, tweak);
+		threefish_set_key(&key, THREEFISH_256, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_256_STATE_WORDS);
@@ -85,7 +85,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefish_set_key(&key, Threefish512, ctx->X, tweak);
+		threefish_set_key(&key, THREEFISH_512, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_512_STATE_WORDS);
@@ -140,7 +140,7 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefish_set_key(&key, Threefish1024, ctx->X, tweak);
+		threefish_set_key(&key, THREEFISH_1024, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blk_ptr, SKEIN1024_STATE_WORDS);
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index c9db6d6..ebd4af1 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -37,7 +37,7 @@
 #define DebugSaveTweak(ctx)
 #endif
 
-/*****************************  Skein_256 ******************************/
+/*****************************  SKEIN_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
 void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add)
@@ -246,7 +246,7 @@ unsigned int skein_256_unroll_cnt(void)
 #endif
 #endif
 
-/*****************************  Skein_512 ******************************/
+/*****************************  SKEIN_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
 void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add)
@@ -477,7 +477,7 @@ unsigned int skein_512_unroll_cnt(void)
 #endif
 #endif
 
-/*****************************  Skein1024 ******************************/
+/*****************************  SKEIN_1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
 void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 			      size_t blk_cnt, size_t byte_cnt_add)
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 67ba9a6..17a314b 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -38,13 +38,13 @@ void threefish_encrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out)
 {
 	switch (key_ctx->state_size) {
-	case Threefish256:
+	case THREEFISH_256:
 		threefish_encrypt_256(key_ctx, in, out);
 		break;
-	case Threefish512:
+	case THREEFISH_512:
 		threefish_encrypt_512(key_ctx, in, out);
 		break;
-	case Threefish1024:
+	case THREEFISH_1024:
 		threefish_encrypt_1024(key_ctx, in, out);
 		break;
 	}
@@ -65,13 +65,13 @@ void threefish_decrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out)
 {
 	switch (key_ctx->state_size) {
-	case Threefish256:
+	case THREEFISH_256:
 		threefish_decrypt_256(key_ctx, in, out);
 		break;
-	case Threefish512:
+	case THREEFISH_512:
 		threefish_decrypt_512(key_ctx, in, out);
 		break;
-	case Threefish1024:
+	case THREEFISH_1024:
 		threefish_decrypt_1024(key_ctx, in, out);
 		break;
 	}
-- 
1.9.2

