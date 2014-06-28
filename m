Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaF1UKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:10:04 -0400
Received: from mail.eperm.de ([89.247.134.16]:43627 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaF1UKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:10:02 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] DRBG: Fix format string for debugging statements
Date: Sat, 28 Jun 2014 22:01:46 +0200
Message-ID: <10901956.0EDQunEZJL@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <4927386.WYHrRe3NJm@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial format strings caused warnings on several architectures. The
updated format strings now match the variable types.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 03a230e..4593b3c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1109,7 +1109,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
-		pr_devel("DRBG: personalization string too long %lu\n",
+		pr_devel("DRBG: personalization string too long %zu\n",
 			 pers->len);
 		return -EINVAL;
 	}
@@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
 
 	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
 		pr_info("DRBG: Cannot register all DRBG types"
-			"(slots needed: %lu, slots available: %lu)\n",
-			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
+			"(slots needed: %u, slots available: %u)\n",
+			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
+			(unsigned int)ARRAY_SIZE(drbg_algs));
 		return ret;
 	}
 
-- 
1.9.3


