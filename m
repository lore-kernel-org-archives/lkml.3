Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533Ab3EFXNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504Ab3EFXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sandy Wu <sandyw@twitter.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 045/104] crypto: crc32-pclmul - Use gas macro for pclmulqdq
Date: Mon,  6 May 2013 16:12:04 -0700
Message-Id: <20130506230048.234898529@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandy Wu <sandyw@twitter.com>

commit 57ae1b0532977b30184aaba04b6cafe0a284c21f upstream.

Occurs when CONFIG_CRYPTO_CRC32C_INTEL=y and CONFIG_CRYPTO_CRC32C_INTEL=y.
Older versions of bintuils do not support the pclmulqdq instruction. The
PCLMULQDQ gas macro is used instead.

Signed-off-by: Sandy Wu <sandyw@twitter.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -42,6 +42,8 @@
  * SOFTWARE.
  */
 
+#include <asm/inst.h>
+
 ## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
 
 .macro LABEL prefix n
@@ -224,10 +226,10 @@ LABEL crc_ %i
 	movdqa  (bufp), %xmm0			# 2 consts: K1:K2
 
 	movq    crc_init, %xmm1			# CRC for block 1
-	pclmulqdq $0x00,%xmm0,%xmm1		# Multiply by K2
+	PCLMULQDQ 0x00,%xmm0,%xmm1		# Multiply by K2
 
 	movq    crc1, %xmm2			# CRC for block 2
-	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
+	PCLMULQDQ 0x10, %xmm0, %xmm2		# Multiply by K1
 
 	pxor    %xmm2,%xmm1
 	movq    %xmm1, %rax


