Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaGZOHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:07:54 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39228 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGZOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:07:52 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ablkcipher.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:09:17 +0200
Message-Id: <1406383757-1753-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/ablkcipher.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 40886c4..e446eef 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -384,8 +384,8 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
+	strlcpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
@@ -465,8 +465,8 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
+	strlcpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
-- 
1.7.10.4

