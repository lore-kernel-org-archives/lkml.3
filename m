Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3FEVwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:52:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab3FEVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Horia Geanta <horia.geanta@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 072/127] crypto: caam - fix inconsistent assoc dma mapping direction
Date: Wed,  5 Jun 2013 14:33:59 -0700
Message-Id: <20130605213226.130693078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horia Geanta <horia.geanta@freescale.com>

commit 286233e604d79f0c7fa04abec2180d5d89a74749 upstream.

req->assoc is dma mapped BIDIRECTIONAL and unmapped TO_DEVICE.
Since it is read-only for the device, use TO_DEVICE both for mapping
and unmapping.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamalg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1154,7 +1154,7 @@ static struct aead_edesc *aead_edesc_all
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);
@@ -1336,7 +1336,7 @@ static struct aead_edesc *aead_giv_edesc
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);


