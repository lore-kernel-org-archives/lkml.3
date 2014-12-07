Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaLGWg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:36:56 -0500
Received: from mail.eperm.de ([89.247.134.16]:54959 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaLGWgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:36:54 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v5 8/8] crypto: AF_ALG: enable RNG interface compilation
Date: Sun, 07 Dec 2014 23:25:46 +0100
Message-ID: <5331628.CHFtYQ1joT@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <56740432.V2v4gLHrzS@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
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
index 0b2affc..8e968dc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1514,6 +1514,15 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
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
index 593fd3c..c109df5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.1.0


