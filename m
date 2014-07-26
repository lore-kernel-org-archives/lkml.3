Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaGZOPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:15:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37172 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaGZOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:15:31 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: pcompress.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:16:56 +0200
Message-Id: <1406384216-2186-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 crypto/pcompress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index 7140fe7..f114720 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -53,7 +53,7 @@ static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rpcomp;
 
-	strncpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
+	strlcpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
 	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		    sizeof(struct crypto_report_comp), &rpcomp))
 		goto nla_put_failure;
-- 
1.7.10.4

