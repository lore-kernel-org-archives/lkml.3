Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKLHJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:09:24 -0500
Received: from mail.eperm.de ([89.247.134.16]:54477 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaKLHJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:09:20 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] crypto: AF_ALG: enable RNG interface compilation
Date: Wed, 12 Nov 2014 08:06:41 +0100
Message-ID: <1533977.uDd7pUf1qA@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <4738444.A2vZX1nNCo@tachyon.chronox.de>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable compilation of the RNG AF_ALG support and provide a Kconfig
option to compile the RNG AF_ALG support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87bbc9c..e127323 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1505,6 +1505,15 @@ config CRYPTO_USER_API_SKCIPHER
 	  This option enables the user-spaces interface for symmetric
 	  key cipher algorithms.
 
+config CRYPTO_USER_API_RNG
+	tristate "User-space interface for random number generator algorithms"
+	depends on NET
+	select CRYPTO_RNG
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for random
+	  number generator algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 1445b91..ba19465 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.1.0


