Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaLYWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:03:34 -0500
Received: from mail.eperm.de ([89.247.134.16]:51066 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbaLYWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:03:18 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v6 2/4] crypto: AF_ALG: enable AEAD interface compilation
Date: Thu, 25 Dec 2014 22:59:21 +0100
Message-ID: <4832287.ds8TMM6v4B@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <5682082.ffPqvQlSqN@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable compilation of the AEAD AF_ALG support and provide a Kconfig
option to compile the AEAD AF_ALG support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1618468..cd3e6fd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1514,6 +1514,15 @@ config CRYPTO_USER_API_SKCIPHER
 	  This option enables the user-spaces interface for symmetric
 	  key cipher algorithms.
 
+config CRYPTO_USER_API_AEAD
+	tristate "User-space interface for AEAD cipher algorithms"
+	depends on NET
+	select CRYPTO_AEAD
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for AEAD
+	  cipher algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 1445b91..593fd3c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
+obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.1.0


