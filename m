Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaA2J1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:27:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaA2J1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:27:08 -0500
X-AuditID: cbfee68f-b7f156d00000276c-2a-52e8c96a7f3b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 9/9 v5] crypto:s5p-sss: Look for the next request in the queue
Date: Wed, 29 Jan 2014 14:57:01 +0530
Message-id: <1390987621-19019-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkWjfr5Isgg2N3zSzuPj/MaPHykKbF
	/CPnWC26X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD12zrrL7rHtgKpH35ZVjB6f
	N8kFsERx2aSk5mSWpRbp2yVwZaxYsZ65YKZwxfLG98wNjNf5uxg5OSQETCTOfb7OBmGLSVy4
	tx7I5uIQEljKKNG69T8jTNHKkweYIRKLGCUen17KDuH0M0nsXPibGaSKTcBM4uCi1ewgtoiA
	s8Tv5jWsIDazwBlGif1vgOIcHMICfhIXd1uDhFkEVCVmdG9lBgnzCrhK/L9sCmJKCChIzJlk
	AzJdQqCdXeL8tGksEOUCEt8mH2KBqJGV2HSAGeI0SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3I
	WK84Mbe4NC9dLzk/dxMjMGxP/3vWv4Px7gHrQ4zJQOMmMkuJJucDwz6vJN7Q2MzIwtTE1NjI
	3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB26H5/IWUyn1ebceWll+eb
	3yx6edh9Qu3zA935ujsnX2Soupgq7n7R9YtNP0ewXMqmvWtfnxUL2LA3zttw5QevaM/pE+aL
	BEqmVEZaOrJPvPVrX0ign/ieTzzrv15sO+b1adH/8+Yuh6d3CO9++8xVgLkr+efqVXNaDGPl
	A1bxPDP7uOW9c7CgEktxRqKhFnNRcSIAoKRDAnECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2sky+CDLbN0rO4+/wwo8XLQ5oW
	84+cY7XofiVjcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PTYOesuu8e2A6oefVtWMXp8
	3iQXwBLVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZ
	A3SJkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjxYr1zAUzhSuWN75n
	bmC8zt/FyMkhIWAisfLkAWYIW0ziwr31bF2MXBxCAosYJR6fXsoO4fQzSexc+Busik3ATOLg
	otXsILaIgLPE7+Y1rCA2s8AZRon9b4DiHBzCAn4SF3dbg4RZBFQlZnRvZQYJ8wq4Svy/bApi
	SggoSMyZZDOBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCoeCa9g3FVg8UhRgEO
	RiUe3hUXnwcJsSaWFVfmHmKU4GBWEuE9selFkBBvSmJlVWpRfnxRaU5q8SHGZKDdE5mlRJPz
	gRGbVxJvaGxibmpsamliYWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MpVftk8tz
	b325/WVPzEpHIWn3i9PPlZUJfb7y4LlVVfvdJxWTu4++7DURP7EpgduZofd6yZ25Sxersyx/
	IrLCTWX3V41+5h3n+te9r/zB/sXvlsaluhp2vlKvTRHRf1h1vmbP38Yudz/aKv3C4W8+Tw5w
	ua078v9qVWCJ317xrPqS7+K30vacVGIpzkg01GIuKk4EAGCJu+HOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

Currently, the driver enqueues a request only if the busy bit is
false. And every request initiates a dequeue. If 2 requests arrive
simultaneously, only one of them will be dequeued.

To avoid this senario, we will enqueue the next request irrespective
of the system condition (that is what queue is here for). Also
schedule at a tasklet immediatly after the current request is done.
The tasklet will dequeue the next request in the queue, giving
continuous loop. tasklet will exit if there are no requests in the
queue.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
This is a new fix in this patchset, tested with dm-crypt/ecryptfs

 drivers/crypto/s5p-sss.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 5bd3bd9..d37cbfc 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -330,8 +330,12 @@ static void s5p_aes_tx(struct s5p_aes_dev *dev)
 		}
 
 		s5p_set_dma_outdata(dev, dev->sg_dst);
-	} else
+	} else {
 		s5p_aes_complete(dev, err);
+
+		dev->busy = true;
+		tasklet_schedule(&dev->tasklet);
+	}
 }
 
 static void s5p_aes_rx(struct s5p_aes_dev *dev)
@@ -469,10 +473,13 @@ static void s5p_tasklet_cb(unsigned long data)
 	spin_lock_irqsave(&dev->lock, flags);
 	backlog   = crypto_get_backlog(&dev->queue);
 	async_req = crypto_dequeue_request(&dev->queue);
-	spin_unlock_irqrestore(&dev->lock, flags);
 
-	if (!async_req)
+	if (!async_req) {
+		dev->busy = false;
+		spin_unlock_irqrestore(&dev->lock, flags);
 		return;
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -491,14 +498,13 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
 	int err;
 
 	spin_lock_irqsave(&dev->lock, flags);
+	err = ablkcipher_enqueue_request(&dev->queue, req);
 	if (dev->busy) {
-		err = -EAGAIN;
 		spin_unlock_irqrestore(&dev->lock, flags);
 		goto exit;
 	}
 	dev->busy = true;
 
-	err = ablkcipher_enqueue_request(&dev->queue, req);
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	tasklet_schedule(&dev->tasklet);
@@ -688,6 +694,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		}
 	}
 
+	pdata->busy = false;
 	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
-- 
1.7.9.5

