Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaESEMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:12:01 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42580 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaESEL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:11:58 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/06] staging: crypto: skein: rename camelcase functions
Date: Mon, 19 May 2014 12:09:54 +0400
Message-Id: <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

camelCase is not accepted in the Linux Kernel. To prepare skein
driver for mainline inclusion, we rename all functions to
non-camelCase equivalents.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/TODO                   |   1 -
 drivers/staging/skein/include/skein.h        |  66 ++++++++--------
 drivers/staging/skein/include/skeinApi.h     |  38 ++++-----
 drivers/staging/skein/include/skein_block.h  |  12 +--
 drivers/staging/skein/include/threefishApi.h |  44 ++++++-----
 drivers/staging/skein/skein.c                | 114 +++++++++++++--------------
 drivers/staging/skein/skeinApi.c             |  72 ++++++++---------
 drivers/staging/skein/skeinBlockNo3F.c       |  24 +++---
 drivers/staging/skein/skein_block.c          |  40 +++++-----
 drivers/staging/skein/threefish1024Block.c   |   6 +-
 drivers/staging/skein/threefish256Block.c    |   6 +-
 drivers/staging/skein/threefish512Block.c    |   6 +-
 drivers/staging/skein/threefishApi.c         |  38 ++++-----
 13 files changed, 239 insertions(+), 228 deletions(-)

diff --git a/drivers/staging/skein/TODO b/drivers/staging/skein/TODO
index f5c167a..bc42fb8 100644
--- a/drivers/staging/skein/TODO
+++ b/drivers/staging/skein/TODO
@@ -1,7 +1,6 @@
 skein/threefish TODO
 
  - rename camelcase vars
- - rename camelcase functions
  - rename files
  - move macros into appropriate header files
  - add / pass test vectors
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 0a2abce..15ff60f 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -86,59 +86,59 @@ struct skein1024_ctx { /* 1024-bit Skein hash context structure */
 	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
-/*   Skein APIs for (incremental) "straight hashing" */
-int  Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen);
-int  Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen);
-int  Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen);
-
-int  Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-int  Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-int  Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt);
-
-int  Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal);
+/* Skein APIs for (incremental) "straight hashing" */
+int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen);
+int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen);
+int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen);
+
+int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
+		     size_t msgByteCnt);
+int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
+		     size_t msgByteCnt);
+int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
+		      size_t msgByteCnt);
+
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hashVal);
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hashVal);
+int skein_1024_final(struct skein1024_ctx *ctx, u8 *hashVal);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
-**   After an InitExt() call, just use Update/Final calls as with Init().
+**   After an init_ext() call, just use update/final calls as with init().
 **
-**   Notes: Same parameters as _Init() calls, plus treeInfo/key/keyBytes.
+**   Notes: Same parameters as _init() calls, plus treeInfo/key/keyBytes.
 **          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL,
-**              the results of InitExt() are identical to calling Init().
-**          The function Init() may be called once to "precompute" the IV for
+**              the results of init_ext() are identical to calling init().
+**          The function init() may be called once to "precompute" the IV for
 **              a given hashBitLen value, then by saving a copy of the context
 **              the IV computation may be avoided in later calls.
-**          Similarly, the function InitExt() may be called once per MAC key
+**          Similarly, the function init_ext() may be called once per MAC key
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
-int  Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
-int  Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
+		       u64 treeInfo, const u8 *key, size_t keyBytes);
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
+		       u64 treeInfo, const u8 *key, size_t keyBytes);
+int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes);
 
 /*
 **   Skein APIs for MAC and tree hash:
-**      Final_Pad:  pad, do final block, but no OUTPUT type
-**      Output:     do just the output stage
+**      final_pad:  pad, do final block, but no OUTPUT type
+**      output:     do just the output stage
 */
-int  Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal);
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hashVal);
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hashVal);
+int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hashVal);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int  Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal);
-int  Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal);
-int  Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal);
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hashVal);
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hashVal);
+int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal);
 #endif
 
 /*****************************************************************
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index ace931a..ea54546 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -50,31 +50,31 @@ OTHER DEALINGS IN THE SOFTWARE.
  * struct skein_ctx ctx;             // a Skein hash or MAC context
  *
  * // prepare context, here for a Skein with a state size of 512 bits.
- * skeinCtxPrepare(&ctx, Skein512);
+ * skein_ctx_prepare(&ctx, Skein512);
  *
  * // Initialize the context to set the requested hash length in bits
  * // here request a output hash size of 31 bits (Skein supports variable
  * // output sizes even very strange sizes)
- * skeinInit(&ctx, 31);
+ * skein_init(&ctx, 31);
  *
  * // Now update Skein with any number of message bits. A function that
  * // takes a number of bytes is also available.
- * skeinUpdateBits(&ctx, message, msgLength);
+ * skein_update_bits(&ctx, message, msgLength);
  *
  * // Now get the result of the Skein hash. The output buffer must be
  * // large enough to hold the request number of output bits. The application
  * // may now extract the bits.
- * skeinFinal(&ctx, result);
+ * skein_final(&ctx, result);
  * ...
  * @endcode
  *
- * An application may use @c skeinReset to reset a Skein context and use
+ * An application may use @c skein_reset to reset a Skein context and use
  * it for creation of another hash with the same Skein state size and output
  * bit length. In this case the API implementation restores some internal
  * internal state data and saves a full Skein initialization round.
  *
- * To create a MAC the application just uses @c skeinMacInit instead of
- * @c skeinInit. All other functions calls remain the same.
+ * To create a MAC the application just uses @c skein_mac_init instead of
+ * @c skein_init. All other functions calls remain the same.
  *
  */
 
@@ -123,7 +123,7 @@ struct skein_ctx {
  * @return
  *     SKEIN_SUCESS of SKEIN_FAIL
  */
-int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
+int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size);
 
 /**
  * Initialize a Skein context.
@@ -137,9 +137,9 @@ int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size);
  *     Number of MAC hash bits to compute
  * @return
  *     SKEIN_SUCESS of SKEIN_FAIL
- * @see skeinReset
+ * @see skein_reset
  */
-int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
+int skein_init(struct skein_ctx *ctx, size_t hashBitLen);
 
 /**
  * Resets a Skein context for further use.
@@ -151,7 +151,7 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen);
  * @param ctx
  *     Pointer to a pre-initialized Skein MAC context
  */
-void skeinReset(struct skein_ctx *ctx);
+void skein_reset(struct skein_ctx *ctx);
 
 /**
  * Initializes a Skein context for MAC usage.
@@ -173,8 +173,8 @@ void skeinReset(struct skein_ctx *ctx);
  * @return
  *     SKEIN_SUCESS of SKEIN_FAIL
  */
-int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		 size_t hashBitLen);
+int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
+		   size_t hashBitLen);
 
 /**
  * Update Skein with the next part of the message.
@@ -188,8 +188,8 @@ int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
  * @return
  *     Success or error code.
  */
-int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
-		size_t msgByteCnt);
+int skein_update(struct skein_ctx *ctx, const u8 *msg,
+		 size_t msgByteCnt);
 
 /**
  * Update the hash with a message bit string.
@@ -204,8 +204,8 @@ int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
  * @param msgBitCnt
  *     Length of the message in @b bits.
  */
-int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
-		    size_t msgBitCnt);
+int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
+		      size_t msgBitCnt);
 
 /**
  * Finalize Skein and return the hash.
@@ -220,9 +220,9 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
  *     enough to store @c hashBitLen bits.
  * @return
  *     Success or error code.
- * @see skeinReset
+ * @see skein_reset
  */
-int skeinFinal(struct skein_ctx *ctx, u8 *hash);
+int skein_final(struct skein_ctx *ctx, u8 *hash);
 
 /**
  * @}
diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/include/skein_block.h
index b15c079..41cae89 100644
--- a/drivers/staging/skein/include/skein_block.h
+++ b/drivers/staging/skein/include/skein_block.h
@@ -12,11 +12,11 @@
 
 #include <skein.h> /* get the Skein API definitions   */
 
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd);
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd);
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd);
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+			      size_t blkCnt, size_t byteCntAdd);
 
 #endif
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index e81675d..6cdad46 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -21,10 +21,10 @@
     struct threefish_key keyCtx;
 
     // Initialize the context
-    threefishSetKey(&keyCtx, Threefish512, key, tweak);
+    threefish_set_key(&keyCtx, Threefish512, key, tweak);
 
     // Encrypt
-    threefishEncryptBlockBytes(&keyCtx, input, cipher);
+    threefish_encrypt_block_bytes(&keyCtx, input, cipher);
 @endcode
  */
 
@@ -72,9 +72,9 @@ struct threefish_key {
  * @param tweak
  *     Pointer to the two tweak words (word has 64 bits).
  */
-void threefishSetKey(struct threefish_key *keyCtx,
-			enum threefish_size stateSize,
-			u64 *keyData, u64 *tweak);
+void threefish_set_key(struct threefish_key *keyCtx,
+		       enum threefish_size stateSize,
+		       u64 *keyData, u64 *tweak);
 
 /**
  * Encrypt Threefisch block (bytes).
@@ -91,7 +91,8 @@ void threefishSetKey(struct threefish_key *keyCtx,
  * @param out
  *     Pointer to cipher buffer.
  */
-void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
+void threefish_encrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+				   u8 *out);
 
 /**
  * Encrypt Threefisch block (words).
@@ -110,8 +111,8 @@ void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
  * @param out
  *     Pointer to cipher buffer.
  */
-void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out);
+void threefish_encrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+				   u64 *out);
 
 /**
  * Decrypt Threefisch block (bytes).
@@ -128,7 +129,8 @@ void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
  * @param out
  *     Pointer to plaintext buffer.
  */
-void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
+void threefish_decrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+				   u8 *out);
 
 /**
  * Decrypt Threefisch block (words).
@@ -147,17 +149,21 @@ void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in, u8 *out);
  * @param out
  *     Pointer to plaintext buffer.
  */
-void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out);
+void threefish_decrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+				   u64 *out);
 
-void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input,
-			u64 *output);
-void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output);
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input,
-			u64 *output);
+void threefish_encrypt_256(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output);
+void threefish_encrypt_512(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output);
+void threefish_encrypt_1024(struct threefish_key *keyCtx, u64 *input,
+			    u64 *output);
+void threefish_decrypt_256(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output);
+void threefish_decrypt_512(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output);
+void threefish_decrypt_1024(struct threefish_key *keyCtx, u64 *input,
+			    u64 *output);
 /**
  * @}
  */
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index 096b86b..ac64d9f 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -21,7 +21,7 @@
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
+int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen)
 {
 	union {
 		u8  b[SKEIN_256_STATE_BYTES];
@@ -64,7 +64,7 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
-		Skein_256_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 	/* The chaining vars ctx->X are now initialized for hashBitLen. */
@@ -76,9 +76,9 @@ int Skein_256_Init(struct skein_256_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein_256_Init() when keyBytes == 0 && \
+/* [identical to skein_256_init() when keyBytes == 0 && \
  *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union {
@@ -103,9 +103,9 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		Skein_256_Update(ctx, key, keyBytes);
+		skein_256_update(ctx, key, keyBytes);
 		/* put result into cfg.b[] */
-		Skein_256_Final_Pad(ctx, cfg.b);
+		skein_256_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
 		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
@@ -128,7 +128,7 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
 	Skein_Show_Key(256, &ctx->h, key, keyBytes);
 
 	/* compute the initial chaining values from config block */
-	Skein_256_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
@@ -139,8 +139,8 @@ int Skein_256_InitExt(struct skein_256_ctx *ctx, size_t hashBitLen,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt)
+int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
+		     size_t msgByteCnt)
 {
 	size_t n;
 
@@ -162,7 +162,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN_256_BLOCK_BYTES);
-			Skein_256_Process_Block(ctx, ctx->b, 1,
+			skein_256_process_block(ctx, ctx->b, 1,
 						SKEIN_256_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
@@ -173,7 +173,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 		if (msgByteCnt > SKEIN_256_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;
-			Skein_256_Process_Block(ctx, msg, n,
+			skein_256_process_block(ctx, msg, n,
 						SKEIN_256_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN_256_BLOCK_BYTES;
 			msg        += n * SKEIN_256_BLOCK_BYTES;
@@ -193,7 +193,7 @@ int Skein_256_Update(struct skein_256_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_256_STATE_WORDS];
@@ -208,7 +208,7 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
 
 	/* process the final block */
-	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -224,7 +224,7 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
@@ -246,7 +246,7 @@ int Skein_256_Final(struct skein_256_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
+int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen)
 {
 	union {
 		u8  b[SKEIN_512_STATE_BYTES];
@@ -289,7 +289,7 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
-		Skein_512_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
@@ -305,10 +305,10 @@ int Skein_512_Init(struct skein_512_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein_512_Init() when keyBytes == 0 && \
+/* [identical to skein_512_init() when keyBytes == 0 && \
  *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes)
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
+		       u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union {
 		u8  b[SKEIN_512_STATE_BYTES];
@@ -332,9 +332,9 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		Skein_512_Update(ctx, key, keyBytes);
+		skein_512_update(ctx, key, keyBytes);
 		/* put result into cfg.b[] */
-		Skein_512_Final_Pad(ctx, cfg.b);
+		skein_512_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
 		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
@@ -356,7 +356,7 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
 	Skein_Show_Key(512, &ctx->h, key, keyBytes);
 
 	/* compute the initial chaining values from config block */
-	Skein_512_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
@@ -367,8 +367,8 @@ int Skein_512_InitExt(struct skein_512_ctx *ctx, size_t hashBitLen,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt)
+int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
+		     size_t msgByteCnt)
 {
 	size_t n;
 
@@ -390,7 +390,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN_512_BLOCK_BYTES);
-			Skein_512_Process_Block(ctx, ctx->b, 1,
+			skein_512_process_block(ctx, ctx->b, 1,
 						SKEIN_512_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
@@ -401,7 +401,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 		if (msgByteCnt > SKEIN_512_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;
-			Skein_512_Process_Block(ctx, msg, n,
+			skein_512_process_block(ctx, msg, n,
 						SKEIN_512_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN_512_BLOCK_BYTES;
 			msg        += n * SKEIN_512_BLOCK_BYTES;
@@ -421,7 +421,7 @@ int Skein_512_Update(struct skein_512_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_512_STATE_WORDS];
@@ -436,7 +436,7 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
 
 	/* process the final block */
-	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -452,7 +452,7 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
@@ -474,7 +474,7 @@ int Skein_512_Final(struct skein_512_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
+int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen)
 {
 	union {
 		u8  b[SKEIN1024_STATE_BYTES];
@@ -514,7 +514,7 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 		/* compute the initial chaining values from config block */
 		/* zero the chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
-		Skein1024_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+		skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
 
@@ -527,9 +527,9 @@ int Skein1024_Init(struct skein1024_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to Skein1024_Init() when keyBytes == 0 && \
+/* [identical to skein_1024_init() when keyBytes == 0 && \
  *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
+int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
 			u64 treeInfo, const u8 *key, size_t keyBytes)
 {
 	union {
@@ -554,9 +554,9 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		Skein1024_Update(ctx, key, keyBytes);
+		skein_1024_update(ctx, key, keyBytes);
 		/* put result into cfg.b[] */
-		Skein1024_Final_Pad(ctx, cfg.b);
+		skein_1024_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
 		memcpy(ctx->X, cfg.b, sizeof(cfg.b));
 	}
@@ -579,7 +579,7 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
 	Skein_Show_Key(1024, &ctx->h, key, keyBytes);
 
 	/* compute the initial chaining values from config block */
-	Skein1024_Process_Block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
+	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 
 	/* The chaining vars ctx->X are now initialized */
 	/* Set up to process the data message portion of the hash (default) */
@@ -590,8 +590,8 @@ int Skein1024_InitExt(struct skein1024_ctx *ctx, size_t hashBitLen,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
-int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
-			size_t msgByteCnt)
+int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
+		      size_t msgByteCnt)
 {
 	size_t n;
 
@@ -613,8 +613,8 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 				ctx->h.bCnt += n;
 			}
 			Skein_assert(ctx->h.bCnt == SKEIN1024_BLOCK_BYTES);
-			Skein1024_Process_Block(ctx, ctx->b, 1,
-						SKEIN1024_BLOCK_BYTES);
+			skein_1024_process_block(ctx, ctx->b, 1,
+						 SKEIN1024_BLOCK_BYTES);
 			ctx->h.bCnt = 0;
 		}
 		/*
@@ -624,8 +624,8 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 		if (msgByteCnt > SKEIN1024_BLOCK_BYTES) {
 			/* number of full blocks to process */
 			n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;
-			Skein1024_Process_Block(ctx, msg, n,
-						SKEIN1024_BLOCK_BYTES);
+			skein_1024_process_block(ctx, msg, n,
+						 SKEIN1024_BLOCK_BYTES);
 			msgByteCnt -= n * SKEIN1024_BLOCK_BYTES;
 			msg        += n * SKEIN1024_BLOCK_BYTES;
 		}
@@ -644,7 +644,7 @@ int Skein1024_Update(struct skein1024_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_final(struct skein1024_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN1024_STATE_WORDS];
@@ -659,7 +659,7 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
 
 	/* process the final block */
-	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* now output the result */
 	/* total number of output bytes */
@@ -675,7 +675,7 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
@@ -696,7 +696,7 @@ int Skein1024_Final(struct skein1024_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hashVal)
 {
 	/* catch uninitialized context */
 	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
@@ -708,7 +708,7 @@ int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 		memset(&ctx->b[ctx->h.bCnt], 0,
 			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
 	/* process the final block */
-	Skein_256_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* "output" the state bytes */
 	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_256_BLOCK_BYTES);
@@ -718,7 +718,7 @@ int Skein_256_Final_Pad(struct skein_256_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hashVal)
 {
 	/* catch uninitialized context */
 	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
@@ -730,7 +730,7 @@ int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 		memset(&ctx->b[ctx->h.bCnt], 0,
 			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
 	/* process the final block */
-	Skein_512_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* "output" the state bytes */
 	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_512_BLOCK_BYTES);
@@ -740,7 +740,7 @@ int Skein_512_Final_Pad(struct skein_512_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hashVal)
 {
 	/* catch uninitialized context */
 	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
@@ -752,7 +752,7 @@ int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 		memset(&ctx->b[ctx->h.bCnt], 0,
 			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
 	/* process the final block */
-	Skein1024_Process_Block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
 
 	/* "output" the state bytes */
 	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN1024_BLOCK_BYTES);
@@ -763,7 +763,7 @@ int Skein1024_Final_Pad(struct skein1024_ctx *ctx, u8 *hashVal)
 #if SKEIN_TREE_HASH
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_256_STATE_WORDS];
@@ -784,7 +784,7 @@ int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein_256_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
@@ -802,7 +802,7 @@ int Skein_256_Output(struct skein_256_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN_512_STATE_WORDS];
@@ -823,7 +823,7 @@ int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein_512_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
@@ -841,7 +841,7 @@ int Skein_512_Output(struct skein_512_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal)
 {
 	size_t i, n, byteCnt;
 	u64 X[SKEIN1024_STATE_WORDS];
@@ -862,7 +862,7 @@ int Skein1024_Output(struct skein1024_ctx *ctx, u8 *hashVal)
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
-		Skein1024_Process_Block(ctx, ctx->b, 1, sizeof(u64));
+		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
 		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index dd109bf..c4f5333 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -27,7 +27,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #include <linux/string.h>
 #include <skeinApi.h>
 
-int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
+int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 {
 	Skein_Assert(ctx && size, SKEIN_FAIL);
 
@@ -37,7 +37,7 @@ int skeinCtxPrepare(struct skein_ctx *ctx, enum skein_size size)
 	return SKEIN_SUCCESS;
 }
 
-int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
+int skein_init(struct skein_ctx *ctx, size_t hashBitLen)
 {
 	int ret = SKEIN_FAIL;
 	size_t Xlen = 0;
@@ -58,16 +58,16 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
 	 */
 	switch (ctx->skeinSize) {
 	case Skein256:
-		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
-					treeInfo, NULL, 0);
+		ret = skein_256_init_ext(&ctx->m.s256, hashBitLen,
+					 treeInfo, NULL, 0);
 		break;
 	case Skein512:
-		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
-					treeInfo, NULL, 0);
+		ret = skein_512_init_ext(&ctx->m.s512, hashBitLen,
+					 treeInfo, NULL, 0);
 		break;
 	case Skein1024:
-		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
-					treeInfo, NULL, 0);
+		ret = skein_1024_init_ext(&ctx->m.s1024, hashBitLen,
+					  treeInfo, NULL, 0);
 		break;
 	}
 
@@ -81,8 +81,8 @@ int skeinInit(struct skein_ctx *ctx, size_t hashBitLen)
 	return ret;
 }
 
-int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		size_t hashBitLen)
+int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
+		   size_t hashBitLen)
 {
 	int ret = SKEIN_FAIL;
 	u64 *X = NULL;
@@ -98,20 +98,20 @@ int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
 
 	switch (ctx->skeinSize) {
 	case Skein256:
-		ret = Skein_256_InitExt(&ctx->m.s256, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
+		ret = skein_256_init_ext(&ctx->m.s256, hashBitLen,
+					 treeInfo,
+					 (const u8 *)key, keyLen);
 
 		break;
 	case Skein512:
-		ret = Skein_512_InitExt(&ctx->m.s512, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
+		ret = skein_512_init_ext(&ctx->m.s512, hashBitLen,
+					 treeInfo,
+					 (const u8 *)key, keyLen);
 		break;
 	case Skein1024:
-		ret = Skein1024_InitExt(&ctx->m.s1024, hashBitLen,
-					treeInfo,
-					(const u8 *)key, keyLen);
+		ret = skein_1024_init_ext(&ctx->m.s1024, hashBitLen,
+					  treeInfo,
+					  (const u8 *)key, keyLen);
 
 		break;
 	}
@@ -125,7 +125,7 @@ int skeinMacInit(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
 	return ret;
 }
 
-void skeinReset(struct skein_ctx *ctx)
+void skein_reset(struct skein_ctx *ctx)
 {
 	size_t Xlen = 0;
 	u64 *X = NULL;
@@ -144,23 +144,23 @@ void skeinReset(struct skein_ctx *ctx)
 	Skein_Start_New_Type(&ctx->m, MSG);
 }
 
-int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
-		size_t msgByteCnt)
+int skein_update(struct skein_ctx *ctx, const u8 *msg,
+		 size_t msgByteCnt)
 {
 	int ret = SKEIN_FAIL;
 	Skein_Assert(ctx, SKEIN_FAIL);
 
 	switch (ctx->skeinSize) {
 	case Skein256:
-		ret = Skein_256_Update(&ctx->m.s256, (const u8 *)msg,
-					msgByteCnt);
+		ret = skein_256_update(&ctx->m.s256, (const u8 *)msg,
+				       msgByteCnt);
 		break;
 	case Skein512:
-		ret = Skein_512_Update(&ctx->m.s512, (const u8 *)msg,
-					msgByteCnt);
+		ret = skein_512_update(&ctx->m.s512, (const u8 *)msg,
+				       msgByteCnt);
 		break;
 	case Skein1024:
-		ret = Skein1024_Update(&ctx->m.s1024, (const u8 *)msg,
+		ret = skein_1024_update(&ctx->m.s1024, (const u8 *)msg,
 					msgByteCnt);
 		break;
 	}
@@ -168,8 +168,8 @@ int skeinUpdate(struct skein_ctx *ctx, const u8 *msg,
 
 }
 
-int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
-			size_t msgBitCnt)
+int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
+		      size_t msgBitCnt)
 {
 	/*
 	 * I've used the bit pad implementation from skein_test.c (see NIST CD)
@@ -189,9 +189,9 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 
 	/* if number of bits is a multiple of bytes - that's easy */
 	if ((msgBitCnt & 0x7) == 0)
-		return skeinUpdate(ctx, msg, msgBitCnt >> 3);
+		return skein_update(ctx, msg, msgBitCnt >> 3);
 
-	skeinUpdate(ctx, msg, (msgBitCnt >> 3) + 1);
+	skein_update(ctx, msg, (msgBitCnt >> 3) + 1);
 
 	/*
 	 * The next line rely on the fact that the real Skein contexts
@@ -201,7 +201,7 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 	 */
 	up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
 
-	/* set tweak flag for the skeinFinal call */
+	/* set tweak flag for the skein_final call */
 	Skein_Set_Bit_Pad_Flag(ctx->m.h);
 
 	/* now "pad" the final partial byte the way NIST likes */
@@ -217,20 +217,20 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 	return SKEIN_SUCCESS;
 }
 
-int skeinFinal(struct skein_ctx *ctx, u8 *hash)
+int skein_final(struct skein_ctx *ctx, u8 *hash)
 {
 	int ret = SKEIN_FAIL;
 	Skein_Assert(ctx, SKEIN_FAIL);
 
 	switch (ctx->skeinSize) {
 	case Skein256:
-		ret = Skein_256_Final(&ctx->m.s256, (u8 *)hash);
+		ret = skein_256_final(&ctx->m.s256, (u8 *)hash);
 		break;
 	case Skein512:
-		ret = Skein_512_Final(&ctx->m.s512, (u8 *)hash);
+		ret = skein_512_final(&ctx->m.s512, (u8 *)hash);
 		break;
 	case Skein1024:
-		ret = Skein1024_Final(&ctx->m.s1024, (u8 *)hash);
+		ret = skein_1024_final(&ctx->m.s1024, (u8 *)hash);
 		break;
 	}
 	return ret;
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 6917638..0acb617 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -5,8 +5,8 @@
 
 
 /*****************************  Skein_256 ******************************/
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -34,12 +34,12 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefishSetKey(&key, Threefish256, ctx->X, tweak);
+		threefish_set_key(&key, Threefish256, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);
 
-		threefishEncryptBlockWords(&key, w, ctx->X);
+		threefish_encrypt_block_words(&key, w, ctx->X);
 
 		blkPtr += SKEIN_256_BLOCK_BYTES;
 
@@ -56,8 +56,8 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 	ctx->h.T[1] = tweak[1];
 }
 
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -85,12 +85,12 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefishSetKey(&key, Threefish512, ctx->X, tweak);
+		threefish_set_key(&key, Threefish512, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);
 
-		threefishEncryptBlockWords(&key, w, ctx->X);
+		threefish_encrypt_block_words(&key, w, ctx->X);
 
 		blkPtr += SKEIN_512_BLOCK_BYTES;
 
@@ -111,8 +111,8 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	ctx->h.T[1] = tweak[1];
 }
 
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+			      size_t blkCnt, size_t byteCntAdd)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -140,12 +140,12 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		tweak[0] |= (words[1] & 0xffffffffL) << 32;
 		tweak[1] |= words[2] & 0xffffffffL;
 
-		threefishSetKey(&key, Threefish1024, ctx->X, tweak);
+		threefish_set_key(&key, Threefish1024, ctx->X, tweak);
 
 		/* get input block in little-endian format */
 		Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);
 
-		threefishEncryptBlockWords(&key, w, ctx->X);
+		threefish_encrypt_block_words(&key, w, ctx->X);
 
 		blkPtr += SKEIN1024_BLOCK_BYTES;
 
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index fd96ca0..1195aec 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -39,8 +39,8 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd)
 	{ /* do it in C */
 	enum {
 		WCNT = SKEIN_256_STATE_WORDS
@@ -215,7 +215,7 @@ do { \
 		R256_8_rounds(14);
 	#endif
 	#if  (SKEIN_UNROLL_256 > 14)
-#error  "need more unrolling in Skein_256_Process_Block"
+#error  "need more unrolling in skein_256_process_block"
 	#endif
 		}
 		/* do the final "feedforward" xor, update context chaining */
@@ -233,12 +233,12 @@ do { \
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
-size_t Skein_256_Process_Block_CodeSize(void)
+size_t skein_256_process_block_code_size(void)
 {
-	return ((u8 *) Skein_256_Process_Block_CodeSize) -
-		((u8 *) Skein_256_Process_Block);
+	return ((u8 *) skein_256_process_block_code_size) -
+		((u8 *) skein_256_process_block);
 }
-unsigned int Skein_256_Unroll_Cnt(void)
+unsigned int skein_256_unroll_cnt(void)
 {
 	return SKEIN_UNROLL_256;
 }
@@ -247,8 +247,8 @@ unsigned int Skein_256_Unroll_Cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
+			     size_t blkCnt, size_t byteCntAdd)
 { /* do it in C */
 	enum {
 		WCNT = SKEIN_512_STATE_WORDS
@@ -441,7 +441,7 @@ do { \
 			R512_8_rounds(14);
 	#endif
 	#if  (SKEIN_UNROLL_512 > 14)
-#error  "need more unrolling in Skein_512_Process_Block"
+#error  "need more unrolling in skein_512_process_block"
 	#endif
 		}
 
@@ -463,12 +463,12 @@ do { \
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
-size_t Skein_512_Process_Block_CodeSize(void)
+size_t skein_512_process_block_code_size(void)
 {
-	return ((u8 *) Skein_512_Process_Block_CodeSize) -
-		((u8 *) Skein_512_Process_Block);
+	return ((u8 *) skein_512_process_block_code_size) -
+		((u8 *) skein_512_process_block);
 }
-unsigned int Skein_512_Unroll_Cnt(void)
+unsigned int skein_512_unroll_cnt(void)
 {
 	return SKEIN_UNROLL_512;
 }
@@ -477,8 +477,8 @@ unsigned int Skein_512_Unroll_Cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-				size_t blkCnt, size_t byteCntAdd)
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
+			      size_t blkCnt, size_t byteCntAdd)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
 		WCNT = SKEIN1024_STATE_WORDS
@@ -757,12 +757,12 @@ do { \
 }
 
 #if defined(SKEIN_CODE_SIZE) || defined(SKEIN_PERF)
-size_t Skein1024_Process_Block_CodeSize(void)
+size_t skein_1024_process_block_code_size(void)
 {
-	return ((u8 *) Skein1024_Process_Block_CodeSize) -
-		((u8 *) Skein1024_Process_Block);
+	return ((u8 *) skein_1024_process_block_code_size) -
+		((u8 *) skein_1024_process_block);
 }
-unsigned int Skein1024_Unroll_Cnt(void)
+unsigned int skein_1024_unroll_cnt(void)
 {
 	return SKEIN_UNROLL_1024;
 }
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index fe7517b..113019f 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -2,7 +2,8 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_encrypt_1024(struct threefish_key *keyCtx, u64 *input,
+			    u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3],
@@ -2122,7 +2123,8 @@ void threefishEncrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	output[15] = b15 + k1 + 20;
 }
 
-void threefishDecrypt1024(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_decrypt_1024(struct threefish_key *keyCtx, u64 *input,
+			    u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3],
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index 2ae746a..ee21aef 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -2,7 +2,8 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_encrypt_256(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3];
@@ -494,7 +495,8 @@ void threefishEncrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	output[3] = b3 + k1 + 18;
 }
 
-void threefishDecrypt256(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_decrypt_256(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3];
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index f428fd6..c4ad1b4 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -2,7 +2,8 @@
 #include <threefishApi.h>
 
 
-void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_encrypt_512(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3],
@@ -962,7 +963,8 @@ void threefishEncrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
 	output[7] = b7 + k7 + 18;
 }
 
-void threefishDecrypt512(struct threefish_key *keyCtx, u64 *input, u64 *output)
+void threefish_decrypt_512(struct threefish_key *keyCtx, u64 *input,
+			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
 	  b2 = input[2], b3 = input[3],
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index 1e70f66..fce613b 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -3,9 +3,9 @@
 #include <linux/string.h>
 #include <threefishApi.h>
 
-void threefishSetKey(struct threefish_key *keyCtx,
-			enum threefish_size stateSize,
-			u64 *keyData, u64 *tweak)
+void threefish_set_key(struct threefish_key *keyCtx,
+		       enum threefish_size stateSize,
+		       u64 *keyData, u64 *tweak)
 {
 	int keyWords = stateSize / 64;
 	int i;
@@ -23,56 +23,56 @@ void threefishSetKey(struct threefish_key *keyCtx,
 	keyCtx->stateSize = stateSize;
 }
 
-void threefishEncryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
-				u8 *out)
+void threefish_encrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+				   u8 *out)
 {
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
 	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);
-	threefishEncryptBlockWords(keyCtx, plain, cipher);
+	threefish_encrypt_block_words(keyCtx, plain, cipher);
 	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);
 }
 
-void threefishEncryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out)
+void threefish_encrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+				   u64 *out)
 {
 	switch (keyCtx->stateSize) {
 	case Threefish256:
-		threefishEncrypt256(keyCtx, in, out);
+		threefish_encrypt_256(keyCtx, in, out);
 		break;
 	case Threefish512:
-		threefishEncrypt512(keyCtx, in, out);
+		threefish_encrypt_512(keyCtx, in, out);
 		break;
 	case Threefish1024:
-		threefishEncrypt1024(keyCtx, in, out);
+		threefish_encrypt_1024(keyCtx, in, out);
 		break;
 	}
 }
 
-void threefishDecryptBlockBytes(struct threefish_key *keyCtx, u8 *in,
-				u8 *out)
+void threefish_decrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+				   u8 *out)
 {
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
 	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);
-	threefishDecryptBlockWords(keyCtx, cipher, plain);
+	threefish_decrypt_block_words(keyCtx, cipher, plain);
 	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);
 }
 
-void threefishDecryptBlockWords(struct threefish_key *keyCtx, u64 *in,
-				u64 *out)
+void threefish_decrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+				   u64 *out)
 {
 	switch (keyCtx->stateSize) {
 	case Threefish256:
-		threefishDecrypt256(keyCtx, in, out);
+		threefish_decrypt_256(keyCtx, in, out);
 		break;
 	case Threefish512:
-		threefishDecrypt512(keyCtx, in, out);
+		threefish_decrypt_512(keyCtx, in, out);
 		break;
 	case Threefish1024:
-		threefishDecrypt1024(keyCtx, in, out);
+		threefish_decrypt_1024(keyCtx, in, out);
 		break;
 	}
 }
-- 
1.9.2

