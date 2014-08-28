Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbaH1HRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:17:09 -0400
Received: from mail.eperm.de ([89.247.134.16]:46986 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbaH1HRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:17:07 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: DRBG: remove test for uninitialized DRBG handle
Date: Thu, 28 Aug 2014 09:17:03 +0200
Message-ID: <2837552.tiNKQxI8Xu@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140827133528.GA15871@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <1471416.zGlxQVbHUr@myon.chronox.de> <20140827133528.GA15871@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drbg_healthcheck() contains a test to call the DRBG with an
uninitialized DRBG cipher handle. As this is an inappropriate use of the
kernel crypto API to try to generate random numbers before
initialization, checks verifying for an initialized DRBG during the
generate function have been removed in previous patches.

Now, the drbg_healthcheck test trying to generate random numbers with
an uninstantiated DRBG must also be removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 39ed918..54cfd48 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1872,9 +1872,6 @@ static inline int __init drbg_healthcheck_sanity(void)
 	/* overflow max addtllen with personalization string */
 	ret = drbg_instantiate(drbg, &addtl, coreref, pr);
 	BUG_ON(0 == ret);
-	/* test uninstantated DRBG */
-	len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
-	BUG_ON(0 < len);
 	/* all tests passed */
 	rc = 0;
 
-- 
1.9.3


