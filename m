Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbbANHbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbANHbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vinson Lee <vlee@twitter.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.18 133/150] crypto: sha-mb - Add avx2_supported check.
Date: Tue, 13 Jan 2015 23:23:24 -0800
Message-Id: <20150114072101.877410538@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinson Lee <vlee@twitter.com>

commit 0b8c960cf6defc56b3aa1a71b5af95872b6dff2b upstream.

This patch fixes this allyesconfig target build error with older
binutils.

  LD      arch/x86/crypto/built-in.o
ld: arch/x86/crypto/sha-mb/built-in.o: No such file: No such file or directory

Signed-off-by: Vinson Lee <vlee@twitter.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL
 
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


