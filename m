Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaFWHMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:12:47 -0400
Received: from mail.eperm.de ([89.247.134.16]:39143 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaFWHMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:12:46 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: kbuild test robot <fengguang.wu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild@01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: [PATCH v2] DRBG: simplify ordering of linked list in drbg_ctr_df
Date: Mon, 23 Jun 2014 09:11:29 +0200
Message-ID: <280704396.67z02n3FAf@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.8-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <5069712.neqH4zuI9U@myon.chronox.de>
References: <5069712.neqH4zuI9U@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by a static code analyzer, the code for the ordering of
the linked list can be simplified.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index faaa2ce..99fa8f8 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -516,13 +516,13 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	S2.next = addtl;
 
 	/*
-	 * splice in addtl between S2 and S4 -- we place S4 at the end of the
-	 * input data chain
+	 * Splice in addtl between S2 and S4 -- we place S4 at the end
+	 * of the input data chain. As this code is only triggered when
+	 * addtl is not NULL, no NULL checks are necessary.
 	 */
 	tempstr = addtl;
-	for (; NULL != tempstr; tempstr = tempstr->next)
-		if (NULL == tempstr->next)
-			break;
+	while (tempstr->next)
+		tempstr = tempstr->next;
 	tempstr->next = &S4;
 
 	/* 10.4.2 step 9 */
-- 
1.9.3


