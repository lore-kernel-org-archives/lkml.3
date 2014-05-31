Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbaEaNOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:14:50 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43463 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaEaNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:14:46 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/11] drivers/media: Remove useless return variables
Date: Sat, 31 May 2014 10:14:09 -0300
Message-Id: <1401542051-3174-9-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/pci/ngene/ngene-core.c      |   11 ++---------
 drivers/media/usb/cx231xx/cx231xx-video.c |   11 +++++------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 970e833..d8435a5 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -910,7 +910,6 @@ static int AllocateRingBuffers(struct pci_dev *pci_dev,
 {
 	dma_addr_t tmp;
 	u32 i, j;
-	int status = 0;
 	u32 SCListMemSize = pRingBuffer->NumBuffers
 		* ((Buffer2Length != 0) ? (NUM_SCATTER_GATHER_ENTRIES * 2) :
 		    NUM_SCATTER_GATHER_ENTRIES)
@@ -1010,18 +1009,12 @@ static int AllocateRingBuffers(struct pci_dev *pci_dev,
 
 	}
 
-	return status;
+	return 0;
 }
 
 static int FillTSIdleBuffer(struct SRingBufferDescriptor *pIdleBuffer,
 			    struct SRingBufferDescriptor *pRingBuffer)
 {
-	int status = 0;
-
-	/* Copy pointer to scatter gather list in TSRingbuffer
-	   structure for buffer 2
-	   Load number of buffer
-	*/
 	u32 n = pRingBuffer->NumBuffers;
 
 	/* Point to first buffer entry */
@@ -1038,7 +1031,7 @@ static int FillTSIdleBuffer(struct SRingBufferDescriptor *pIdleBuffer,
 			pIdleBuffer->Head->ngeneBuffer.Number_of_entries_1;
 		Cur = Cur->Next;
 	}
-	return status;
+	return 0;
 }
 
 static u32 RingBufferSizes[MAX_STREAM] = {
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 1f87513..cba7fea 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -208,7 +208,7 @@ static inline void get_next_buf(struct cx231xx_dmaqueue *dma_q,
 static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 {
 	struct cx231xx_dmaqueue *dma_q = urb->context;
-	int i, rc = 1;
+	int i;
 	unsigned char *p_buffer;
 	u32 bytes_parsed = 0, buffer_size = 0;
 	u8 sav_eav = 0;
@@ -299,13 +299,12 @@ static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 		bytes_parsed = 0;
 
 	}
-	return rc;
+	return 1;
 }
 
 static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 {
 	struct cx231xx_dmaqueue *dma_q = urb->context;
-	int rc = 1;
 	unsigned char *p_buffer;
 	u32 bytes_parsed = 0, buffer_size = 0;
 	u8 sav_eav = 0;
@@ -379,7 +378,7 @@ static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
 		bytes_parsed = 0;
 
 	}
-	return rc;
+	return 1;
 }
 
 
@@ -1620,7 +1619,7 @@ static int radio_s_tuner(struct file *file, void *priv, const struct v4l2_tuner
  */
 static int cx231xx_v4l2_open(struct file *filp)
 {
-	int errCode = 0, radio = 0;
+	int radio = 0;
 	struct video_device *vdev = video_devdata(filp);
 	struct cx231xx *dev = video_drvdata(filp);
 	struct cx231xx_fh *fh;
@@ -1718,7 +1717,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 	mutex_unlock(&dev->lock);
 	v4l2_fh_add(&fh->fh);
 
-	return errCode;
+	return 0;
 }
 
 /*

