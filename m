Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbaHZHbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:31:15 -0400
Received: from mail.eperm.de ([89.247.134.16]:46902 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966AbaHZHbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:31:12 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] DRBG: fix bit shifting on 32 bit systems
Date: Tue, 26 Aug 2014 09:31:02 +0200
Message-ID: <6371777.WdUEAKFPYo@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140826063812.GA3555@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <20140826063812.GA3555@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ULL to mark a 64 bit value.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/drbg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 3d8e73a..dd52aee 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -154,13 +154,13 @@ static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
 static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**35 bytes additional info str / pers str */
-	return (1UL<<35);
+	return (1ULL<<35);
 }
 
 static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
-	return (1UL<<48);
+	return (1ULL<<48);
 }
 
 /*
-- 
1.9.3


