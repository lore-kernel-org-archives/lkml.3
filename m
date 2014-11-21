Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbaKUFmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:42:51 -0500
Received: from mail.eperm.de ([89.247.134.16]:54750 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbaKUFms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:42:48 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH v3 2/7] crypto: AF_ALG: extend data structuers for AEAD
Date: Fri, 21 Nov 2014 06:31:32 +0100
Message-ID: <2275851.LVsZhuYsZj@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <4088013.2O8zCP0xXa@tachyon.chronox.de>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data structure holding the state of an ongoing symmetric cipher
operation is extended by the data variables needed for AEAD.

The request data structures are encapsulated by a union as the symmetric
cipher implementation is either exclusively used for "normal" symmetric
ciphers or for AEAD ciphers.

In addition, the size of the associated data expected to be present in
the input data must be retained.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 85e3bdb..49d5b08 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -46,7 +46,12 @@ struct skcipher_ctx {
 	bool merge;
 	bool enc;
 
-	struct ablkcipher_request req;
+	bool aead;
+	size_t aead_assoclen;
+	union {
+		struct ablkcipher_request ablkcipher_req;
+		struct aead_request aead_req;
+	} u;
 };
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
-- 
2.1.0


