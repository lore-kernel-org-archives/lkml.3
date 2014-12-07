Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaLGWjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:39:25 -0500
Received: from mail.eperm.de ([89.247.134.16]:54960 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaLGWgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:36:54 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v5 6/8] crypto: AF_ALG: zeroize key / seed data
Date: Sun, 07 Dec 2014 23:24:36 +0100
Message-ID: <2737258.UUWqeH5oOM@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.4-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <56740432.V2v4gLHrzS@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alg_setop shall zeroize the sensitive data after use.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index d1eb1e9..836fa4a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -189,7 +189,7 @@ static int alg_setop(struct sock *sk, char __user *udata,
 	err = handler(ask->private, data, datalen);
 
 out:
-	sock_kfree_s(sk, data, datalen);
+	sock_kzfree_s(sk, data, datalen);
 
 	return err;
 }
-- 
2.1.0


