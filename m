Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKKEif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:38:35 -0500
Received: from mail.eperm.de ([89.247.134.16]:54324 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaKKEid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:38:33 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "'Sandy Harris'" <sandyinchina@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: AF_ALG - zeroize IV buffer
Date: Tue, 11 Nov 2014 05:37:57 +0100
Message-ID: <1988935.aEo2Rr1ofd@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zeroize the buffer holding the IV used for the completed
cipher operation before the buffer is released by the
skcipher AF_ALG interface handler.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 83187f4..85e3bdb 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -566,6 +566,7 @@ static void skcipher_sock_destruct(struct sock *sk)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
 
 	skcipher_free_sgl(sk);
+	memzero_explicit(ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
-- 
2.1.0


