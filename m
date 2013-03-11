Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3CKKsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:48:31 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64322 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3CKKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:48:27 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linus.walleij@linaro.org, andreas.westin@stericsson.com, arnd@arndb.de,
        rubini@unipv.it, linux-kernel@vger.kernel.org,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] crypto: replace kmalloc and then memcpy with kmemdup
Date: Mon, 11 Mar 2013 12:48:10 +0200
Message-Id: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/crypto/ux500/hash/hash_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 632c333..8d16d3a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1368,14 +1368,12 @@ static int hash_setkey(struct crypto_ahash *tfm,
 	/**
 	 * Freed in final.
 	 */
-	ctx->key = kmalloc(keylen, GFP_KERNEL);
+	ctx->key = kmemdup(key, keylen, GFP_KERNEL);
 	if (!ctx->key) {
 		pr_err(DEV_DBG_NAME " [%s] Failed to allocate ctx->key "
 		       "for %d\n", __func__, alg);
 		return -ENOMEM;
 	}
-
-	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
 	return ret;
-- 
1.7.10.4

