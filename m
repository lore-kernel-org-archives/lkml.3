Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaEUEcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:32:48 -0400
Received: from mail.eperm.de ([89.247.134.16]:50061 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaEUEcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:32:48 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: [PATCH v7 3/6] DRBG kernel configuration options
Date: Wed, 21 May 2014 06:20:38 +0200
Message-ID: <1420904.WdM3jEvtHL@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <16102625.1uoi9eJz6k@myon.chronox.de>
References: <16102625.1uoi9eJz6k@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different DRBG types of CTR, Hash, HMAC can be enabled or disabled
at compile time. At least one DRBG type shall be selected.

The default is the HMAC DRBG as its code base is smallest.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..c9c1cd9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -23,7 +23,7 @@ comment "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on CRYPTO_ANSI_CPRNG && !CRYPTO_MANAGER_DISABLE_TESTS
+	depends on (CRYPTO_ANSI_CPRNG || CRYTPO_DRBG) && !CRYPTO_MANAGER_DISABLE_TESTS
 	help
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
@@ -1380,6 +1380,40 @@ config CRYPTO_ANSI_CPRNG
 	  ANSI X9.31 A.2.4. Note that this option must be enabled if
 	  CRYPTO_FIPS is selected
 
+menuconfig CRYTPO_DRBG
+	tristate "NIST SP800-90A DRBG"
+	depends on CRYPTO
+	select CRYPTO_RNG
+	help
+	  NIST SP800-90A compliant DRBG. In the following submenu, one or
+	  more of the DRBG types must be selected.
+
+if CRYTPO_DRBG
+
+config CRYPTO_DRBG_HMAC
+	bool "Enable HMAC DRBG"
+	default y
+	depends on CRYTPO_DRBG
+	select CRYPTO_HMAC
+	help
+	  Enable the HMAC DRBG variant as defined in NIST SP800-90A.
+
+config CRYPTO_DRBG_HASH
+	bool "Enable Hash DRBG"
+	depends on CRYTPO_DRBG
+	select CRYPTO_HASH
+	help
+	  Enable the Hash DRBG variant as defined in NIST SP800-90A.
+
+config CRYPTO_DRBG_CTR
+	bool "Enable CTR DRBG"
+	depends on CRYTPO_DRBG
+	select CRYPTO_AES
+	help
+	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
+
+endif #CRYTPO_DRBG
+
 config CRYPTO_USER_API
 	tristate
 
-- 
1.9.0


