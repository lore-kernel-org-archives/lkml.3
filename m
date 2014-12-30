Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaL3AU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:20:56 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57526 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaL3AUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:20:53 -0500
From: Vinson Lee <vlee@twopensource.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vinson Lee <vlee@twitter.com>
Subject: [PATCH] crypto: sha-mb - Add avx2_supported check.
Date: Mon, 29 Dec 2014 16:20:39 -0800
Message-Id: <1419898842-9447-1-git-send-email-vlee@twopensource.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinson Lee <vlee@twitter.com>

This patch fixes this allyesconfig target build error with older
binutils.

  LD      arch/x86/crypto/built-in.o
ld: arch/x86/crypto/sha-mb/built-in.o: No such file: No such file or directory

Cc: stable@vger.kernel.org # 3.18+
Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 arch/x86/crypto/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index fd0f848..5a4a089 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 
 obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
-obj-$(CONFIG_CRYPTO_SHA1_MB) += sha-mb/
 obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
@@ -46,6 +45,7 @@ endif
 ifeq ($(avx2_supported),yes)
 	obj-$(CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64) += camellia-aesni-avx2.o
 	obj-$(CONFIG_CRYPTO_SERPENT_AVX2_X86_64) += serpent-avx2.o
+	obj-$(CONFIG_CRYPTO_SHA1_MB) += sha-mb/
 endif
 
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
-- 
1.7.1

