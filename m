Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828Ab3JRRgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:36:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17956 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab3JRRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:36:47 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-e5-526171ad6dd9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dan.j.williams@intel.com
Cc: vinod.koul@intel.com, dave.jiang@intel.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Dan Williams <djbw@fb.com>
Subject: [PATCH v2 13/13] dmaengine: remove DMA unmap flags
Date: Fri, 18 Oct 2013 19:35:33 +0200
Message-id: <1382117733-16720-14-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd21hYlBBiteW1psnLGe1WL61AuM
	FiduNrJZbO5/wGZxtukNu8XlXXPYLG5f5rVYP+M1i8XLvv0sDpweLc09bB4Tm9+xeyze85LJ
	o2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDKmnzzNWvCoquLHAs8GximpXYycHBICJhL3/v5h
	g7DFJC7cWw9kc3EICSxilNh7Yh8jSEJIoItJYtkrFhCbTcBKYmL7KrC4iICMxIb/25lBGpgF
	zjNKrD6wEiwhLGAtMbHvFBOIzSKgKtFwahKYzSvgKbF1xjkmiG3yEk/v94Ft5gSKT9u3nA1i
	mYfEuTMv2SYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxmz6R2MK5ssDjEKMDB
	qMTD+8AuMUiINbGsuDL3EKMEB7OSCG+ZM1CINyWxsiq1KD++qDQntfgQozQHi5I474FW60Ah
	gfTEktTs1NSC1CKYLBMHp1QDY8/N3py/AtHWns3nZ93Wf2fEXvxivvC2arZNH1aFXuty/Nj/
	/Z5gV2LVjBXfpzJl+nfIz93YHaqSef3VHq0dIh9PXU5T01rELaenLvLTbCP/n5Uedx+78Qnr
	p5lriDGt+PzycILYf9FLbQ9EX62cxbX8xjNF7gt5vxmXB0qeaS1YblrRfDn1mhJLcUaioRZz
	UXEiANuH0UwvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer needed DMA unmap flags:
- DMA_COMPL_SKIP_SRC_UNMAP
- DMA_COMPL_SKIP_DEST_UNMAP
- DMA_COMPL_SRC_UNMAP_SINGLE
- DMA_COMPL_DEST_UNMAP_SINGLE

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 crypto/async_tx/async_memcpy.c           |  3 +--
 crypto/async_tx/async_pq.c               |  1 -
 crypto/async_tx/async_raid6_recov.c      |  8 ++------
 crypto/async_tx/async_xor.c              |  6 ++----
 drivers/ata/pata_arasan_cf.c             |  3 +--
 drivers/dma/dmaengine.c                  |  3 +--
 drivers/dma/dmatest.c                    |  3 +--
 drivers/dma/ioat/dma.c                   |  3 +--
 drivers/dma/ioat/dma_v3.c                | 12 +++---------
 drivers/media/platform/m2m-deinterlace.c |  3 +--
 drivers/media/platform/timblogiw.c       |  2 +-
 drivers/misc/carma/carma-fpga.c          |  3 +--
 drivers/mtd/nand/atmel_nand.c            |  3 +--
 drivers/mtd/nand/fsmc_nand.c             |  2 --
 drivers/net/ethernet/micrel/ks8842.c     |  6 ++----
 drivers/ntb/ntb_transport.c              |  3 +--
 drivers/spi/spi-dw-mid.c                 |  4 ++--
 include/linux/dmaengine.h                | 18 ++++--------------
 18 files changed, 25 insertions(+), 61 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 7275021..f8c0b8d 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -56,8 +56,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
 
 	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 4126b56..d05327c 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -62,7 +62,6 @@ do_async_gen_syndrome(struct dma_chan *chan,
 	dma_addr_t dma_dest[2];
 	int src_off = 0;
 
-	dma_flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 	if (submit->flags & ASYNC_TX_FENCE)
 		dma_flags |= DMA_PREP_FENCE;
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a3a72a7..934a849 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -47,9 +47,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		struct device *dev = dma->dev;
 		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -113,9 +111,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		dma_addr_t dma_dest[2];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index d2cc77d..3c562f5 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -41,7 +41,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
 	enum async_tx_flags flags_orig = submit->flags;
-	enum dma_ctrl_flags dma_flags;
+	enum dma_ctrl_flags dma_flags = 0;
 	int src_cnt = unmap->to_cnt;
 	int xor_src_cnt;
 	dma_addr_t dma_dest = unmap->addr[unmap->to_cnt];
@@ -55,7 +55,6 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
-		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
@@ -284,8 +283,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 853f610..e88690e 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -396,8 +396,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *chan = acdev->dma_chan;
 	dma_cookie_t cookie;
-	unsigned long flags = DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	unsigned long flags = DMA_PREP_INTERRUPT;
 	int ret = 0;
 
 	tx = chan->device->device_prep_dma_memcpy(chan, dest, src, len, flags);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index f878c80..b69ac38 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1065,8 +1065,7 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	unmap->addr[1] = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				      DMA_FROM_DEVICE);
 	unmap->len = len;
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, unmap->addr[1], unmap->addr[0],
 					 len, flags);
 
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index f4a2a25..5791091 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -599,8 +599,7 @@ static int dmatest_func(void *data)
 	/*
 	 * src and dst buffers are freed by ourselves below
 	 */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	while (!kthread_should_stop()
 	       && !(params->iterations && total_tests >= params->iterations)) {
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index c123e32..6fcf741 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -818,8 +818,7 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
 	if (!tx) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 43386c1..a4798f0 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1279,9 +1279,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT |
-				      DMA_COMPL_SKIP_SRC_UNMAP |
-				      DMA_COMPL_SKIP_DEST_UNMAP);
+				      DMA_PREP_INTERRUPT);
 
 	if (!tx) {
 		dev_err(dev, "Self-test xor prep failed\n");
@@ -1342,9 +1340,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test zero prep failed\n");
 		err = -ENODEV;
@@ -1389,9 +1385,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test 2nd zero prep failed\n");
 		err = -ENODEV;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 540516c..879ea6f 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -341,8 +341,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	ctx->xt->dir = DMA_MEM_TO_MEM;
 	ctx->xt->src_sgl = false;
 	ctx->xt->dst_sgl = true;
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
 	if (tx == NULL) {
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index b557caf..59a95e3 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -565,7 +565,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	desc = dmaengine_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 08b18f3..9e2b985 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -633,8 +633,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
-	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
-				  DMA_COMPL_SKIP_SRC_UNMAP;
+	unsigned long dma_flags = 0;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 2dbd913..39d3c02 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -375,8 +375,7 @@ static int atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
 
 	dma_dev = host->dma_chan->device;
 
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	phys_addr = dma_map_single(dma_dev->dev, p, len, dir);
 	if (dma_mapping_error(dma_dev->dev, phys_addr)) {
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 3dc1a75..8b27522 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -573,8 +573,6 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
 
-	flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
-
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;
 		dma_dst = host->data_pa;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 0951f7a..822616e 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -459,8 +459,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
 
 	ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-		&ctl->sg, 1, DMA_MEM_TO_DEV,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		&ctl->sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
 
@@ -571,8 +570,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 		sg_dma_len(sg) = DMA_BUFFER_SIZE;
 
 		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
 		if (!ctl->adesc)
 			goto out;
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index fc6bbf1..bc7a55c 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1072,8 +1072,7 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
 
 	unmap->from_cnt = 1;
 
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	txd = device->device_prep_dma_memcpy(chan, unmap->addr[1],
 					     unmap->addr[0], len, flags);
 	if (!txd)
diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index b9f0192..6d207af 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -150,7 +150,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->tx_sgl,
 				1,
 				DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
@@ -173,7 +173,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->rx_sgl,
 				1,
 				DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3782cdb..491072c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -171,12 +171,6 @@ struct dma_interleaved_template {
  * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
  *  acknowledges receipt, i.e. has has a chance to establish any dependency
  *  chains
- * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
- * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
- * @DMA_COMPL_SRC_UNMAP_SINGLE - set to do the source dma-unmapping as single
- * 	(if not set, do the source dma-unmapping as page)
- * @DMA_COMPL_DEST_UNMAP_SINGLE - set to do the destination dma-unmapping as single
- * 	(if not set, do the destination dma-unmapping as page)
  * @DMA_PREP_PQ_DISABLE_P - prevent generation of P while generating Q
  * @DMA_PREP_PQ_DISABLE_Q - prevent generation of Q while generating P
  * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
@@ -188,14 +182,10 @@ struct dma_interleaved_template {
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
-	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
-	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
-	DMA_COMPL_SRC_UNMAP_SINGLE = (1 << 4),
-	DMA_COMPL_DEST_UNMAP_SINGLE = (1 << 5),
-	DMA_PREP_PQ_DISABLE_P = (1 << 6),
-	DMA_PREP_PQ_DISABLE_Q = (1 << 7),
-	DMA_PREP_CONTINUE = (1 << 8),
-	DMA_PREP_FENCE = (1 << 9),
+	DMA_PREP_PQ_DISABLE_P = (1 << 2),
+	DMA_PREP_PQ_DISABLE_Q = (1 << 3),
+	DMA_PREP_CONTINUE = (1 << 4),
+	DMA_PREP_FENCE = (1 << 5),
 };
 
 /**
-- 
1.8.2.3

