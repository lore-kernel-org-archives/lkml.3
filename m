Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaHQPn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:43:26 -0400
Received: from mail.eperm.de ([89.247.134.16]:37395 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaHQPnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:43:25 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 6/8] DRBG: remove unnecessary sanity checks
Date: Sun, 17 Aug 2014 17:40:20 +0200
Message-ID: <5087159.8rmob9g3yS@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drbg_make_shadow function contains sanity checks which are not
needed as the function is invoked at times where it is ensured that the
checked-for variables are available.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 997c510..f74859d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1263,15 +1263,6 @@ static int drbg_make_shadow(struct drbg_state *drbg, struct drbg_state **shadow)
 	int ret = -ENOMEM;
 	struct drbg_state *tmp = NULL;
 
-	if (!drbg || !drbg->core || !drbg->V || !drbg->C) {
-		pr_devel("DRBG: attempt to generate shadow copy for "
-			 "uninitialized DRBG state rejected\n");
-		return -EINVAL;
-	}
-	/* HMAC does not have a scratchpad */
-	if (!(drbg->core->flags & DRBG_HMAC) && NULL == drbg->scratchpad)
-		return -EINVAL;
-
 	tmp = kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
 	if (!tmp)
 		return -ENOMEM;
-- 
1.9.3


