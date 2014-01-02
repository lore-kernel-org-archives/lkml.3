Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaABRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:22:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaABRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 72/91] crypto: scatterwalk - Set the chain pointer indication bit
Date: Thu,  2 Jan 2014 09:04:47 -0800
Message-Id: <1388682306-30859-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/crypto/scatterwalk.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 3744d2a..09ef1a0 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -36,6 +36,7 @@ static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
-- 
1.8.3.2

