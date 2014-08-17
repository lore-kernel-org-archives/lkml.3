Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaHQPmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:42:39 -0400
Received: from mail.eperm.de ([89.247.134.16]:37388 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaHQPmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:42:38 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 8/8] DRBG: remove unnecessary sanity check for shadow state
Date: Sun, 17 Aug 2014 17:41:38 +0200
Message-ID: <2900796.YflQD55GTj@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During creation of the DRBG shadow state, it is ensured that the DRBG
state structure is already allocated. Thus, a sanity check for verifying
that the structure is allocated is removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a556180..f009939 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1155,9 +1155,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
 
-	if (!drbg)
-		return -EINVAL;
-
 	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->V)
 		goto err;
-- 
1.9.3


