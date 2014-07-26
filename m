Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaGZOK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:10:57 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38085 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:10:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ahash.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:12:21 +0200
Message-Id: <1406383941-1926-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/ahash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f2a5d8f..4d3b4df 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -479,7 +479,7 @@ static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
 
-	strncpy(rhash.type, "ahash", sizeof(rhash.type));
+	strlcpy(rhash.type, "ahash", sizeof(rhash.type));
 
 	rhash.blocksize = alg->cra_blocksize;
 	rhash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
-- 
1.7.10.4

