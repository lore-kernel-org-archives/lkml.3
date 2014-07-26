Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaGZOSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:18:36 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47206 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaGZOSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:18:35 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: shash.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:20:00 +0200
Message-Id: <1406384400-2351-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/shash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 47c7139..450f996 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -531,7 +531,7 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_report_hash rhash;
 	struct shash_alg *salg = __crypto_shash_alg(alg);
 
-	strncpy(rhash.type, "shash", sizeof(rhash.type));
+	strlcpy(rhash.type, "shash", sizeof(rhash.type));
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = salg->digestsize;
-- 
1.7.10.4

