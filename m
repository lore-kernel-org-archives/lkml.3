Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3AURDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:03:08 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64410 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3AURDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:03:06 -0500
From: Matt Sealey <matt@genesi-usa.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matt Sealey <matt@genesi-usa.com>
Subject: [PATCH] crypto: fix FTBFS with ARM SHA1-asm and THUMB2_KERNEL
Date: Mon, 21 Jan 2013 11:02:43 -0600
Message-Id: <1358787763-1226-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The optimized assembler SHA1 code for ARM does not conform to Thumb2
register usage requirements, so it cannot be built when the kernel is
configured with THUMB2_KERNEL.

Fix the FTBFS for now by preventing misconfigurations of the kernel.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
---
 crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4641d95..304d60b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -472,7 +472,7 @@ config CRYPTO_SHA1_SPARC64
 
 config CRYPTO_SHA1_ARM
 	tristate "SHA1 digest algorithm (ARM-asm)"
-	depends on ARM
+	depends on ARM && !THUMB2_KERNEL
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
-- 
1.7.10.4

