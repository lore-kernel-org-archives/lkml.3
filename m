Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaDARmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:42:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:53474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaDARmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,774,1389772800"; 
   d="scan'208";a="484961600"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] asmlinkage, x86: Add explicit __visible to arch/x86/crypto/*
Date: Tue,  1 Apr 2014 19:32:36 +0200
Message-Id: <1396373557-3387-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As requested by Linus add explicit __visible to the asmlinkage users.
This marks both functions visible to assembler and some functions
defined in assembler to make it clear to the  compiler that they
exist elsewhere.

Tree sweep for arch/x86/crypto/*

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/crypto/aes_glue.c                 |  4 ++--
 arch/x86/crypto/aesni-intel_glue.c         | 34 +++++++++++++++---------------
 arch/x86/crypto/blowfish_glue.c            |  8 +++----
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 12 +++++------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 12 +++++------
 arch/x86/crypto/camellia_glue.c            |  8 +++----
 arch/x86/crypto/cast5_avx_glue.c           |  8 +++----
 arch/x86/crypto/cast6_avx_glue.c           | 12 +++++------
 arch/x86/crypto/crc32c-intel_glue.c        |  2 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c    |  2 +-
 arch/x86/crypto/salsa20_glue.c             |  6 +++---
 arch/x86/crypto/serpent_avx2_glue.c        | 12 +++++------
 arch/x86/crypto/serpent_avx_glue.c         | 12 +++++------
 arch/x86/crypto/sha1_ssse3_glue.c          |  4 ++--
 arch/x86/crypto/sha256_ssse3_glue.c        |  6 +++---
 arch/x86/crypto/sha512_ssse3_glue.c        |  6 +++---
 arch/x86/crypto/twofish_avx_glue.c         | 12 +++++------
 arch/x86/crypto/twofish_glue.c             |  4 ++--
 arch/x86/include/asm/crypto/camellia.h     | 20 +++++++++---------
 arch/x86/include/asm/crypto/serpent-avx.h  | 12 +++++------
 arch/x86/include/asm/crypto/serpent-sse2.h |  8 +++----
 arch/x86/include/asm/crypto/twofish.h      |  8 +++----
 22 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index aafe8ce..78712c1 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -7,8 +7,8 @@
 #include <crypto/aes.h>
 #include <asm/crypto/aes.h>
 
-asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
-asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
+asmlinkage __visible void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
+asmlinkage __visible void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 
 void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
 {
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 948ad0e..4e54d1c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -83,19 +83,19 @@ struct aesni_xts_ctx {
 	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
 };
 
-asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+asmlinkage __visible int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			  const u8 *in);
-asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			  const u8 *in);
-asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
-asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
-asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
-asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
 int crypto_fpu_init(void);
@@ -105,10 +105,10 @@ void crypto_fpu_exit(void);
 #define AVX_GEN4_OPTSIZE 4096
 
 #ifdef CONFIG_X86_64
-asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
+asmlinkage __visible void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
 				 const u8 *in, bool enc, u8 *iv);
 
 /* asmlinkage void aesni_gcm_enc()
@@ -127,7 +127,7 @@ asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
  * unsigned long auth_tag_len), Authenticated Tag Length in bytes.
  *          Valid values are 16 (most likely), 12 or 8.
  */
-asmlinkage void aesni_gcm_enc(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_enc(void *ctx, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
@@ -148,7 +148,7 @@ asmlinkage void aesni_gcm_enc(void *ctx, u8 *out,
  * unsigned long auth_tag_len) Authenticated Tag Length in bytes.
  * Valid values are 16 (most likely), 12 or 8.
  */
-asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_dec(void *ctx, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			u8 *hash_subkey, const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
@@ -160,14 +160,14 @@ asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
  * gcm_data *my_ctx_data, context data
  * u8 *hash_subkey,  the Hash sub key input. Data starts on a 16-byte boundary.
  */
-asmlinkage void aesni_gcm_precomp_avx_gen2(void *my_ctx_data, u8 *hash_subkey);
+asmlinkage __visible void aesni_gcm_precomp_avx_gen2(void *my_ctx_data, u8 *hash_subkey);
 
-asmlinkage void aesni_gcm_enc_avx_gen2(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_enc_avx_gen2(void *ctx, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-asmlinkage void aesni_gcm_dec_avx_gen2(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_dec_avx_gen2(void *ctx, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
@@ -209,14 +209,14 @@ static void aesni_gcm_dec_avx(void *ctx, u8 *out,
  * gcm_data *my_ctx_data, context data
  * u8 *hash_subkey,  the Hash sub key input. Data starts on a 16-byte boundary.
  */
-asmlinkage void aesni_gcm_precomp_avx_gen4(void *my_ctx_data, u8 *hash_subkey);
+asmlinkage __visible void aesni_gcm_precomp_avx_gen4(void *my_ctx_data, u8 *hash_subkey);
 
-asmlinkage void aesni_gcm_enc_avx_gen4(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_enc_avx_gen4(void *ctx, u8 *out,
 			const u8 *in, unsigned long plaintext_len, u8 *iv,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
 
-asmlinkage void aesni_gcm_dec_avx_gen4(void *ctx, u8 *out,
+asmlinkage __visible void aesni_gcm_dec_avx_gen4(void *ctx, u8 *out,
 			const u8 *in, unsigned long ciphertext_len, u8 *iv,
 			const u8 *aad, unsigned long aad_len,
 			u8 *auth_tag, unsigned long auth_tag_len);
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 50ec333..1611e86 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -34,14 +34,14 @@
 #include <crypto/algapi.h>
 
 /* regular block cipher functions */
-asmlinkage void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src,
+asmlinkage __visible void __blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src,
 				   bool xor);
-asmlinkage void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
+asmlinkage __visible void blowfish_dec_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src);
 
 /* 4-way parallel cipher functions */
-asmlinkage void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
+asmlinkage __visible void __blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
-asmlinkage void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
+asmlinkage __visible void blowfish_dec_blk_4way(struct bf_ctx *ctx, u8 *dst,
 				      const u8 *src);
 
 static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src)
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 4209a76..403e575 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -28,19 +28,19 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
 
-asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
-asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
 
-asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 87a041a..b206471 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -27,27 +27,27 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
 
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
 
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index c171dcb..5aaad82 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -36,18 +36,18 @@
 #include <asm/crypto/glue_helper.h>
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
 				 const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 				      const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index e6a3700..77bbfe0 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -37,13 +37,13 @@
 
 #define CAST5_PARALLEL_BLOCKS 16
 
-asmlinkage void cast5_ecb_enc_16way(struct cast5_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast5_ecb_enc_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
-asmlinkage void cast5_ecb_dec_16way(struct cast5_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast5_ecb_dec_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
-asmlinkage void cast5_cbc_dec_16way(struct cast5_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast5_cbc_dec_16way(struct cast5_ctx *ctx, u8 *dst,
 				    const u8 *src);
-asmlinkage void cast5_ctr_16way(struct cast5_ctx *ctx, u8 *dst, const u8 *src,
+asmlinkage __visible void cast5_ctr_16way(struct cast5_ctx *ctx, u8 *dst, const u8 *src,
 				__be64 *iv);
 
 static inline bool cast5_fpu_begin(bool fpu_enabled, unsigned int nbytes)
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 09f3677..9568783 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -42,19 +42,19 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src);
 
-asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src);
-asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
+asmlinkage __visible void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
 
-asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
-asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
+asmlinkage __visible void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
 
 static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index 6812ad9..2b4a1d1 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -56,7 +56,7 @@
 #define CRC32C_PCL_BREAKEVEN_EAGERFPU	512
 #define CRC32C_PCL_BREAKEVEN_NOEAGERFPU	1024
 
-asmlinkage unsigned int crc_pcl(const u8 *buffer, int len,
+asmlinkage __visible unsigned int crc_pcl(const u8 *buffer, int len,
 				unsigned int crc_init);
 static int crc32c_pcl_breakeven = CRC32C_PCL_BREAKEVEN_EAGERFPU;
 #if defined(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 7845d7f..c3879bd 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -33,7 +33,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_device_id.h>
 
-asmlinkage __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
+asmlinkage __visible __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
 				size_t len);
 
 struct chksum_desc_ctx {
diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
index 5e8e677..7c8d764 100644
--- a/arch/x86/crypto/salsa20_glue.c
+++ b/arch/x86/crypto/salsa20_glue.c
@@ -31,10 +31,10 @@ struct salsa20_ctx
 	u32 input[16];
 };
 
-asmlinkage void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k,
+asmlinkage __visible void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k,
 				 u32 keysize, u32 ivsize);
-asmlinkage void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv);
-asmlinkage void salsa20_encrypt_bytes(struct salsa20_ctx *ctx,
+asmlinkage __visible void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv);
+asmlinkage __visible void salsa20_encrypt_bytes(struct salsa20_ctx *ctx,
 				      const u8 *src, u8 *dst, u32 bytes);
 
 static int setkey(struct crypto_tfm *tfm, const u8 *key,
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 2fae489..790c413 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -28,17 +28,17 @@
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
 
 /* 16-way AVX2 parallel cipher functions */
-asmlinkage void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
 				      const u8 *src);
-asmlinkage void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
 				      const u8 *src);
-asmlinkage void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
+asmlinkage __visible void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
 
-asmlinkage void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
+asmlinkage __visible void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
 				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
 				      const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
 				      const u8 *src, le128 *iv);
 
 static const struct common_glue_ctx serpent_enc = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index ff48708..f3b6455 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -42,27 +42,27 @@
 #include <asm/crypto/glue_helper.h>
 
 /* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
 
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
 
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
 
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
 
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 4a11a9d..b24aec2 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -33,10 +33,10 @@
 #include <asm/xsave.h>
 
 
-asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
+asmlinkage __visible void sha1_transform_ssse3(u32 *digest, const char *data,
 				     unsigned int rounds);
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
+asmlinkage __visible void sha1_transform_avx(u32 *digest, const char *data,
 				   unsigned int rounds);
 #endif
 
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index f248546..c71c65e 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -42,14 +42,14 @@
 #include <asm/xsave.h>
 #include <linux/string.h>
 
-asmlinkage void sha256_transform_ssse3(const char *data, u32 *digest,
+asmlinkage __visible void sha256_transform_ssse3(const char *data, u32 *digest,
 				     u64 rounds);
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha256_transform_avx(const char *data, u32 *digest,
+asmlinkage __visible void sha256_transform_avx(const char *data, u32 *digest,
 				     u64 rounds);
 #endif
 #ifdef CONFIG_AS_AVX2
-asmlinkage void sha256_transform_rorx(const char *data, u32 *digest,
+asmlinkage __visible void sha256_transform_rorx(const char *data, u32 *digest,
 				     u64 rounds);
 #endif
 
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index f30cd10..45cea90 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -41,14 +41,14 @@
 
 #include <linux/string.h>
 
-asmlinkage void sha512_transform_ssse3(const char *data, u64 *digest,
+asmlinkage __visible void sha512_transform_ssse3(const char *data, u64 *digest,
 				     u64 rounds);
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha512_transform_avx(const char *data, u64 *digest,
+asmlinkage __visible void sha512_transform_avx(const char *data, u64 *digest,
 				     u64 rounds);
 #endif
 #ifdef CONFIG_AS_AVX2
-asmlinkage void sha512_transform_rorx(const char *data, u64 *digest,
+asmlinkage __visible void sha512_transform_rorx(const char *data, u64 *digest,
 				     u64 rounds);
 #endif
 
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 4e3c665..1b2181a 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -48,19 +48,19 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
 				 const u8 *src, le128 *iv);
 
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
 
 static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 0a52023..5992a66 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -44,10 +44,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
 EXPORT_SYMBOL_GPL(twofish_enc_blk);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
 EXPORT_SYMBOL_GPL(twofish_dec_blk);
 
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index bb93333..43c6106 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -37,31 +37,31 @@ extern int xts_camellia_setkey(struct crypto_tfm *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
 				 const u8 *src);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
 				      const u8 *src);
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
 
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src);
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
 				   const u8 *src, le128 *iv);
 
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
+asmlinkage __visible void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
 				       const u8 *src, le128 *iv);
 
 static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index 33c2b8a..895b421 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -16,19 +16,19 @@ struct serpent_xts_ctx {
 	struct serpent_ctx crypt_ctx;
 };
 
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src, le128 *iv);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 
 extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index e6e77df..c669be7 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -8,9 +8,9 @@
 
 #define SERPENT_PARALLEL_BLOCKS 4
 
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
 static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
@@ -35,9 +35,9 @@ static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage __visible void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
 static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 878c51c..3d9c344 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -17,15 +17,15 @@ struct twofish_xts_ctx {
 };
 
 /* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
 
 /* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
+asmlinkage __visible void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
-- 
1.8.5.2

