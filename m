Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3ELL5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 07:57:23 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56391 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab3ELL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 07:57:22 -0400
Message-ID: <1368359839.1350.10.camel@x61.thuisdomein>
Subject: [PATCH] crypto: remove dependency on EXPERIMENTAL
From: Paul Bolle <pebolle@tiscali.nl>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 12 May 2013 13:57:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2013 11:57:20.0555 (UTC) FILETIME=[DB74BFB0:01CE4F07]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol EXPERIMENTAL was removed in v3.9. So this dependency
makes it impossible to set CRYPTO_DEV_SAHARA. It's unlikely that this is
what is intended, so let's remove this dependency.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "make ARCH=arm menuconfig".

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index dffb855..47c6f4d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -278,7 +278,7 @@ config CRYPTO_DEV_PICOXCELL
 
 config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
-	depends on ARCH_MXC && EXPERIMENTAL && OF
+	depends on ARCH_MXC && OF
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
-- 
1.7.11.7

