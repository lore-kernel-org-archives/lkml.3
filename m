Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaGZOJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:09:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36954 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGZOJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:09:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aead.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:10:49 +0200
Message-Id: <1406383849-1843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/aead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 547491e..249ab07 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -117,8 +117,8 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = &alg->cra_aead;
 
-	strncpy(raead.type, "aead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
+	strlcpy(raead.type, "aead", sizeof(raead.type));
+	strlcpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
 
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
@@ -202,8 +202,8 @@ static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = &alg->cra_aead;
 
-	strncpy(raead.type, "nivaead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
+	strlcpy(raead.type, "nivaead", sizeof(raead.type));
+	strlcpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
 
 	raead.blocksize = alg->cra_blocksize;
 	raead.maxauthsize = aead->maxauthsize;
-- 
1.7.10.4

