Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaLWIeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:34:10 -0500
Received: from mail.eperm.de ([89.247.134.16]:51005 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaLWIeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:34:07 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: AF_ALG: zeroize key data
Date: Tue, 23 Dec 2014 09:34:03 +0100
Message-ID: <4092638.L73RGXcGnC@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alg_setkey should zeroize the sensitive data after use.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8ff3c4..76d739d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -188,7 +188,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	err = type->setkey(ask->private, key, keylen);
 
 out:
-	sock_kfree_s(sk, key, keylen);
+	sock_kzfree_s(sk, key, keylen);
 
 	return err;
 }
-- 
2.1.0


