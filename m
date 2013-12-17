Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3LQSPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3LQSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 082/103] crypto: scatterwalk - Use sg_chain_ptr on chain entries
Date: Tue, 17 Dec 2013 18:13:11 +0000
Message-Id: <1387304012-23805-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 389a5390583a18e45bc4abd4439291abec5e7a63 upstream.

Now that scatterwalk_sg_chain sets the chain pointer bit the sg_page
call in scatterwalk_sg_next hits a BUG_ON when CONFIG_DEBUG_SG is
enabled. Use sg_chain_ptr instead of sg_page on a chain entry.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/crypto/scatterwalk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 09ef1a0..2cddd2b 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -44,7 +44,7 @@ static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 	if (sg_is_last(sg))
 		return NULL;
 
-	return (++sg)->length ? sg : (void *)sg_page(sg);
+	return (++sg)->length ? sg : sg_chain_ptr(sg);
 }
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
-- 
1.8.3.2

