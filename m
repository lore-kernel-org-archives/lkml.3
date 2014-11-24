Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaKXWYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:24:25 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51581 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaKXWYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:24:23 -0500
Date: Mon, 24 Nov 2014 14:24:15 -0800
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH v2] crypto: include crypto- module prefix in template
Message-ID: <20141124222415.GA21010@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the module loading prefix "crypto-" to the template lookup
as well.

For example, attempting to load 'vfat(blowfish)' via AF_ALG now correctly
includes the "crypto-" prefix at every level, correctly rejecting "vfat":

	net-pf-38
	algif-hash
	crypto-vfat(blowfish)
	crypto-vfat(blowfish)-all
	crypto-vfat

Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/algapi.c     | 4 ++--
 crypto/authenc.c    | 1 +
 crypto/authencesn.c | 1 +
 crypto/cbc.c        | 1 +
 crypto/chainiv.c    | 1 +
 crypto/cmac.c       | 1 +
 crypto/cts.c        | 1 +
 crypto/ecb.c        | 1 +
 crypto/eseqiv.c     | 1 +
 crypto/hmac.c       | 1 +
 crypto/lrw.c        | 1 +
 crypto/pcbc.c       | 1 +
 crypto/seqiv.c      | 1 +
 crypto/vmac.c       | 1 +
 crypto/xcbc.c       | 1 +
 crypto/xts.c        | 1 +
 16 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e8d3a7dca8c4..71a8143e23b1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -509,8 +509,8 @@ static struct crypto_template *__crypto_lookup_template(const char *name)
 
 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), "%s",
-				       name);
+	return try_then_request_module(__crypto_lookup_template(name),
+				       "crypto-%s", name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);
 
diff --git a/crypto/authenc.c b/crypto/authenc.c
index e1223559d5df..78fb16cab13f 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -721,3 +721,4 @@ module_exit(crypto_authenc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Simple AEAD wrapper for IPsec");
+MODULE_ALIAS_CRYPTO("authenc");
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 4be0dd4373a9..024bff2344fc 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -814,3 +814,4 @@ module_exit(crypto_authenc_esn_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_DESCRIPTION("AEAD wrapper for IPsec with extended sequence numbers");
+MODULE_ALIAS_CRYPTO("authencesn");
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 61ac42e1e32b..780ee27b2d43 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -289,3 +289,4 @@ module_exit(crypto_cbc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CBC block cipher algorithm");
+MODULE_ALIAS_CRYPTO("cbc");
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 9c294c8f9a07..63c17d5992f7 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -359,3 +359,4 @@ module_exit(chainiv_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Chain IV Generator");
+MODULE_ALIAS_CRYPTO("chainiv");
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 50880cf17fad..7a8bfbd548f6 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -313,3 +313,4 @@ module_exit(crypto_cmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CMAC keyed hash algorithm");
+MODULE_ALIAS_CRYPTO("cmac");
diff --git a/crypto/cts.c b/crypto/cts.c
index 133f0874c95e..bd9405820e8a 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -351,3 +351,4 @@ module_exit(crypto_cts_module_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("CTS-CBC CipherText Stealing for CBC");
+MODULE_ALIAS_CRYPTO("cts");
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 935cfef4aa84..12011aff0971 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -185,3 +185,4 @@ module_exit(crypto_ecb_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("ECB block cipher algorithm");
+MODULE_ALIAS_CRYPTO("ecb");
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index bf7ab4a89493..f116fae766f8 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -267,3 +267,4 @@ module_exit(eseqiv_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Encrypted Sequence Number IV Generator");
+MODULE_ALIAS_CRYPTO("eseqiv");
diff --git a/crypto/hmac.c b/crypto/hmac.c
index e392219ddc61..72e38c098bb3 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -268,3 +268,4 @@ module_exit(hmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("HMAC hash algorithm");
+MODULE_ALIAS_CRYPTO("hmac");
diff --git a/crypto/lrw.c b/crypto/lrw.c
index ba42acc4deba..6f9908a7ebcb 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -400,3 +400,4 @@ module_exit(crypto_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LRW block cipher mode");
+MODULE_ALIAS_CRYPTO("lrw");
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index d1b8bdfb5855..f654965f0933 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -295,3 +295,4 @@ module_exit(crypto_pcbc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCBC block cipher algorithm");
+MODULE_ALIAS_CRYPTO("pcbc");
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index ee190fcedcd2..9daa854cc485 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -362,3 +362,4 @@ module_exit(seqiv_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Sequence Number IV Generator");
+MODULE_ALIAS_CRYPTO("seqiv");
diff --git a/crypto/vmac.c b/crypto/vmac.c
index d84c24bd7ff7..df76a816cfb2 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -713,3 +713,4 @@ module_exit(vmac_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VMAC hash algorithm");
+MODULE_ALIAS_CRYPTO("vmac");
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index a5fbdf3738cf..df90b332554c 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -286,3 +286,4 @@ module_exit(crypto_xcbc_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XCBC keyed hash algorithm");
+MODULE_ALIAS_CRYPTO("xcbc");
diff --git a/crypto/xts.c b/crypto/xts.c
index ca1608f44cb5..f6fd43f100c8 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -362,3 +362,4 @@ module_exit(crypto_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
+MODULE_ALIAS_CRYPTO("xts");
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
