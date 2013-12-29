Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3L2Cpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:45:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55295 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab3L2CK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:27 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Tom Lendacky" <thomas.lendacky@amd.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.504268211@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 105/185] crypto: scatterwalk - Set the chain pointer
 indication bit
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 41da8b5adba77e22584f8b45f9641504fa885308 upstream.

The scatterwalk_crypto_chain function invokes the scatterwalk_sg_chain
function to chain two scatterlists, but the chain pointer indication
bit is not set.  When the resulting scatterlist is used, for example,
by sg_nents to count the number of scatterlist entries, a segfault occurs
because sg_nents does not follow the chain pointer to the chained scatterlist.

Update scatterwalk_sg_chain to set the chain pointer indication bit as is
done by the sg_chain function.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/crypto/scatterwalk.h | 1 +
 1 file changed, 1 insertion(+)

--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -58,6 +58,7 @@ static inline void scatterwalk_sg_chain(
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)

