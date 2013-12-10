Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3LJH71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:59:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3LJH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.4 01/25] crypto: scatterwalk - Set the chain pointer indication bit
Date: Tue, 10 Dec 2013 00:00:09 -0800
Message-Id: <20131210075930.917877325@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/crypto/scatterwalk.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -36,6 +36,7 @@ static inline void scatterwalk_sg_chain(
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)


