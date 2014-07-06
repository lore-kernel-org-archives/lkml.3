Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaGFAmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 20:42:35 -0400
Received: from mail.eperm.de ([89.247.134.16]:58222 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaGFAme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 20:42:34 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: joe@perches.com, dan.carpenter@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, fengguang.wu@intel.com,
        Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>, aris@redhat.com
Subject: [PATCH 2/6] DRBG: Fix format string for debugging statements
Date: Sun, 06 Jul 2014 02:24:03 +0200
Message-ID: <10113803.ZGav7NrUuW@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
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
CC: Joe Perches <joe@perches.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index cce915b..c9b4c49 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1106,7 +1106,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
-		pr_devel("DRBG: personalization string too long %lu\n",
+		pr_devel("DRBG: personalization string too long %zu\n",
 			 pers->len);
 		return -EINVAL;
 	}
@@ -1984,7 +1984,7 @@ static int __init drbg_init(void)
 
 	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
 		pr_info("DRBG: Cannot register all DRBG types"
-			"(slots needed: %lu, slots available: %lu)\n",
+			"(slots needed: %zu, slots available: %zu)\n",
 			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
 		return ret;
 	}
-- 
1.9.3


