Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaESENw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:13:52 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63548 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaESEMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:00 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/06] staging: crypto: skein: rename camelcase vars
Date: Mon, 19 May 2014 12:09:55 +0400
Message-Id: <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

camelCase is not accepted in the Linux Kernel. To prepare skein
driver for mainline inclusion, we rename all vars to
non-camelCase equivalents.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/TODO                   |   1 -
 drivers/staging/skein/include/skein.h        | 119 ++++----
 drivers/staging/skein/include/skeinApi.h     |  28 +-
 drivers/staging/skein/include/skein_block.h  |  12 +-
 drivers/staging/skein/include/threefishApi.h |  54 ++--
 drivers/staging/skein/skein.c                | 415 ++++++++++++++-------------
 drivers/staging/skein/skeinApi.c             | 102 +++----
 drivers/staging/skein/skeinBlockNo3F.c       |  42 +--
 drivers/staging/skein/skein_block.c          | 125 ++++----
 drivers/staging/skein/threefish1024Block.c   |  76 ++---
 drivers/staging/skein/threefish256Block.c    |  28 +-
 drivers/staging/skein/threefish512Block.c    |  44 +--
 drivers/staging/skein/threefishApi.c         |  60 ++--
 13 files changed, 558 insertions(+), 548 deletions(-)

diff --git a/drivers/staging/skein/TODO b/drivers/staging/skein/TODO
index bc42fb8..88a6e81 100644
--- a/drivers/staging/skein/TODO
+++ b/drivers/staging/skein/TODO
@@ -1,6 +1,5 @@
 skein/threefish TODO
 
- - rename camelcase vars
  - rename files
  - move macros into appropriate header files
  - add / pass test vectors
diff --git a/drivers/staging/skein/include/skein.h b/drivers/staging/skein/include/skein.h
index 15ff60f..deaa9c8 100644
--- a/drivers/staging/skein/include/skein.h
+++ b/drivers/staging/skein/include/skein.h
@@ -33,8 +33,9 @@
 #endif
 
 /* below two prototype assume we are handed aligned data */
-#define Skein_Put64_LSB_First(dst08, src64, bCnt) memcpy(dst08, src64, bCnt)
-#define Skein_Get64_LSB_First(dst64, src08, wCnt) memcpy(dst64, src08, 8*(wCnt))
+#define Skein_Put64_LSB_First(dst08, src64, b_cnt) memcpy(dst08, src64, b_cnt)
+#define Skein_Get64_LSB_First(dst64, src08, w_cnt) \
+		memcpy(dst64, src08, 8*(w_cnt))
 #define Skein_Swap64(w64)  (w64)
 
 enum {
@@ -63,82 +64,82 @@ enum {
 #define  SKEIN1024_BLOCK_BYTES  (8*SKEIN1024_STATE_WORDS)
 
 struct skein_ctx_hdr {
-	size_t  hashBitLen;		/* size of hash result, in bits */
-	size_t  bCnt;			/* current byte count in buffer b[] */
-	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
+	size_t hash_bit_len;		/* size of hash result, in bits */
+	size_t b_cnt;			/* current byte count in buffer b[] */
+	u64 T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
 };
 
 struct skein_256_ctx { /* 256-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+	u64 X[SKEIN_256_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 struct skein_512_ctx { /* 512-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+	u64 X[SKEIN_512_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 struct skein1024_ctx { /* 1024-bit Skein hash context structure */
 	struct skein_ctx_hdr h;		/* common header context variables */
-	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
-	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
+	u64 X[SKEIN1024_STATE_WORDS];	/* chaining variables */
+	u8 b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
 };
 
 /* Skein APIs for (incremental) "straight hashing" */
-int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen);
-int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen);
-int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen);
+int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len);
+int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len);
+int skein_1024_init(struct skein1024_ctx *ctx, size_t hash_bit_len);
 
 int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
-		     size_t msgByteCnt);
+		     size_t msg_byte_cnt);
 int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
-		     size_t msgByteCnt);
+		     size_t msg_byte_cnt);
 int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
-		      size_t msgByteCnt);
+		      size_t msg_byte_cnt);
 
-int skein_256_final(struct skein_256_ctx *ctx, u8 *hashVal);
-int skein_512_final(struct skein_512_ctx *ctx, u8 *hashVal);
-int skein_1024_final(struct skein1024_ctx *ctx, u8 *hashVal);
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_final(struct skein1024_ctx *ctx, u8 *hash_val);
 
 /*
 **   Skein APIs for "extended" initialization: MAC keys, tree hashing.
 **   After an init_ext() call, just use update/final calls as with init().
 **
-**   Notes: Same parameters as _init() calls, plus treeInfo/key/keyBytes.
-**          When keyBytes == 0 and treeInfo == SKEIN_SEQUENTIAL,
+**   Notes: Same parameters as _init() calls, plus tree_info/key/key_bytes.
+**          When key_bytes == 0 and tree_info == SKEIN_SEQUENTIAL,
 **              the results of init_ext() are identical to calling init().
 **          The function init() may be called once to "precompute" the IV for
-**              a given hashBitLen value, then by saving a copy of the context
+**              a given hash_bit_len value, then by saving a copy of the context
 **              the IV computation may be avoided in later calls.
 **          Similarly, the function init_ext() may be called once per MAC key
 **              to precompute the MAC IV, then a copy of the context saved and
 **              reused for each new MAC computation.
 **/
-int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
-		       u64 treeInfo, const u8 *key, size_t keyBytes);
-int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
-		       u64 treeInfo, const u8 *key, size_t keyBytes);
-int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes);
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes);
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes);
+int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
+			u64 tree_info, const u8 *key, size_t key_bytes);
 
 /*
 **   Skein APIs for MAC and tree hash:
 **      final_pad:  pad, do final block, but no OUTPUT type
 **      output:     do just the output stage
 */
-int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hashVal);
-int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hashVal);
-int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hashVal);
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hash_val);
 
 #ifndef SKEIN_TREE_HASH
 #define SKEIN_TREE_HASH (1)
 #endif
 #if  SKEIN_TREE_HASH
-int skein_256_output(struct skein_256_ctx *ctx, u8 *hashVal);
-int skein_512_output(struct skein_512_ctx *ctx, u8 *hashVal);
-int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal);
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val);
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val);
+int skein_1024_output(struct skein1024_ctx *ctx, u8 *hash_val);
 #endif
 
 /*****************************************************************
@@ -207,7 +208,7 @@ int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal);
 
 #define SKEIN_CFG_STR_LEN       (4*8)
 
-/* bit field definitions in config block treeInfo word */
+/* bit field definitions in config block tree_info word */
 #define SKEIN_CFG_TREE_LEAF_SIZE_POS  (0)
 #define SKEIN_CFG_TREE_NODE_SIZE_POS  (8)
 #define SKEIN_CFG_TREE_MAX_LEVEL_POS  (16)
@@ -219,46 +220,46 @@ int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal);
 #define SKEIN_CFG_TREE_MAX_LEVEL_MSK (((u64)0xFF) << \
 					SKEIN_CFG_TREE_MAX_LEVEL_POS)
 
-#define SKEIN_CFG_TREE_INFO(leaf, node, maxLvl)                   \
+#define SKEIN_CFG_TREE_INFO(leaf, node, max_lvl)                   \
 	((((u64)(leaf))   << SKEIN_CFG_TREE_LEAF_SIZE_POS) |    \
 	 (((u64)(node))   << SKEIN_CFG_TREE_NODE_SIZE_POS) |    \
-	 (((u64)(maxLvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
+	 (((u64)(max_lvl)) << SKEIN_CFG_TREE_MAX_LEVEL_POS))
 
-/* use as treeInfo in InitExt() call for sequential processing */
+/* use as tree_info in InitExt() call for sequential processing */
 #define SKEIN_CFG_TREE_INFO_SEQUENTIAL SKEIN_CFG_TREE_INFO(0, 0, 0)
 
 /*
 **   Skein macros for getting/setting tweak words, etc.
 **   These are useful for partial input bytes, hash tree init/update, etc.
 **/
-#define Skein_Get_Tweak(ctxPtr, TWK_NUM)          ((ctxPtr)->h.T[TWK_NUM])
-#define Skein_Set_Tweak(ctxPtr, TWK_NUM, tVal) { \
-		(ctxPtr)->h.T[TWK_NUM] = (tVal); \
+#define Skein_Get_Tweak(ctx_ptr, TWK_NUM)          ((ctx_ptr)->h.T[TWK_NUM])
+#define Skein_Set_Tweak(ctx_ptr, TWK_NUM, t_val) { \
+		(ctx_ptr)->h.T[TWK_NUM] = (t_val); \
 	}
 
-#define Skein_Get_T0(ctxPtr)     Skein_Get_Tweak(ctxPtr, 0)
-#define Skein_Get_T1(ctxPtr)     Skein_Get_Tweak(ctxPtr, 1)
-#define Skein_Set_T0(ctxPtr, T0) Skein_Set_Tweak(ctxPtr, 0, T0)
-#define Skein_Set_T1(ctxPtr, T1) Skein_Set_Tweak(ctxPtr, 1, T1)
+#define Skein_Get_T0(ctx_ptr)     Skein_Get_Tweak(ctx_ptr, 0)
+#define Skein_Get_T1(ctx_ptr)     Skein_Get_Tweak(ctx_ptr, 1)
+#define Skein_Set_T0(ctx_ptr, T0) Skein_Set_Tweak(ctx_ptr, 0, T0)
+#define Skein_Set_T1(ctx_ptr, T1) Skein_Set_Tweak(ctx_ptr, 1, T1)
 
 /* set both tweak words at once */
-#define Skein_Set_T0_T1(ctxPtr, T0, T1)           \
+#define Skein_Set_T0_T1(ctx_ptr, T0, T1)           \
 	{                                           \
-	Skein_Set_T0(ctxPtr, (T0));                  \
-	Skein_Set_T1(ctxPtr, (T1));                  \
+	Skein_Set_T0(ctx_ptr, (T0));                  \
+	Skein_Set_T1(ctx_ptr, (T1));                  \
 	}
 
-#define Skein_Set_Type(ctxPtr, BLK_TYPE)         \
-	Skein_Set_T1(ctxPtr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
+#define Skein_Set_Type(ctx_ptr, BLK_TYPE)         \
+	Skein_Set_T1(ctx_ptr, SKEIN_T1_BLK_TYPE_##BLK_TYPE)
 
 /*
  * setup for starting with a new type:
- * h.T[0]=0; h.T[1] = NEW_TYPE; h.bCnt=0;
+ * h.T[0]=0; h.T[1] = NEW_TYPE; h.b_cnt=0;
  */
-#define Skein_Start_New_Type(ctxPtr, BLK_TYPE) { \
-		Skein_Set_T0_T1(ctxPtr, 0, SKEIN_T1_FLAG_FIRST | \
+#define Skein_Start_New_Type(ctx_ptr, BLK_TYPE) { \
+		Skein_Set_T0_T1(ctx_ptr, 0, SKEIN_T1_FLAG_FIRST | \
 				SKEIN_T1_BLK_TYPE_##BLK_TYPE); \
-		(ctxPtr)->h.bCnt = 0; \
+		(ctx_ptr)->h.b_cnt = 0; \
 	}
 
 #define Skein_Clear_First_Flag(hdr) { \
@@ -278,14 +279,14 @@ int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal);
 #ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
 #include "skein_debug.h"
 #else                           /* default is no callouts */
-#define Skein_Show_Block(bits, ctx, X, blkPtr, wPtr, ksEvenPtr, ksOddPtr)
+#define Skein_Show_Block(bits, ctx, X, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
 #define Skein_Show_Round(bits, ctx, r, X)
 #define Skein_Show_R_Ptr(bits, ctx, r, X_ptr)
-#define Skein_Show_Final(bits, ctx, cnt, outPtr)
-#define Skein_Show_Key(bits, ctx, key, keyBytes)
+#define Skein_Show_Final(bits, ctx, cnt, out_ptr)
+#define Skein_Show_Key(bits, ctx, key, key_bytes)
 #endif
 
-#define Skein_Assert(x, retCode)/* ignore all Asserts, for performance */
+#define Skein_Assert(x, ret_code)/* ignore all Asserts, for performance */
 #define Skein_assert(x)
 
 /*****************************************************************
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skeinApi.h
index ea54546..11ecab8 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skeinApi.h
@@ -59,7 +59,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  *
  * // Now update Skein with any number of message bits. A function that
  * // takes a number of bytes is also available.
- * skein_update_bits(&ctx, message, msgLength);
+ * skein_update_bits(&ctx, message, msg_length);
  *
  * // Now get the result of the Skein hash. The output buffer must be
  * // large enough to hold the request number of output bits. The application
@@ -99,8 +99,8 @@ enum skein_size {
  * structures as well.
  */
 struct skein_ctx {
-	u64 skeinSize;
-	u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
+	u64 skein_size;
+	u64 X_save[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
 	union {
 		struct skein_ctx_hdr h;
 		struct skein_256_ctx s256;
@@ -133,13 +133,13 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size);
  *
  * @param ctx
  *     Pointer to a Skein context.
- * @param hashBitLen
+ * @param hash_bit_len
  *     Number of MAC hash bits to compute
  * @return
  *     SKEIN_SUCESS of SKEIN_FAIL
  * @see skein_reset
  */
-int skein_init(struct skein_ctx *ctx, size_t hashBitLen);
+int skein_init(struct skein_ctx *ctx, size_t hash_bit_len);
 
 /**
  * Resets a Skein context for further use.
@@ -166,15 +166,15 @@ void skein_reset(struct skein_ctx *ctx);
  *     Pointer to an empty or preinitialized Skein MAC context
  * @param key
  *     Pointer to key bytes or NULL
- * @param keyLen
+ * @param key_len
  *     Length of the key in bytes or zero
- * @param hashBitLen
+ * @param hash_bit_len
  *     Number of MAC hash bits to compute
  * @return
  *     SKEIN_SUCESS of SKEIN_FAIL
  */
-int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		   size_t hashBitLen);
+int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
+		   size_t hash_bit_len);
 
 /**
  * Update Skein with the next part of the message.
@@ -183,13 +183,13 @@ int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
  *     Pointer to initialized Skein context
  * @param msg
  *     Pointer to the message.
- * @param msgByteCnt
+ * @param msg_byte_cnt
  *     Length of the message in @b bytes
  * @return
  *     Success or error code.
  */
 int skein_update(struct skein_ctx *ctx, const u8 *msg,
-		 size_t msgByteCnt);
+		 size_t msg_byte_cnt);
 
 /**
  * Update the hash with a message bit string.
@@ -201,11 +201,11 @@ int skein_update(struct skein_ctx *ctx, const u8 *msg,
  *     Pointer to initialized Skein context
  * @param msg
  *     Pointer to the message.
- * @param msgBitCnt
+ * @param msg_bit_cnt
  *     Length of the message in @b bits.
  */
 int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
-		      size_t msgBitCnt);
+		      size_t msg_bit_cnt);
 
 /**
  * Finalize Skein and return the hash.
@@ -217,7 +217,7 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
  *     Pointer to initialized Skein context
  * @param hash
  *     Pointer to buffer that receives the hash. The buffer must be large
- *     enough to store @c hashBitLen bits.
+ *     enough to store @c hash_bit_len bits.
  * @return
  *     Success or error code.
  * @see skein_reset
diff --git a/drivers/staging/skein/include/skein_block.h b/drivers/staging/skein/include/skein_block.h
index 41cae89..ec787a3 100644
--- a/drivers/staging/skein/include/skein_block.h
+++ b/drivers/staging/skein/include/skein_block.h
@@ -12,11 +12,11 @@
 
 #include <skein.h> /* get the Skein API definitions   */
 
-void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd);
-void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd);
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-			      size_t blkCnt, size_t byteCntAdd);
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add);
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add);
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+			      size_t blk_cnt, size_t byte_cnt_add);
 
 #endif
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefishApi.h
index 6cdad46..37f6e63 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefishApi.h
@@ -18,13 +18,13 @@
  *
 @code
     // Threefish cipher context data
-    struct threefish_key keyCtx;
+    struct threefish_key key_ctx;
 
     // Initialize the context
-    threefish_set_key(&keyCtx, Threefish512, key, tweak);
+    threefish_set_key(&key_ctx, Threefish512, key, tweak);
 
     // Encrypt
-    threefish_encrypt_block_bytes(&keyCtx, input, cipher);
+    threefish_encrypt_block_bytes(&key_ctx, input, cipher);
 @endcode
  */
 
@@ -51,7 +51,7 @@ enum threefish_size {
  * structures as well.
  */
 struct threefish_key {
-	u64 stateSize;
+	u64 state_size;
 	u64 key[SKEIN_MAX_STATE_WORDS+1];   /* max number of key words*/
 	u64 tweak[3];
 };
@@ -63,106 +63,106 @@ struct threefish_key {
  * the given size. The key data must have the same length (number of bits)
  * as the state size
  *
- * @param keyCtx
+ * @param key_ctx
  *     Pointer to a Threefish key structure.
  * @param size
  *     Which Skein size to use.
- * @param keyData
+ * @param key_data
  *     Pointer to the key words (word has 64 bits).
  * @param tweak
  *     Pointer to the two tweak words (word has 64 bits).
  */
-void threefish_set_key(struct threefish_key *keyCtx,
-		       enum threefish_size stateSize,
-		       u64 *keyData, u64 *tweak);
+void threefish_set_key(struct threefish_key *key_ctx,
+		       enum threefish_size state_size,
+		       u64 *key_data, u64 *tweak);
 
 /**
  * Encrypt Threefisch block (bytes).
  *
  * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
+ * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
  *
- * @param keyCtx
+ * @param key_ctx
  *     Pointer to a Threefish key structure.
  * @param in
  *     Poionter to plaintext data buffer.
  * @param out
  *     Pointer to cipher buffer.
  */
-void threefish_encrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+void threefish_encrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out);
 
 /**
  * Encrypt Threefisch block (words).
  *
  * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
+ * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
  *
  * The wordsize ist set to 64 bits.
  *
- * @param keyCtx
+ * @param key_ctx
  *     Pointer to a Threefish key structure.
  * @param in
  *     Poionter to plaintext data buffer.
  * @param out
  *     Pointer to cipher buffer.
  */
-void threefish_encrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+void threefish_encrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out);
 
 /**
  * Decrypt Threefisch block (bytes).
  *
  * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
+ * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, decrypts them and stores the result in the output
  * buffer
  *
- * @param keyCtx
+ * @param key_ctx
  *     Pointer to a Threefish key structure.
  * @param in
  *     Poionter to cipher data buffer.
  * @param out
  *     Pointer to plaintext buffer.
  */
-void threefish_decrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+void threefish_decrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out);
 
 /**
  * Decrypt Threefisch block (words).
  *
  * The buffer must have at least the same length (number of bits) aas the
- * state size for this key. The function uses the first @c stateSize bits
+ * state size for this key. The function uses the first @c state_size bits
  * of the input buffer, encrypts them and stores the result in the output
  * buffer.
  *
  * The wordsize ist set to 64 bits.
  *
- * @param keyCtx
+ * @param key_ctx
  *     Pointer to a Threefish key structure.
  * @param in
  *     Poionter to cipher data buffer.
  * @param out
  *     Pointer to plaintext buffer.
  */
-void threefish_decrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+void threefish_decrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out);
 
-void threefish_encrypt_256(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_256(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output);
-void threefish_encrypt_512(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_512(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output);
-void threefish_encrypt_1024(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_1024(struct threefish_key *key_ctx, u64 *input,
 			    u64 *output);
-void threefish_decrypt_256(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_256(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output);
-void threefish_decrypt_512(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_512(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output);
-void threefish_decrypt_1024(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_1024(struct threefish_key *key_ctx, u64 *input,
 			    u64 *output);
 /**
  * @}
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein.c
index ac64d9f..d4f3534 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein.c
@@ -21,17 +21,17 @@
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen)
+int skein_256_init(struct skein_256_ctx *ctx, size_t hash_bit_len)
 {
 	union {
-		u8  b[SKEIN_256_STATE_BYTES];
-		u64  w[SKEIN_256_STATE_WORDS];
+		u8 b[SKEIN_256_STATE_BYTES];
+		u64 w[SKEIN_256_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
-	switch (hashBitLen) { /* use pre-computed values, where available */
+	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  256:
 		memcpy(ctx->X, SKEIN_256_IV_256, sizeof(ctx->X));
 		break;
@@ -56,7 +56,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen)
 		/* set the schema, version */
 		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hashBitLen);
+		cfg.w[1] = Skein_Swap64(hash_bit_len);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
@@ -67,7 +67,7 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen)
 		skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
 		break;
 	}
-	/* The chaining vars ctx->X are now initialized for hashBitLen. */
+	/* The chaining vars ctx->X are now initialized for hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -76,34 +76,34 @@ int skein_256_init(struct skein_256_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_256_init() when keyBytes == 0 && \
- *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to skein_256_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes)
 {
 	union {
 		u8  b[SKEIN_256_STATE_BYTES];
-		u64  w[SKEIN_256_STATE_WORDS];
+		u64 w[SKEIN_256_STATE_WORDS];
 	} cfg; /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0) { /* is there a key? */
+	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		Skein_Start_New_Type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		skein_256_update(ctx, key, keyBytes);
+		skein_256_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_256_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
@@ -114,18 +114,18 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
 	 * precomputed for each key)
 	 */
 	/* output hash bit count */
-	ctx->h.hashBitLen = hashBitLen;
+	ctx->h.hash_bit_len = hash_bit_len;
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hashBitLen);
+	cfg.w[1] = Skein_Swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(treeInfo);
+	cfg.w[2] = Skein_Swap64(tree_info);
 
-	Skein_Show_Key(256, &ctx->h, key, keyBytes);
+	Skein_Show_Key(256, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_256_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
@@ -140,52 +140,53 @@ int skein_256_init_ext(struct skein_256_ctx *ctx, size_t hashBitLen,
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
 int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
-		     size_t msgByteCnt)
+		     size_t msg_byte_cnt)
 {
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN_256_BLOCK_BYTES) {
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_256_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt) {
+		if (ctx->h.b_cnt) {
 			/* # bytes free in buffer b[] */
-			n = SKEIN_256_BLOCK_BYTES - ctx->h.bCnt;
+			n = SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msgByteCnt);
-				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
-				msgByteCnt  -= n;
+				Skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
 				msg         += n;
-				ctx->h.bCnt += n;
+				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.bCnt == SKEIN_256_BLOCK_BYTES);
+			Skein_assert(ctx->h.b_cnt == SKEIN_256_BLOCK_BYTES);
 			skein_256_process_block(ctx, ctx->b, 1,
 						SKEIN_256_BLOCK_BYTES);
-			ctx->h.bCnt = 0;
+			ctx->h.b_cnt = 0;
 		}
 		/*
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN_256_BLOCK_BYTES) {
+		if (msg_byte_cnt > SKEIN_256_BLOCK_BYTES) {
 			/* number of full blocks to process */
-			n = (msgByteCnt-1) / SKEIN_256_BLOCK_BYTES;
+			n = (msg_byte_cnt-1) / SKEIN_256_BLOCK_BYTES;
 			skein_256_process_block(ctx, msg, n,
 						SKEIN_256_BLOCK_BYTES);
-			msgByteCnt -= n * SKEIN_256_BLOCK_BYTES;
+			msg_byte_cnt -= n * SKEIN_256_BLOCK_BYTES;
 			msg        += n * SKEIN_256_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.bCnt == 0);
+		Skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt) {
-		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
-		ctx->h.bCnt += msgByteCnt;
+	if (msg_byte_cnt) {
+		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_256_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
 	}
 
 	return SKEIN_SUCCESS;
@@ -193,47 +194,47 @@ int skein_256_update(struct skein_256_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int skein_256_final(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_final(struct skein_256_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
 
 	/* process the final block */
-	skein_256_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(256, &ctx->h, n,
-				 hashVal+i*SKEIN_256_BLOCK_BYTES);
+				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -246,17 +247,17 @@ int skein_256_final(struct skein_256_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen)
+int skein_512_init(struct skein_512_ctx *ctx, size_t hash_bit_len)
 {
 	union {
-		u8  b[SKEIN_512_STATE_BYTES];
-		u64  w[SKEIN_512_STATE_WORDS];
+		u8 b[SKEIN_512_STATE_BYTES];
+		u64 w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
-	switch (hashBitLen) { /* use pre-computed values, where available */
+	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  512:
 		memcpy(ctx->X, SKEIN_512_IV_512, sizeof(ctx->X));
 		break;
@@ -281,7 +282,7 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen)
 		/* set the schema, version */
 		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hashBitLen);
+		cfg.w[1] = Skein_Swap64(hash_bit_len);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
@@ -295,7 +296,7 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen)
 
 	/*
 	 * The chaining vars ctx->X are now initialized for the given
-	 * hashBitLen.
+	 * hash_bit_len.
 	 */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
@@ -305,34 +306,34 @@ int skein_512_init(struct skein_512_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_512_init() when keyBytes == 0 && \
- *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
-		       u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to skein_512_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hash_bit_len,
+		       u64 tree_info, const u8 *key, size_t key_bytes)
 {
 	union {
-		u8  b[SKEIN_512_STATE_BYTES];
-		u64  w[SKEIN_512_STATE_WORDS];
+		u8 b[SKEIN_512_STATE_BYTES];
+		u64 w[SKEIN_512_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0) { /* is there a key? */
+	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		Skein_Start_New_Type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		skein_512_update(ctx, key, keyBytes);
+		skein_512_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_512_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
@@ -342,18 +343,18 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
 	 * build/process the config block, type == CONFIG (could be
 	 * precomputed for each key)
 	 */
-	ctx->h.hashBitLen = hashBitLen;             /* output hash bit count */
+	ctx->h.hash_bit_len = hash_bit_len;          /* output hash bit count */
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hashBitLen);
+	cfg.w[1] = Skein_Swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(treeInfo);
+	cfg.w[2] = Skein_Swap64(tree_info);
 
-	Skein_Show_Key(512, &ctx->h, key, keyBytes);
+	Skein_Show_Key(512, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_512_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
@@ -368,52 +369,53 @@ int skein_512_init_ext(struct skein_512_ctx *ctx, size_t hashBitLen,
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
 int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
-		     size_t msgByteCnt)
+		     size_t msg_byte_cnt)
 {
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN_512_BLOCK_BYTES) {
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN_512_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt) {
+		if (ctx->h.b_cnt) {
 			/* # bytes free in buffer b[] */
-			n = SKEIN_512_BLOCK_BYTES - ctx->h.bCnt;
+			n = SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msgByteCnt);
-				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
-				msgByteCnt  -= n;
+				Skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
 				msg         += n;
-				ctx->h.bCnt += n;
+				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.bCnt == SKEIN_512_BLOCK_BYTES);
+			Skein_assert(ctx->h.b_cnt == SKEIN_512_BLOCK_BYTES);
 			skein_512_process_block(ctx, ctx->b, 1,
 						SKEIN_512_BLOCK_BYTES);
-			ctx->h.bCnt = 0;
+			ctx->h.b_cnt = 0;
 		}
 		/*
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN_512_BLOCK_BYTES) {
+		if (msg_byte_cnt > SKEIN_512_BLOCK_BYTES) {
 			/* number of full blocks to process */
-			n = (msgByteCnt-1) / SKEIN_512_BLOCK_BYTES;
+			n = (msg_byte_cnt-1) / SKEIN_512_BLOCK_BYTES;
 			skein_512_process_block(ctx, msg, n,
 						SKEIN_512_BLOCK_BYTES);
-			msgByteCnt -= n * SKEIN_512_BLOCK_BYTES;
+			msg_byte_cnt -= n * SKEIN_512_BLOCK_BYTES;
 			msg        += n * SKEIN_512_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.bCnt == 0);
+		Skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt) {
-		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
-		ctx->h.bCnt += msgByteCnt;
+	if (msg_byte_cnt) {
+		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN_512_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
 	}
 
 	return SKEIN_SUCCESS;
@@ -421,47 +423,47 @@ int skein_512_update(struct skein_512_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int skein_512_final(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_final(struct skein_512_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
 
 	/* process the final block */
-	skein_512_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(512, &ctx->h, n,
-				 hashVal+i*SKEIN_512_BLOCK_BYTES);
+				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -474,17 +476,17 @@ int skein_512_final(struct skein_512_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a straight hashing operation  */
-int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen)
+int skein_1024_init(struct skein1024_ctx *ctx, size_t hash_bit_len)
 {
 	union {
-		u8  b[SKEIN1024_STATE_BYTES];
-		u64  w[SKEIN1024_STATE_WORDS];
+		u8 b[SKEIN1024_STATE_BYTES];
+		u64 w[SKEIN1024_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	ctx->h.hashBitLen = hashBitLen;         /* output hash bit count */
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	ctx->h.hash_bit_len = hash_bit_len;         /* output hash bit count */
 
-	switch (hashBitLen) { /* use pre-computed values, where available */
+	switch (hash_bit_len) { /* use pre-computed values, where available */
 	case  512:
 		memcpy(ctx->X, SKEIN1024_IV_512, sizeof(ctx->X));
 		break;
@@ -506,7 +508,7 @@ int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen)
 		/* set the schema, version */
 		cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 		/* hash result length in bits */
-		cfg.w[1] = Skein_Swap64(hashBitLen);
+		cfg.w[1] = Skein_Swap64(hash_bit_len);
 		cfg.w[2] = Skein_Swap64(SKEIN_CFG_TREE_INFO_SEQUENTIAL);
 		/* zero pad config block */
 		memset(&cfg.w[3], 0, sizeof(cfg) - 3*sizeof(cfg.w[0]));
@@ -518,7 +520,7 @@ int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen)
 		break;
 	}
 
-	/* The chaining vars ctx->X are now initialized for the hashBitLen. */
+	/* The chaining vars ctx->X are now initialized for the hash_bit_len. */
 	/* Set up to process the data message portion of the hash (default) */
 	Skein_Start_New_Type(ctx, MSG);              /* T0=0, T1= MSG type */
 
@@ -527,34 +529,34 @@ int skein_1024_init(struct skein1024_ctx *ctx, size_t hashBitLen)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* init the context for a MAC and/or tree hash operation */
-/* [identical to skein_1024_init() when keyBytes == 0 && \
- *	treeInfo == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
-int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
-			u64 treeInfo, const u8 *key, size_t keyBytes)
+/* [identical to skein_1024_init() when key_bytes == 0 && \
+ *	tree_info == SKEIN_CFG_TREE_INFO_SEQUENTIAL] */
+int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hash_bit_len,
+			u64 tree_info, const u8 *key, size_t key_bytes)
 {
 	union {
-		u8  b[SKEIN1024_STATE_BYTES];
-		u64  w[SKEIN1024_STATE_WORDS];
+		u8 b[SKEIN1024_STATE_BYTES];
+		u64 w[SKEIN1024_STATE_WORDS];
 	} cfg;                              /* config block */
 
-	Skein_Assert(hashBitLen > 0, SKEIN_BAD_HASHLEN);
-	Skein_Assert(keyBytes == 0 || key != NULL, SKEIN_FAIL);
+	Skein_Assert(hash_bit_len > 0, SKEIN_BAD_HASHLEN);
+	Skein_Assert(key_bytes == 0 || key != NULL, SKEIN_FAIL);
 
 	/* compute the initial chaining values ctx->X[], based on key */
-	if (keyBytes == 0) { /* is there a key? */
+	if (key_bytes == 0) { /* is there a key? */
 		/* no key: use all zeroes as key for config block */
 		memset(ctx->X, 0, sizeof(ctx->X));
 	} else { /* here to pre-process a key */
 		Skein_assert(sizeof(cfg.b) >= sizeof(ctx->X));
 		/* do a mini-Init right here */
 		/* set output hash bit count = state size */
-		ctx->h.hashBitLen = 8*sizeof(ctx->X);
+		ctx->h.hash_bit_len = 8*sizeof(ctx->X);
 		/* set tweaks: T0 = 0; T1 = KEY type */
 		Skein_Start_New_Type(ctx, KEY);
 		/* zero the initial chaining variables */
 		memset(ctx->X, 0, sizeof(ctx->X));
 		/* hash the key */
-		skein_1024_update(ctx, key, keyBytes);
+		skein_1024_update(ctx, key, key_bytes);
 		/* put result into cfg.b[] */
 		skein_1024_final_pad(ctx, cfg.b);
 		/* copy over into ctx->X[] */
@@ -565,18 +567,18 @@ int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
 	 * precomputed for each key)
 	 */
 	/* output hash bit count */
-	ctx->h.hashBitLen = hashBitLen;
+	ctx->h.hash_bit_len = hash_bit_len;
 	Skein_Start_New_Type(ctx, CFG_FINAL);
 
 	/* pre-pad cfg.w[] with zeroes */
 	memset(&cfg.w, 0, sizeof(cfg.w));
 	cfg.w[0] = Skein_Swap64(SKEIN_SCHEMA_VER);
 	/* hash result length in bits */
-	cfg.w[1] = Skein_Swap64(hashBitLen);
+	cfg.w[1] = Skein_Swap64(hash_bit_len);
 	/* tree hash config info (or SKEIN_CFG_TREE_INFO_SEQUENTIAL) */
-	cfg.w[2] = Skein_Swap64(treeInfo);
+	cfg.w[2] = Skein_Swap64(tree_info);
 
-	Skein_Show_Key(1024, &ctx->h, key, keyBytes);
+	Skein_Show_Key(1024, &ctx->h, key, key_bytes);
 
 	/* compute the initial chaining values from config block */
 	skein_1024_process_block(ctx, cfg.b, 1, SKEIN_CFG_STR_LEN);
@@ -591,52 +593,53 @@ int skein_1024_init_ext(struct skein1024_ctx *ctx, size_t hashBitLen,
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* process the input bytes */
 int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
-		      size_t msgByteCnt)
+		      size_t msg_byte_cnt)
 {
 	size_t n;
 
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* process full blocks, if any */
-	if (msgByteCnt + ctx->h.bCnt > SKEIN1024_BLOCK_BYTES) {
+	if (msg_byte_cnt + ctx->h.b_cnt > SKEIN1024_BLOCK_BYTES) {
 		/* finish up any buffered message data */
-		if (ctx->h.bCnt) {
+		if (ctx->h.b_cnt) {
 			/* # bytes free in buffer b[] */
-			n = SKEIN1024_BLOCK_BYTES - ctx->h.bCnt;
+			n = SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt;
 			if (n) {
 				/* check on our logic here */
-				Skein_assert(n < msgByteCnt);
-				memcpy(&ctx->b[ctx->h.bCnt], msg, n);
-				msgByteCnt  -= n;
+				Skein_assert(n < msg_byte_cnt);
+				memcpy(&ctx->b[ctx->h.b_cnt], msg, n);
+				msg_byte_cnt  -= n;
 				msg         += n;
-				ctx->h.bCnt += n;
+				ctx->h.b_cnt += n;
 			}
-			Skein_assert(ctx->h.bCnt == SKEIN1024_BLOCK_BYTES);
+			Skein_assert(ctx->h.b_cnt == SKEIN1024_BLOCK_BYTES);
 			skein_1024_process_block(ctx, ctx->b, 1,
 						 SKEIN1024_BLOCK_BYTES);
-			ctx->h.bCnt = 0;
+			ctx->h.b_cnt = 0;
 		}
 		/*
 		 * now process any remaining full blocks, directly from input
 		 * message data
 		 */
-		if (msgByteCnt > SKEIN1024_BLOCK_BYTES) {
+		if (msg_byte_cnt > SKEIN1024_BLOCK_BYTES) {
 			/* number of full blocks to process */
-			n = (msgByteCnt-1) / SKEIN1024_BLOCK_BYTES;
+			n = (msg_byte_cnt-1) / SKEIN1024_BLOCK_BYTES;
 			skein_1024_process_block(ctx, msg, n,
 						 SKEIN1024_BLOCK_BYTES);
-			msgByteCnt -= n * SKEIN1024_BLOCK_BYTES;
+			msg_byte_cnt -= n * SKEIN1024_BLOCK_BYTES;
 			msg        += n * SKEIN1024_BLOCK_BYTES;
 		}
-		Skein_assert(ctx->h.bCnt == 0);
+		Skein_assert(ctx->h.b_cnt == 0);
 	}
 
 	/* copy any remaining source message data bytes into b[] */
-	if (msgByteCnt) {
-		Skein_assert(msgByteCnt + ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES);
-		memcpy(&ctx->b[ctx->h.bCnt], msg, msgByteCnt);
-		ctx->h.bCnt += msgByteCnt;
+	if (msg_byte_cnt) {
+		Skein_assert(msg_byte_cnt + ctx->h.b_cnt <=
+			     SKEIN1024_BLOCK_BYTES);
+		memcpy(&ctx->b[ctx->h.b_cnt], msg, msg_byte_cnt);
+		ctx->h.b_cnt += msg_byte_cnt;
 	}
 
 	return SKEIN_SUCCESS;
@@ -644,47 +647,47 @@ int skein_1024_update(struct skein1024_ctx *ctx, const u8 *msg,
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the result */
-int skein_1024_final(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_final(struct skein1024_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN1024_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt);
 
 	/* process the final block */
-	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
 			n  = SKEIN1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN1024_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(1024, &ctx->h, n,
-				 hashVal+i*SKEIN1024_BLOCK_BYTES);
+				 hash_val+i*SKEIN1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -696,66 +699,66 @@ int skein_1024_final(struct skein1024_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_final_pad(struct skein_256_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN_256_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN_256_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN_256_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_256_BLOCK_BYTES - ctx->h.b_cnt);
 	/* process the final block */
-	skein_256_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_256_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_256_BLOCK_BYTES);
+	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN_256_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_final_pad(struct skein_512_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN_512_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN_512_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN_512_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN_512_BLOCK_BYTES - ctx->h.b_cnt);
 	/* process the final block */
-	skein_512_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_512_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN_512_BLOCK_BYTES);
+	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN_512_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* finalize the hash computation and output the block, no OUTPUT stage */
-int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hash_val)
 {
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* tag as the final block */
 	ctx->h.T[1] |= SKEIN_T1_FLAG_FINAL;
 	/* zero pad b[] if necessary */
-	if (ctx->h.bCnt < SKEIN1024_BLOCK_BYTES)
-		memset(&ctx->b[ctx->h.bCnt], 0,
-			SKEIN1024_BLOCK_BYTES - ctx->h.bCnt);
+	if (ctx->h.b_cnt < SKEIN1024_BLOCK_BYTES)
+		memset(&ctx->b[ctx->h.b_cnt], 0,
+			SKEIN1024_BLOCK_BYTES - ctx->h.b_cnt);
 	/* process the final block */
-	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.bCnt);
+	skein_1024_process_block(ctx, ctx->b, 1, ctx->h.b_cnt);
 
 	/* "output" the state bytes */
-	Skein_Put64_LSB_First(hashVal, ctx->X, SKEIN1024_BLOCK_BYTES);
+	Skein_Put64_LSB_First(hash_val, ctx->X, SKEIN1024_BLOCK_BYTES);
 
 	return SKEIN_SUCCESS;
 }
@@ -763,37 +766,37 @@ int skein_1024_final_pad(struct skein1024_ctx *ctx, u8 *hashVal)
 #if SKEIN_TREE_HASH
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int skein_256_output(struct skein_256_ctx *ctx, u8 *hashVal)
+int skein_256_output(struct skein_256_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN_256_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_256_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN_256_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_256_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN_256_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_256_BLOCK_BYTES;
 		if (n >= SKEIN_256_BLOCK_BYTES)
 			n  = SKEIN_256_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_256_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN_256_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(256, &ctx->h, n,
-				 hashVal+i*SKEIN_256_BLOCK_BYTES);
+				 hash_val+i*SKEIN_256_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -802,37 +805,37 @@ int skein_256_output(struct skein_256_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int skein_512_output(struct skein_512_ctx *ctx, u8 *hashVal)
+int skein_512_output(struct skein_512_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN_512_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN_512_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN_512_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_512_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN_512_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN_512_BLOCK_BYTES;
 		if (n >= SKEIN_512_BLOCK_BYTES)
 			n  = SKEIN_512_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN_512_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN_512_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(256, &ctx->h, n,
-				 hashVal+i*SKEIN_512_BLOCK_BYTES);
+				 hash_val+i*SKEIN_512_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
@@ -841,37 +844,37 @@ int skein_512_output(struct skein_512_ctx *ctx, u8 *hashVal)
 
 /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
 /* just do the OUTPUT stage                                       */
-int skein_1024_output(struct skein1024_ctx *ctx, u8 *hashVal)
+int skein_1024_output(struct skein1024_ctx *ctx, u8 *hash_val)
 {
-	size_t i, n, byteCnt;
+	size_t i, n, byte_cnt;
 	u64 X[SKEIN1024_STATE_WORDS];
 	/* catch uninitialized context */
-	Skein_Assert(ctx->h.bCnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
+	Skein_Assert(ctx->h.b_cnt <= SKEIN1024_BLOCK_BYTES, SKEIN_FAIL);
 
 	/* now output the result */
 	/* total number of output bytes */
-	byteCnt = (ctx->h.hashBitLen + 7) >> 3;
+	byte_cnt = (ctx->h.hash_bit_len + 7) >> 3;
 
 	/* run Threefish in "counter mode" to generate output */
 	/* zero out b[], so it can hold the counter */
 	memset(ctx->b, 0, sizeof(ctx->b));
 	/* keep a local copy of counter mode "key" */
 	memcpy(X, ctx->X, sizeof(X));
-	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byteCnt; i++) {
+	for (i = 0; i*SKEIN1024_BLOCK_BYTES < byte_cnt; i++) {
 		/* build the counter block */
 		((u64 *)ctx->b)[0] = Skein_Swap64((u64) i);
 		Skein_Start_New_Type(ctx, OUT_FINAL);
 		/* run "counter mode" */
 		skein_1024_process_block(ctx, ctx->b, 1, sizeof(u64));
 		/* number of output bytes left to go */
-		n = byteCnt - i*SKEIN1024_BLOCK_BYTES;
+		n = byte_cnt - i*SKEIN1024_BLOCK_BYTES;
 		if (n >= SKEIN1024_BLOCK_BYTES)
 			n  = SKEIN1024_BLOCK_BYTES;
 		/* "output" the ctr mode bytes */
-		Skein_Put64_LSB_First(hashVal+i*SKEIN1024_BLOCK_BYTES, ctx->X,
+		Skein_Put64_LSB_First(hash_val+i*SKEIN1024_BLOCK_BYTES, ctx->X,
 				      n);
 		Skein_Show_Final(256, &ctx->h, n,
-				 hashVal+i*SKEIN1024_BLOCK_BYTES);
+				 hash_val+i*SKEIN1024_BLOCK_BYTES);
 		/* restore the counter mode key for next time */
 		memcpy(ctx->X, X, sizeof(X));
 	}
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index c4f5333..3426392 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -32,17 +32,17 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 	Skein_Assert(ctx && size, SKEIN_FAIL);
 
 	memset(ctx , 0, sizeof(struct skein_ctx));
-	ctx->skeinSize = size;
+	ctx->skein_size = size;
 
 	return SKEIN_SUCCESS;
 }
 
-int skein_init(struct skein_ctx *ctx, size_t hashBitLen)
+int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
 {
 	int ret = SKEIN_FAIL;
-	size_t Xlen = 0;
+	size_t X_len = 0;
 	u64 *X = NULL;
-	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
 	Skein_Assert(ctx, SKEIN_FAIL);
 	/*
@@ -51,83 +51,83 @@ int skein_init(struct skein_ctx *ctx, size_t hashBitLen)
 	 * memory available.  The beauty of C :-) .
 	 */
 	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
+	X_len = ctx->skein_size/8;
 	/*
 	 * If size is the same and hash bit length is zero then reuse
 	 * the save chaining variables.
 	 */
-	switch (ctx->skeinSize) {
+	switch (ctx->skein_size) {
 	case Skein256:
-		ret = skein_256_init_ext(&ctx->m.s256, hashBitLen,
-					 treeInfo, NULL, 0);
+		ret = skein_256_init_ext(&ctx->m.s256, hash_bit_len,
+					 tree_info, NULL, 0);
 		break;
 	case Skein512:
-		ret = skein_512_init_ext(&ctx->m.s512, hashBitLen,
-					 treeInfo, NULL, 0);
+		ret = skein_512_init_ext(&ctx->m.s512, hash_bit_len,
+					 tree_info, NULL, 0);
 		break;
 	case Skein1024:
-		ret = skein_1024_init_ext(&ctx->m.s1024, hashBitLen,
-					  treeInfo, NULL, 0);
+		ret = skein_1024_init_ext(&ctx->m.s1024, hash_bit_len,
+					  tree_info, NULL, 0);
 		break;
 	}
 
 	if (ret == SKEIN_SUCCESS) {
 		/*
 		 * Save chaining variables for this combination of size and
-		 * hashBitLen
+		 * hash_bit_len
 		 */
-		memcpy(ctx->XSave, X, Xlen);
+		memcpy(ctx->X_save, X, X_len);
 	}
 	return ret;
 }
 
-int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
-		   size_t hashBitLen)
+int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
+		   size_t hash_bit_len)
 {
 	int ret = SKEIN_FAIL;
 	u64 *X = NULL;
-	size_t Xlen = 0;
-	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
+	size_t X_len = 0;
+	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
 
 	Skein_Assert(ctx, SKEIN_FAIL);
 
 	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
+	X_len = ctx->skein_size/8;
 
-	Skein_Assert(hashBitLen, SKEIN_BAD_HASHLEN);
+	Skein_Assert(hash_bit_len, SKEIN_BAD_HASHLEN);
 
-	switch (ctx->skeinSize) {
+	switch (ctx->skein_size) {
 	case Skein256:
-		ret = skein_256_init_ext(&ctx->m.s256, hashBitLen,
-					 treeInfo,
-					 (const u8 *)key, keyLen);
+		ret = skein_256_init_ext(&ctx->m.s256, hash_bit_len,
+					 tree_info,
+					 (const u8 *)key, key_len);
 
 		break;
 	case Skein512:
-		ret = skein_512_init_ext(&ctx->m.s512, hashBitLen,
-					 treeInfo,
-					 (const u8 *)key, keyLen);
+		ret = skein_512_init_ext(&ctx->m.s512, hash_bit_len,
+					 tree_info,
+					 (const u8 *)key, key_len);
 		break;
 	case Skein1024:
-		ret = skein_1024_init_ext(&ctx->m.s1024, hashBitLen,
-					  treeInfo,
-					  (const u8 *)key, keyLen);
+		ret = skein_1024_init_ext(&ctx->m.s1024, hash_bit_len,
+					  tree_info,
+					  (const u8 *)key, key_len);
 
 		break;
 	}
 	if (ret == SKEIN_SUCCESS) {
 		/*
 		 * Save chaining variables for this combination of key,
-		 * keyLen, hashBitLen
+		 * key_len, hash_bit_len
 		 */
-		memcpy(ctx->XSave, X, Xlen);
+		memcpy(ctx->X_save, X, X_len);
 	}
 	return ret;
 }
 
 void skein_reset(struct skein_ctx *ctx)
 {
-	size_t Xlen = 0;
+	size_t X_len = 0;
 	u64 *X = NULL;
 
 	/*
@@ -136,32 +136,33 @@ void skein_reset(struct skein_ctx *ctx)
 	 * memory available.  The beautiy of C :-) .
 	 */
 	X = ctx->m.s256.X;
-	Xlen = ctx->skeinSize/8;
+	X_len = ctx->skein_size/8;
 	/* Restore the chaing variable, reset byte counter */
-	memcpy(X, ctx->XSave, Xlen);
+	memcpy(X, ctx->X_save, X_len);
 
 	/* Setup context to process the message */
 	Skein_Start_New_Type(&ctx->m, MSG);
 }
 
 int skein_update(struct skein_ctx *ctx, const u8 *msg,
-		 size_t msgByteCnt)
+		 size_t msg_byte_cnt)
 {
 	int ret = SKEIN_FAIL;
+
 	Skein_Assert(ctx, SKEIN_FAIL);
 
-	switch (ctx->skeinSize) {
+	switch (ctx->skein_size) {
 	case Skein256:
 		ret = skein_256_update(&ctx->m.s256, (const u8 *)msg,
-				       msgByteCnt);
+				       msg_byte_cnt);
 		break;
 	case Skein512:
 		ret = skein_512_update(&ctx->m.s512, (const u8 *)msg,
-				       msgByteCnt);
+				       msg_byte_cnt);
 		break;
 	case Skein1024:
 		ret = skein_1024_update(&ctx->m.s1024, (const u8 *)msg,
-					msgByteCnt);
+					msg_byte_cnt);
 		break;
 	}
 	return ret;
@@ -169,7 +170,7 @@ int skein_update(struct skein_ctx *ctx, const u8 *msg,
 }
 
 int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
-		      size_t msgBitCnt)
+		      size_t msg_bit_cnt)
 {
 	/*
 	 * I've used the bit pad implementation from skein_test.c (see NIST CD)
@@ -185,13 +186,13 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 	 * assert an error
 	 */
 	Skein_Assert((ctx->m.h.T[1] & SKEIN_T1_FLAG_BIT_PAD) == 0 ||
-			msgBitCnt == 0, SKEIN_FAIL);
+			msg_bit_cnt == 0, SKEIN_FAIL);
 
 	/* if number of bits is a multiple of bytes - that's easy */
-	if ((msgBitCnt & 0x7) == 0)
-		return skein_update(ctx, msg, msgBitCnt >> 3);
+	if ((msg_bit_cnt & 0x7) == 0)
+		return skein_update(ctx, msg, msg_bit_cnt >> 3);
 
-	skein_update(ctx, msg, (msgBitCnt >> 3) + 1);
+	skein_update(ctx, msg, (msg_bit_cnt >> 3) + 1);
 
 	/*
 	 * The next line rely on the fact that the real Skein contexts
@@ -199,18 +200,18 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 	 * Skein's real partial block buffer.
 	 * If this layout ever changes we have to adapt this as well.
 	 */
-	up = (u8 *)ctx->m.s256.X + ctx->skeinSize / 8;
+	up = (u8 *)ctx->m.s256.X + ctx->skein_size / 8;
 
 	/* set tweak flag for the skein_final call */
 	Skein_Set_Bit_Pad_Flag(ctx->m.h);
 
 	/* now "pad" the final partial byte the way NIST likes */
-	/* get the bCnt value (same location for all block sizes) */
-	length = ctx->m.h.bCnt;
+	/* get the b_cnt value (same location for all block sizes) */
+	length = ctx->m.h.b_cnt;
 	/* internal sanity check: there IS a partial byte in the buffer! */
 	Skein_assert(length != 0);
 	/* partial byte bit mask */
-	mask = (u8) (1u << (7 - (msgBitCnt & 7)));
+	mask = (u8) (1u << (7 - (msg_bit_cnt & 7)));
 	/* apply bit padding on final byte (in the buffer) */
 	up[length-1]  = (u8)((up[length-1] & (0-mask))|mask);
 
@@ -220,9 +221,10 @@ int skein_update_bits(struct skein_ctx *ctx, const u8 *msg,
 int skein_final(struct skein_ctx *ctx, u8 *hash)
 {
 	int ret = SKEIN_FAIL;
+
 	Skein_Assert(ctx, SKEIN_FAIL);
 
-	switch (ctx->skeinSize) {
+	switch (ctx->skein_size) {
 	case Skein256:
 		ret = skein_256_final(&ctx->m.s256, (u8 *)hash);
 		break;
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skeinBlockNo3F.c
index 0acb617..041e5ae 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skeinBlockNo3F.c
@@ -5,8 +5,8 @@
 
 
 /*****************************  Skein_256 ******************************/
-void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd)
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -14,12 +14,12 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 	u64  w[SKEIN_256_STATE_WORDS]; /* local copy of input block */
 	u64 words[3];
 
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
 	do  {
-		u64 carry = byteCntAdd;
+		u64 carry = byte_cnt_add;
 
 		words[0] = tweak[0] & 0xffffffffL;
 		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
@@ -37,11 +37,11 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		threefish_set_key(&key, Threefish256, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_256_STATE_WORDS);
+		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_256_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
-		blkPtr += SKEIN_256_BLOCK_BYTES;
+		blk_ptr += SKEIN_256_BLOCK_BYTES;
 
 		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0] = ctx->X[0] ^ w[0];
@@ -50,14 +50,14 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		ctx->X[3] = ctx->X[3] ^ w[3];
 
 		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
+	} while (--blk_cnt);
 
 	ctx->h.T[0] = tweak[0];
 	ctx->h.T[1] = tweak[1];
 }
 
-void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd)
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -65,12 +65,12 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	u64 words[3];
 	u64  w[SKEIN_512_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
 	do  {
-		u64 carry = byteCntAdd;
+		u64 carry = byte_cnt_add;
 
 		words[0] = tweak[0] & 0xffffffffL;
 		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
@@ -88,11 +88,11 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		threefish_set_key(&key, Threefish512, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN_512_STATE_WORDS);
+		Skein_Get64_LSB_First(w, blk_ptr, SKEIN_512_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
-		blkPtr += SKEIN_512_BLOCK_BYTES;
+		blk_ptr += SKEIN_512_BLOCK_BYTES;
 
 		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0] = ctx->X[0] ^ w[0];
@@ -105,14 +105,14 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		ctx->X[7] = ctx->X[7] ^ w[7];
 
 		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
+	} while (--blk_cnt);
 
 	ctx->h.T[0] = tweak[0];
 	ctx->h.T[1] = tweak[1];
 }
 
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-			      size_t blkCnt, size_t byteCntAdd)
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+			      size_t blk_cnt, size_t byte_cnt_add)
 {
 	struct threefish_key key;
 	u64 tweak[2];
@@ -120,12 +120,12 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 	u64 words[3];
 	u64  w[SKEIN1024_STATE_WORDS]; /* local copy of input block */
 
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	tweak[0] = ctx->h.T[0];
 	tweak[1] = ctx->h.T[1];
 
 	do  {
-		u64 carry = byteCntAdd;
+		u64 carry = byte_cnt_add;
 
 		words[0] = tweak[0] & 0xffffffffL;
 		words[1] = ((tweak[0] >> 32) & 0xffffffffL);
@@ -143,11 +143,11 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		threefish_set_key(&key, Threefish1024, ctx->X, tweak);
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, SKEIN1024_STATE_WORDS);
+		Skein_Get64_LSB_First(w, blk_ptr, SKEIN1024_STATE_WORDS);
 
 		threefish_encrypt_block_words(&key, w, ctx->X);
 
-		blkPtr += SKEIN1024_BLOCK_BYTES;
+		blk_ptr += SKEIN1024_BLOCK_BYTES;
 
 		/* do the final "feedforward" xor, update ctx chaining vars */
 		ctx->X[0]  = ctx->X[0]  ^ w[0];
@@ -168,7 +168,7 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		ctx->X[15] = ctx->X[15] ^ w[15];
 
 		tweak[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
+	} while (--blk_cnt);
 
 	ctx->h.T[0] = tweak[0];
 	ctx->h.T[1] = tweak[1];
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 1195aec..a51aa57 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -39,8 +39,8 @@
 
 /*****************************  Skein_256 ******************************/
 #if !(SKEIN_USE_ASM & 256)
-void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd)
+void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add)
 	{ /* do it in C */
 	enum {
 		WCNT = SKEIN_256_STATE_WORDS
@@ -66,10 +66,11 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 	u64  X0, X1, X2, X3; /* local copy of context vars, for speed */
 	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[4]; /* use for debugging (help cc put Xn in regs) */
-	Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
+	const u64 *X_ptr[4]; /* use for debugging (help cc put Xn in regs) */
+
+	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
 #endif
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -77,7 +78,7 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		 * this implementation only supports 2**64 input bytes
 		 * (no carry out here)
 		 */
-		ts[0] += byteCntAdd; /* update processed length */
+		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0] = ctx->X[0];
@@ -89,9 +90,9 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		ts[2] = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, WCNT);
+		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
 		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
+		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X0 = w[0] + ks[0]; /* do the first full key injection */
 		X1 = w[1] + ks[1] + ts[0];
@@ -100,23 +101,23 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 
 		/* show starting state values */
 		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 Xptr);
+				 X_ptr);
 
-		blkPtr += SKEIN_256_BLOCK_BYTES;
+		blk_ptr += SKEIN_256_BLOCK_BYTES;
 
 		/* run the rounds */
 
-#define Round256(p0, p1, p2, p3, ROT, rNum)                              \
+#define Round256(p0, p1, p2, p3, ROT, r_num)                              \
 do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 } while (0)
 
 #if SKEIN_UNROLL_256 == 0
-#define R256(p0, p1, p2, p3, ROT, rNum) /* fully unrolled */ \
+#define R256(p0, p1, p2, p3, ROT, r_num) /* fully unrolled */ \
 do { \
-	Round256(p0, p1, p2, p3, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr); \
+	Round256(p0, p1, p2, p3, ROT, r_num); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
 } while (0)
 
 #define I256(R) \
@@ -126,13 +127,13 @@ do { \
 	X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3]; \
 	X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3]; \
 	X3   += ks[((R)+4) % 5] +     (R)+1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
-#define R256(p0, p1, p2, p3, ROT, rNum) \
+#define R256(p0, p1, p2, p3, ROT, r_num) \
 do { \
-	Round256(p0, p1, p2, p3, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr); \
+	Round256(p0, p1, p2, p3, ROT, r_num); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I256(R) \
@@ -145,7 +146,7 @@ do { \
 	/* rotate key schedule */ \
 	ks[r + (R) + 4]   = ks[r + (R) - 1]; \
 	ts[r + (R) + 2]   = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
@@ -227,7 +228,7 @@ do { \
 		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
+	} while (--blk_cnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
@@ -247,8 +248,8 @@ unsigned int skein_256_unroll_cnt(void)
 
 /*****************************  Skein_512 ******************************/
 #if !(SKEIN_USE_ASM & 512)
-void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
-			     size_t blkCnt, size_t byteCntAdd)
+void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blk_ptr,
+			     size_t blk_cnt, size_t byte_cnt_add)
 { /* do it in C */
 	enum {
 		WCNT = SKEIN_512_STATE_WORDS
@@ -274,12 +275,13 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	u64  X0, X1, X2, X3, X4, X5, X6, X7; /* local copies, for speed */
 	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[8]; /* use for debugging (help cc put Xn in regs) */
-	Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
-	Xptr[4] = &X4;  Xptr[5] = &X5;  Xptr[6] = &X6;  Xptr[7] = &X7;
+	const u64 *X_ptr[8]; /* use for debugging (help cc put Xn in regs) */
+
+	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;
+	X_ptr[4] = &X4;  X_ptr[5] = &X5;  X_ptr[6] = &X6;  X_ptr[7] = &X7;
 #endif
 
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -287,7 +289,7 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		 * this implementation only supports 2**64 input bytes
 		 * (no carry out here)
 		 */
-		ts[0] += byteCntAdd; /* update processed length */
+		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0] = ctx->X[0];
@@ -304,9 +306,9 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		ts[2] = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, WCNT);
+		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
 		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
+		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X0   = w[0] + ks[0]; /* do the first full key injection */
 		X1   = w[1] + ks[1];
@@ -317,12 +319,12 @@ void skein_512_process_block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		X6   = w[6] + ks[6] + ts[1];
 		X7   = w[7] + ks[7];
 
-		blkPtr += SKEIN_512_BLOCK_BYTES;
+		blk_ptr += SKEIN_512_BLOCK_BYTES;
 
 		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 Xptr);
+				 X_ptr);
 		/* run the rounds */
-#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+#define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
 do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
@@ -331,10 +333,10 @@ do { \
 } while (0)
 
 #if SKEIN_UNROLL_512 == 0
-#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) /* unrolled */ \
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) /* unrolled */ \
 do { \
-	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr); \
+	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, r_num, X_ptr); \
 } while (0)
 
 #define I512(R) \
@@ -348,13 +350,13 @@ do { \
 	X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3]; \
 	X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3]; \
 	X7   += ks[((R) + 8) % 9] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
-#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) \
 do { \
-	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr); \
+	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + r_num, X_ptr); \
 } while (0)
 
 #define I512(R) \
@@ -371,7 +373,7 @@ do { \
 	/* rotate key schedule */ \
 	ks[r +         (R) + 8] = ks[r + (R) - 1]; \
 	ts[r +         (R) + 2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
@@ -457,7 +459,7 @@ do { \
 		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-	} while (--blkCnt);
+	} while (--blk_cnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
@@ -477,8 +479,8 @@ unsigned int skein_512_unroll_cnt(void)
 
 /*****************************  Skein1024 ******************************/
 #if !(SKEIN_USE_ASM & 1024)
-void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
-			      size_t blkCnt, size_t byteCntAdd)
+void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blk_ptr,
+			      size_t blk_cnt, size_t byte_cnt_add)
 { /* do it in C, always looping (unrolled is bigger AND slower!) */
 	enum {
 		WCNT = SKEIN1024_STATE_WORDS
@@ -507,14 +509,17 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 	     X08, X09, X10, X11, X12, X13, X14, X15;
 	u64  w[WCNT]; /* local copy of input block */
 #ifdef SKEIN_DEBUG
-	const u64 *Xptr[16]; /* use for debugging (help cc put Xn in regs) */
-	Xptr[0]  = &X00;  Xptr[1]  = &X01;  Xptr[2]  = &X02;  Xptr[3]  = &X03;
-	Xptr[4]  = &X04;  Xptr[5]  = &X05;  Xptr[6]  = &X06;  Xptr[7]  = &X07;
-	Xptr[8]  = &X08;  Xptr[9]  = &X09;  Xptr[10] = &X10;  Xptr[11] = &X11;
-	Xptr[12] = &X12;  Xptr[13] = &X13;  Xptr[14] = &X14;  Xptr[15] = &X15;
+	const u64 *X_ptr[16]; /* use for debugging (help cc put Xn in regs) */
+
+	X_ptr[0]  = &X00;  X_ptr[1]  = &X01;  X_ptr[2]  = &X02;
+	X_ptr[3]  = &X03;  X_ptr[4]  = &X04;  X_ptr[5]  = &X05;
+	X_ptr[6]  = &X06;  X_ptr[7]  = &X07;  X_ptr[8]  = &X08;
+	X_ptr[9]  = &X09;  X_ptr[10] = &X10;  X_ptr[11] = &X11;
+	X_ptr[12] = &X12;  X_ptr[13] = &X13;  X_ptr[14] = &X14;
+	X_ptr[15] = &X15;
 #endif
 
-	Skein_assert(blkCnt != 0); /* never call with blkCnt == 0! */
+	Skein_assert(blk_cnt != 0); /* never call with blk_cnt == 0! */
 	ts[0] = ctx->h.T[0];
 	ts[1] = ctx->h.T[1];
 	do  {
@@ -522,7 +527,7 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		 * this implementation only supports 2**64 input bytes
 		 * (no carry out here)
 		 */
-		ts[0] += byteCntAdd; /* update processed length */
+		ts[0] += byte_cnt_add; /* update processed length */
 
 		/* precompute the key schedule for this block */
 		ks[0]  = ctx->X[0];
@@ -549,9 +554,9 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		ts[2]  = ts[0] ^ ts[1];
 
 		/* get input block in little-endian format */
-		Skein_Get64_LSB_First(w, blkPtr, WCNT);
+		Skein_Get64_LSB_First(w, blk_ptr, WCNT);
 		DebugSaveTweak(ctx);
-		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blkPtr, w, ks, ts);
+		Skein_Show_Block(BLK_BITS, &ctx->h, ctx->X, blk_ptr, w, ks, ts);
 
 		X00    =  w[0] +  ks[0]; /* do the first full key injection */
 		X01    =  w[1] +  ks[1];
@@ -571,10 +576,10 @@ void skein_1024_process_block(struct skein1024_ctx *ctx, const u8 *blkPtr,
 		X15    = w[15] + ks[15];
 
 		Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INITIAL,
-				 Xptr);
+				 X_ptr);
 
 #define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-			pF, ROT, rNum) \
+			pF, ROT, r_num) \
 do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
@@ -592,7 +597,7 @@ do { \
 do { \
 	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, X_ptr); \
 } while (0)
 
 #define I1024(R) \
@@ -614,7 +619,7 @@ do { \
 	X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3]; \
 	X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3]; \
 	X15   += ks[((R) + 16) % 17] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
@@ -622,7 +627,7 @@ do { \
 do { \
 	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, X_ptr); \
 } while (0)
 
 #define I1024(R) \
@@ -647,7 +652,7 @@ do { \
 	/* rotate key schedule */ \
 	ks[r  +         (R) + 16] = ks[r + (R) - 1]; \
 	ts[r  +         (R) +  2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
 		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
@@ -750,8 +755,8 @@ do { \
 		Skein_Show_Round(BLK_BITS, &ctx->h, SKEIN_RND_FEED_FWD, ctx->X);
 
 		ts[1] &= ~SKEIN_T1_FLAG_FIRST;
-		blkPtr += SKEIN1024_BLOCK_BYTES;
-	} while (--blkCnt);
+		blk_ptr += SKEIN1024_BLOCK_BYTES;
+	} while (--blk_cnt);
 	ctx->h.T[0] = ts[0];
 	ctx->h.T[1] = ts[1];
 }
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish1024Block.c
index 113019f..827ce1a 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish1024Block.c
@@ -2,28 +2,28 @@
 #include <threefishApi.h>
 
 
-void threefish_encrypt_1024(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_1024(struct threefish_key *key_ctx, u64 *input,
 			    u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7],
-	  b8 = input[8], b9 = input[9],
-	  b10 = input[10], b11 = input[11],
-	  b12 = input[12], b13 = input[13],
-	  b14 = input[14], b15 = input[15];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
-	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
-	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
-	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
-	  k16 = keyCtx->key[16];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3],
+	    b4 = input[4], b5 = input[5],
+	    b6 = input[6], b7 = input[7],
+	    b8 = input[8], b9 = input[9],
+	    b10 = input[10], b11 = input[11],
+	    b12 = input[12], b13 = input[13],
+	    b14 = input[14], b15 = input[15];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4], k5 = key_ctx->key[5],
+	    k6 = key_ctx->key[6], k7 = key_ctx->key[7],
+	    k8 = key_ctx->key[8], k9 = key_ctx->key[9],
+	    k10 = key_ctx->key[10], k11 = key_ctx->key[11],
+	    k12 = key_ctx->key[12], k13 = key_ctx->key[13],
+	    k14 = key_ctx->key[14], k15 = key_ctx->key[15],
+	    k16 = key_ctx->key[16];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 
 	b1 += k1;
 	b0 += b1 + k0;
@@ -2123,28 +2123,28 @@ void threefish_encrypt_1024(struct threefish_key *keyCtx, u64 *input,
 	output[15] = b15 + k1 + 20;
 }
 
-void threefish_decrypt_1024(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_1024(struct threefish_key *key_ctx, u64 *input,
 			    u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7],
-	  b8 = input[8], b9 = input[9],
-	  b10 = input[10], b11 = input[11],
-	  b12 = input[12], b13 = input[13],
-	  b14 = input[14], b15 = input[15];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8], k9 = keyCtx->key[9],
-	  k10 = keyCtx->key[10], k11 = keyCtx->key[11],
-	  k12 = keyCtx->key[12], k13 = keyCtx->key[13],
-	  k14 = keyCtx->key[14], k15 = keyCtx->key[15],
-	  k16 = keyCtx->key[16];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3],
+	    b4 = input[4], b5 = input[5],
+	    b6 = input[6], b7 = input[7],
+	    b8 = input[8], b9 = input[9],
+	    b10 = input[10], b11 = input[11],
+	    b12 = input[12], b13 = input[13],
+	    b14 = input[14], b15 = input[15];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4], k5 = key_ctx->key[5],
+	    k6 = key_ctx->key[6], k7 = key_ctx->key[7],
+	    k8 = key_ctx->key[8], k9 = key_ctx->key[9],
+	    k10 = key_ctx->key[10], k11 = key_ctx->key[11],
+	    k12 = key_ctx->key[12], k13 = key_ctx->key[13],
+	    k14 = key_ctx->key[14], k15 = key_ctx->key[15],
+	    k16 = key_ctx->key[16];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 	u64 tmp;
 
 	b0 -= k3;
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish256Block.c
index ee21aef..1329c71 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish256Block.c
@@ -2,16 +2,16 @@
 #include <threefishApi.h>
 
 
-void threefish_encrypt_256(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_256(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 
 	b1 += k1 + t0;
 	b0 += b1 + k0;
@@ -495,16 +495,16 @@ void threefish_encrypt_256(struct threefish_key *keyCtx, u64 *input,
 	output[3] = b3 + k1 + 18;
 }
 
-void threefish_decrypt_256(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_256(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 
 	u64 tmp;
 
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish512Block.c
index c4ad1b4..db50d83 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish512Block.c
@@ -2,20 +2,20 @@
 #include <threefishApi.h>
 
 
-void threefish_encrypt_512(struct threefish_key *keyCtx, u64 *input,
+void threefish_encrypt_512(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3],
+	    b4 = input[4], b5 = input[5],
+	    b6 = input[6], b7 = input[7];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4], k5 = key_ctx->key[5],
+	    k6 = key_ctx->key[6], k7 = key_ctx->key[7],
+	    k8 = key_ctx->key[8];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 
 	b1 += k1;
 	b0 += b1 + k0;
@@ -963,20 +963,20 @@ void threefish_encrypt_512(struct threefish_key *keyCtx, u64 *input,
 	output[7] = b7 + k7 + 18;
 }
 
-void threefish_decrypt_512(struct threefish_key *keyCtx, u64 *input,
+void threefish_decrypt_512(struct threefish_key *key_ctx, u64 *input,
 			   u64 *output)
 {
 	u64 b0 = input[0], b1 = input[1],
-	  b2 = input[2], b3 = input[3],
-	  b4 = input[4], b5 = input[5],
-	  b6 = input[6], b7 = input[7];
-	u64 k0 = keyCtx->key[0], k1 = keyCtx->key[1],
-	  k2 = keyCtx->key[2], k3 = keyCtx->key[3],
-	  k4 = keyCtx->key[4], k5 = keyCtx->key[5],
-	  k6 = keyCtx->key[6], k7 = keyCtx->key[7],
-	  k8 = keyCtx->key[8];
-	u64 t0 = keyCtx->tweak[0], t1 = keyCtx->tweak[1],
-	  t2 = keyCtx->tweak[2];
+	    b2 = input[2], b3 = input[3],
+	    b4 = input[4], b5 = input[5],
+	    b6 = input[6], b7 = input[7];
+	u64 k0 = key_ctx->key[0], k1 = key_ctx->key[1],
+	    k2 = key_ctx->key[2], k3 = key_ctx->key[3],
+	    k4 = key_ctx->key[4], k5 = key_ctx->key[5],
+	    k6 = key_ctx->key[6], k7 = key_ctx->key[7],
+	    k8 = key_ctx->key[8];
+	u64 t0 = key_ctx->tweak[0], t1 = key_ctx->tweak[1],
+	    t2 = key_ctx->tweak[2];
 
 	u64 tmp;
 
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefishApi.c
index fce613b..67ba9a6 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefishApi.c
@@ -3,76 +3,76 @@
 #include <linux/string.h>
 #include <threefishApi.h>
 
-void threefish_set_key(struct threefish_key *keyCtx,
-		       enum threefish_size stateSize,
-		       u64 *keyData, u64 *tweak)
+void threefish_set_key(struct threefish_key *key_ctx,
+		       enum threefish_size state_size,
+		       u64 *key_data, u64 *tweak)
 {
-	int keyWords = stateSize / 64;
+	int key_words = state_size / 64;
 	int i;
 	u64 parity = KeyScheduleConst;
 
-	keyCtx->tweak[0] = tweak[0];
-	keyCtx->tweak[1] = tweak[1];
-	keyCtx->tweak[2] = tweak[0] ^ tweak[1];
+	key_ctx->tweak[0] = tweak[0];
+	key_ctx->tweak[1] = tweak[1];
+	key_ctx->tweak[2] = tweak[0] ^ tweak[1];
 
-	for (i = 0; i < keyWords; i++) {
-		keyCtx->key[i] = keyData[i];
-		parity ^= keyData[i];
+	for (i = 0; i < key_words; i++) {
+		key_ctx->key[i] = key_data[i];
+		parity ^= key_data[i];
 	}
-	keyCtx->key[i] = parity;
-	keyCtx->stateSize = stateSize;
+	key_ctx->key[i] = parity;
+	key_ctx->state_size = state_size;
 }
 
-void threefish_encrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+void threefish_encrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out)
 {
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(plain, in, keyCtx->stateSize / 64);
-	threefish_encrypt_block_words(keyCtx, plain, cipher);
-	Skein_Put64_LSB_First(out, cipher, keyCtx->stateSize / 8);
+	Skein_Get64_LSB_First(plain, in, key_ctx->state_size / 64);
+	threefish_encrypt_block_words(key_ctx, plain, cipher);
+	Skein_Put64_LSB_First(out, cipher, key_ctx->state_size / 8);
 }
 
-void threefish_encrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+void threefish_encrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out)
 {
-	switch (keyCtx->stateSize) {
+	switch (key_ctx->state_size) {
 	case Threefish256:
-		threefish_encrypt_256(keyCtx, in, out);
+		threefish_encrypt_256(key_ctx, in, out);
 		break;
 	case Threefish512:
-		threefish_encrypt_512(keyCtx, in, out);
+		threefish_encrypt_512(key_ctx, in, out);
 		break;
 	case Threefish1024:
-		threefish_encrypt_1024(keyCtx, in, out);
+		threefish_encrypt_1024(key_ctx, in, out);
 		break;
 	}
 }
 
-void threefish_decrypt_block_bytes(struct threefish_key *keyCtx, u8 *in,
+void threefish_decrypt_block_bytes(struct threefish_key *key_ctx, u8 *in,
 				   u8 *out)
 {
 	u64 plain[SKEIN_MAX_STATE_WORDS];        /* max number of words*/
 	u64 cipher[SKEIN_MAX_STATE_WORDS];
 
-	Skein_Get64_LSB_First(cipher, in, keyCtx->stateSize / 64);
-	threefish_decrypt_block_words(keyCtx, cipher, plain);
-	Skein_Put64_LSB_First(out, plain, keyCtx->stateSize / 8);
+	Skein_Get64_LSB_First(cipher, in, key_ctx->state_size / 64);
+	threefish_decrypt_block_words(key_ctx, cipher, plain);
+	Skein_Put64_LSB_First(out, plain, key_ctx->state_size / 8);
 }
 
-void threefish_decrypt_block_words(struct threefish_key *keyCtx, u64 *in,
+void threefish_decrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 				   u64 *out)
 {
-	switch (keyCtx->stateSize) {
+	switch (key_ctx->state_size) {
 	case Threefish256:
-		threefish_decrypt_256(keyCtx, in, out);
+		threefish_decrypt_256(key_ctx, in, out);
 		break;
 	case Threefish512:
-		threefish_decrypt_512(keyCtx, in, out);
+		threefish_decrypt_512(key_ctx, in, out);
 		break;
 	case Threefish1024:
-		threefish_decrypt_1024(keyCtx, in, out);
+		threefish_decrypt_1024(key_ctx, in, out);
 		break;
 	}
 }
-- 
1.9.2

