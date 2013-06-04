Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3FDQ5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:57:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3FDQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Horia Geanta <horia.geanta@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/75] crypto: caam - fix inconsistent assoc dma mapping direction
Date: Tue,  4 Jun 2013 09:54:53 -0700
Message-Id: <1370364959-9475-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 286233e604d79f0c7fa04abec2180d5d89a74749 upstream.

req->assoc is dma mapped BIDIRECTIONAL and unmapped TO_DEVICE.
Since it is read-only for the device, use TO_DEVICE both for mapping
and unmapping.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/crypto/caam/caamalg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cf268b1..d482b12 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1154,7 +1154,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);
@@ -1336,7 +1336,7 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);
-- 
1.8.1.2

