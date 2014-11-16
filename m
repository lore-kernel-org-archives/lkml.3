Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaKPCs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:48:28 -0500
Received: from mail.eperm.de ([89.247.134.16]:54579 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbaKPCsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:48:21 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Date: Sun, 16 Nov 2014 03:26:58 +0100
Message-ID: <2196615.OgfUNzPKdf@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5365136.g8vbXlhRyC@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current AF_ALG implementation requires that a userspace interface
implementation must provide a callback for setkey. Such a call is not
appliable to random number generators.

To prepare AF_ALG for the addition of a random number generator user
space interface, this function callback invocation is made optional.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 635140b..47a199c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -177,6 +177,9 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	u8 *key;
 	int err;
 
+	if (!type->setkey)
+		return -EOPNOTSUPP;
+
 	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
-- 
2.1.0


