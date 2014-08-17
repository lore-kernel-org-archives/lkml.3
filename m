Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaHQPoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 11:44:21 -0400
Received: from mail.eperm.de ([89.247.134.16]:37401 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaHQPoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 11:44:20 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 4/8] DRBG: remove superflowous memset(0)
Date: Sun, 17 Aug 2014 17:38:58 +0200
Message-ID: <10134662.iYyEj4XcbG@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove memset(0) which is not needed due to the kzalloc of the memory.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 89d732b..d13f588 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -728,11 +728,9 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 	LIST_HEAD(seedlist);
 	LIST_HEAD(vdatalist);
 
-	if (!reseed) {
-		/* 10.1.2.3 step 2 */
-		memset(drbg->C, 0, drbg_statelen(drbg));
+	if (!reseed)
+		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
 		memset(drbg->V, 1, drbg_statelen(drbg));
-	}
 
 	drbg_string_fill(&seed1, drbg->V, drbg_statelen(drbg));
 	list_add_tail(&seed1.list, &seedlist);
-- 
1.9.3


