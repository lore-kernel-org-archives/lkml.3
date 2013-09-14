Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3INCvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:51:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51588 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3INCvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:51:51 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-aa-5233cf44dbdf
From: Chanho Park <chanho61.park@samsung.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: jassisinghbrar@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Boojin Kim <boojin.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCHv2] dma: pl330: add pl330_prep_dma_sg to transfer from sglist to
 sglist
Date: Sat, 14 Sep 2013 11:50:19 +0900
Message-id: <1379127019-3540-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkUNflvHGQwbRlqhZvTv5hs7i8X9ti
	+tQLjBbXVsxltzjb9IbdYtPja6wWl3fNYbOYcX4fk8XLvv0sDpweO2fdZfdYvOclk8fmJfUe
	fVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlbHvzF3WgnlmFc2LPjA1MG7T7mLk5JAQMJG437iH
	BcIWk7hwbz1bFyMXh5DAUkaJv5/2sMIUTWpcApVYxCgx49F1JginjUliyeLzTCBVbAK6Elue
	v2IEsUUEjCROTbnKClLELNDEJNG2YTdYkbBAhMTe50vBxrIIqEp0fpvK3MXIwcEr4CFxbm4I
	iCkhoCAxZ5INSKuEQD+7xNmlc9khygUkvk0+xAJRIyux6QAzxHGSEgdX3GCZwCi4gJFhFaNo
	akFyQXFSepGxXnFibnFpXrpecn7uJkZgGJ/+96x/B+PdA9aHGJOBxk1klhJNzgfGQV5JvKGx
	mZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGH1kGlg96pJF
	zljEv14w7/2qKaIpdgaZLiu3Lk/r7CvN4ZFrjlOXdLx2vDvlbV7616kr5931eJ2Z0GH/MT7z
	QHVF8/oF7pMUDc8debaIfVNNVqnEDqasmdailRL383455oufq3ZWXDlz+4vJt15e5clawmfa
	pbnhc9uOitV/FL64/fokmxoaqsRSnJFoqMVcVJwIAIFQ21R5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAV2X88ZBBguvS1u8OfmHzeLyfm2L
	6VMvMFpcWzGX3eJs0xt2i02Pr7FaXN41h81ixvl9TBYv+/azOHB67Jx1l91j8Z6XTB6bl9R7
	9G1ZxejxeZNcAGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
	i0+ArltmDtA9SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMfWfushbM
	M6toXvSBqYFxm3YXIyeHhICJxKTGJWwQtpjEhXvrgWwuDiGBRYwSMx5dZ4Jw2pgkliw+zwRS
	xSagK7Hl+StGEFtEwEji1JSrrCBFzAJNTBJtG3aDFQkLREjsfb6UFcRmEVCV6Pw2lbmLkYOD
	V8BD4tzcEBBTQkBBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfJM6kd
	jCsbLA4xCnAwKvHwfvA1DhJiTSwrrsw9xCjBwawkwntiLlCINyWxsiq1KD++qDQntfgQYzLQ
	7onMUqLJ+cAIziuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	RvZ/ygLHNyxma0ivstU4P/3IHw55n3cuLfft73FdnrX4SXzOvt7p9pMnR0/oCDjNtkLXvcBQ
	o+a0qML/8wpfvN3UUm1Z9yy8LsHEda+tyTWAX/L1hTVb3R6v7BdMSz/tpH335aSAP84Xyw1W
	WP349ez0FYEJrzeHS7/u9fZTTA08/D01rPrVPCWW4oxEQy3mouJEACjtuEbWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds prep_dma_sg function to transfer memory to memory which
mapped in scatter/gather list. The patch move get_burst_len to upwards to
call in the __pl330_prep_dma_mecpy. Some duplicated code was splitted off
from prep_dma_memcpy.
This patch also included previous Boojon Kim's patch[1] which fixes burst_size
calculation. The burst_size should be aligned not only length but also source
and destionation addresses.

[1] : http://lkml.indiana.edu/hypermail/linux/kernel/1201.1/00246.html

Cc: Boojin Kim <boojin.kim@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/pl330.c |  179 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 138 insertions(+), 41 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a562d24..b272ee6 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2602,9 +2602,33 @@ static inline void fill_px(struct pl330_xfer *px,
 	px->src_addr = src;
 }
 
+/* Call after fixing burst size */
+static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
+{
+	struct dma_pl330_chan *pch = desc->pchan;
+	struct pl330_info *pi = &pch->dmac->pif;
+	int burst_len;
+
+	burst_len = pi->pcfg.data_bus_width / 8;
+	burst_len *= pi->pcfg.data_buf_dep;
+	burst_len >>= desc->rqcfg.brst_size;
+
+	/* src/dst_burst_len can't be more than 16 */
+	if (burst_len > 16)
+		burst_len = 16;
+
+	while (burst_len > 1) {
+		if (!(len % (burst_len << desc->rqcfg.brst_size)))
+			break;
+		burst_len--;
+	}
+
+	return burst_len;
+}
+
 static struct dma_pl330_desc *
 __pl330_prep_dma_memcpy(struct dma_pl330_chan *pch, dma_addr_t dst,
-		dma_addr_t src, size_t len)
+		dma_addr_t src, size_t len, int burst)
 {
 	struct dma_pl330_desc *desc = pl330_get_desc(pch);
 
@@ -2626,31 +2650,23 @@ __pl330_prep_dma_memcpy(struct dma_pl330_chan *pch, dma_addr_t dst,
 	 */
 	fill_px(&desc->px, dst, src, len);
 
-	return desc;
-}
-
-/* Call after fixing burst size */
-static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
-{
-	struct dma_pl330_chan *pch = desc->pchan;
-	struct pl330_info *pi = &pch->dmac->pif;
-	int burst_len;
-
-	burst_len = pi->pcfg.data_bus_width / 8;
-	burst_len *= pi->pcfg.data_buf_dep;
-	burst_len >>= desc->rqcfg.brst_size;
-
-	/* src/dst_burst_len can't be more than 16 */
-	if (burst_len > 16)
-		burst_len = 16;
+	desc->rqcfg.src_inc = 1;
+	desc->rqcfg.dst_inc = 1;
+	desc->req.rqtype = MEMTOMEM;
 
-	while (burst_len > 1) {
-		if (!(len % (burst_len << desc->rqcfg.brst_size)))
+	while (burst > 1) {
+		if (!(len % burst) && !(len % dst) && !(len % src))
 			break;
-		burst_len--;
+		burst /= 2;
 	}
 
-	return burst_len;
+	desc->rqcfg.brst_size = 0;
+	while (burst != (1 << desc->rqcfg.brst_size))
+		desc->rqcfg.brst_size++;
+
+	desc->rqcfg.brst_len = get_burst_len(desc, len);
+
+	return desc;
 }
 
 static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
@@ -2752,28 +2768,12 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 
 	pi = &pch->dmac->pif;
 
-	desc = __pl330_prep_dma_memcpy(pch, dst, src, len);
-	if (!desc)
-		return NULL;
-
-	desc->rqcfg.src_inc = 1;
-	desc->rqcfg.dst_inc = 1;
-	desc->req.rqtype = MEMTOMEM;
-
 	/* Select max possible burst size */
 	burst = pi->pcfg.data_bus_width / 8;
 
-	while (burst > 1) {
-		if (!(len % burst))
-			break;
-		burst /= 2;
-	}
-
-	desc->rqcfg.brst_size = 0;
-	while (burst != (1 << desc->rqcfg.brst_size))
-		desc->rqcfg.brst_size++;
-
-	desc->rqcfg.brst_len = get_burst_len(desc, len);
+	desc = __pl330_prep_dma_memcpy(pch, dst, src, len, burst);
+	if (!desc)
+		return NULL;
 
 	desc->txd.flags = flags;
 
@@ -2803,6 +2803,102 @@ static void __pl330_giveback_desc(struct dma_pl330_dmac *pdmac,
 }
 
 static struct dma_async_tx_descriptor *
+pl330_prep_dma_sg(struct dma_chan *chan,
+	struct scatterlist *dst_sg, unsigned int dst_nents,
+	struct scatterlist *src_sg, unsigned int src_nents,
+	unsigned long flags)
+{
+	struct dma_pl330_desc *first, *desc = NULL;
+	struct dma_pl330_chan *pch = to_pchan(chan);
+	struct pl330_info *pi;
+	dma_addr_t src, dst;
+	size_t len, dst_len = 0, src_len = 0;
+	int burst;
+
+	if (unlikely(!pch))
+		return NULL;
+
+	pi = &pch->dmac->pif;
+
+	/* basic sanity checks */
+	if (dst_nents == 0 || src_nents == 0)
+		return NULL;
+
+	if (dst_sg == NULL || src_sg == NULL)
+		return NULL;
+
+	first = NULL;
+
+	/* Select max possible burst size */
+	burst = pi->pcfg.data_bus_width / 8;
+
+	/* get prepared for the loop */
+	dst_len = sg_dma_len(dst_sg);
+	src_len = sg_dma_len(src_sg);
+
+	while (true) {
+		len = min_t(size_t, src_len, dst_len);
+
+		if (len == 0)
+			goto fetch;
+
+		dst = sg_dma_address(dst_sg) + sg_dma_len(dst_sg) - dst_len;
+		src = sg_dma_address(src_sg) + sg_dma_len(src_sg) - src_len;
+
+		desc = __pl330_prep_dma_memcpy(pch, dst, src, len, burst);
+		if (!desc) {
+			struct dma_pl330_dmac *pdmac = pch->dmac;
+
+			dev_err(pdmac->pif.dev,
+				"%s:%d Unable to fetch desc\n",
+				__func__, __LINE__);
+
+			__pl330_giveback_desc(pdmac, first);
+
+			return NULL;
+		}
+		if (!first)
+			first = desc;
+		else
+			list_add_tail(&desc->node, &first->node);
+
+		desc->txd.flags = flags;
+
+		dst_len -= len;
+		src_len -= len;
+
+fetch:
+		/* fetch the next dst scatterlist entry */
+		if (dst_len == 0) {
+			/* no more entries: we're done */
+			if (dst_nents == 0)
+				break;
+			/* fetch the next entry: if there are no more: done */
+			dst_sg = sg_next(dst_sg);
+			if (dst_sg == NULL)
+				break;
+			dst_nents--;
+			dst_len = sg_dma_len(dst_sg);
+		}
+
+		/* fetch the next src scatterlist entry */
+		if (src_len == 0) {
+			/* no more entries: we're done */
+			if (src_nents == 0)
+				break;
+			/* fetch the next entry: if there are no more: done */
+			src_sg = sg_next(src_sg);
+			if (src_sg == NULL)
+				break;
+			src_nents--;
+			src_len = sg_dma_len(src_sg);
+		}
+	}
+
+	return &first->txd;
+}
+
+static struct dma_async_tx_descriptor *
 pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flg, void *context)
@@ -2989,6 +3085,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pd->device_alloc_chan_resources = pl330_alloc_chan_resources;
 	pd->device_free_chan_resources = pl330_free_chan_resources;
 	pd->device_prep_dma_memcpy = pl330_prep_dma_memcpy;
+	pd->device_prep_dma_sg = pl330_prep_dma_sg;
 	pd->device_prep_dma_cyclic = pl330_prep_dma_cyclic;
 	pd->device_tx_status = pl330_tx_status;
 	pd->device_prep_slave_sg = pl330_prep_slave_sg;
-- 
1.7.9.5

