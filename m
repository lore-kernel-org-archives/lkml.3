Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaGZORF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:17:05 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55121 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaGZORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:17:03 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Neil Horman <nhorman@tuxdriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: rng.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:18:28 +0200
Message-Id: <1406384308-2269-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index e0a25c2..c3d4fb3 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -65,7 +65,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
 
-	strncpy(rrng.type, "rng", sizeof(rrng.type));
+	strlcpy(rrng.type, "rng", sizeof(rrng.type));
 
 	rrng.seedsize = alg->cra_rng.seedsize;
 
-- 
1.7.10.4

