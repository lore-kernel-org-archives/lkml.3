Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaGZOOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:14:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59510 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaGZON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:13:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: crypto_user.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:15:25 +0200
Message-Id: <1406384125-2093-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/crypto_user.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e2a34fe..09b465e 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -77,7 +77,7 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_cipher rcipher;
 
-	strncpy(rcipher.type, "cipher", sizeof(rcipher.type));
+	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
 
 	rcipher.blocksize = alg->cra_blocksize;
 	rcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
@@ -96,7 +96,7 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rcomp;
 
-	strncpy(rcomp.type, "compression", sizeof(rcomp.type));
+	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		    sizeof(struct crypto_report_comp), &rcomp))
 		goto nla_put_failure;
@@ -109,10 +109,10 @@ nla_put_failure:
 static int crypto_report_one(struct crypto_alg *alg,
 			     struct crypto_user_alg *ualg, struct sk_buff *skb)
 {
-	strncpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
-	strncpy(ualg->cru_driver_name, alg->cra_driver_name,
+	strlcpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
+	strlcpy(ualg->cru_driver_name, alg->cra_driver_name,
 		sizeof(ualg->cru_driver_name));
-	strncpy(ualg->cru_module_name, module_name(alg->cra_module),
+	strlcpy(ualg->cru_module_name, module_name(alg->cra_module),
 		sizeof(ualg->cru_module_name));
 
 	ualg->cru_type = 0;
@@ -125,7 +125,7 @@ static int crypto_report_one(struct crypto_alg *alg,
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
 		struct crypto_report_larval rl;
 
-		strncpy(rl.type, "larval", sizeof(rl.type));
+		strlcpy(rl.type, "larval", sizeof(rl.type));
 		if (nla_put(skb, CRYPTOCFGA_REPORT_LARVAL,
 			    sizeof(struct crypto_report_larval), &rl))
 			goto nla_put_failure;
-- 
1.7.10.4

