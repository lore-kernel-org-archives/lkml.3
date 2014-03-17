Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaCQHl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:41:26 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:42244 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503AbaCQHkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:40:47 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: [PATCH v2 3/6] DRBG kernel configuration options
Date: Mon, 17 Mar 2014 08:35:55 +0100
Message-ID: <2589470.EoGAcF9qRN@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.6-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <2831049.lrfGvkkTou@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de> <2831049.lrfGvkkTou@myon.chronox.de>
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

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7bcb70d..2cdf9c6 100644
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
1.8.5.3


