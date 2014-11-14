Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbaKNE1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:27:47 -0500
Received: from mail.eperm.de ([89.247.134.16]:54547 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934226AbaKNE1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:27:45 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Documentation - document uncovered member variables
Date: Fri, 14 Nov 2014 05:26:21 +0100
Message-ID: <1910451.sH207F56nk@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix documentation typo for shash_alg->descsize.

Add documentation for initially uncovered member variables.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/hash.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3d66e8b..98abda9 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -38,6 +38,10 @@ struct crypto_ahash;
  *	       will save the partial state of the transformation into it. On the
  *	       other side, the @import function will load the state from a
  *	       buffer of this size as well.
+ * @base: Start of data structure of cipher algorithm. The common data
+ *	  structure of crypto_alg contains information common to all ciphers.
+ *	  The hash_alg_common data structure now adds the hash-specific
+ *	  information.
  */
 struct hash_alg_common {
 	unsigned int digestsize;
@@ -114,6 +118,7 @@ struct ahash_request {
  *	    entire state of the ongoing transformation from a provided block of
  *	    data so the transformation can continue from this point onward. No
  *	    data processing happens at this point.
+ * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
 	int (*init)(struct ahash_request *req);
@@ -153,7 +158,7 @@ struct shash_desc {
  * @setkey: see struct ahash_alg
  * @digestsize: see struct ahash_alg
  * @statesize: see struct ahash_alg
- * @dedcsize: Size of the operational state for the message digest. This state
+ * @descsize: Size of the operational state for the message digest. This state
  * 	      size is the memory size that needs to be allocated for
  *	      shash_desc.__ctx
  * @base: internally used
-- 
2.1.0


