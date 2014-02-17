Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaBQJpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41551 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaBQJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:22 -0500
X-AuditID: cbfee68f-b7f156d00000276c-67-5301da30a264
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 9/9] crypto:s5p-sss: Look for the next request in the queue
Date: Mon, 17 Feb 2014 15:14:35 +0530
Message-id: <1392630275-8667-10-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTtfgFmOwwZp5qhZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmP7/J3PBEZGKK53/2BsYPwl0MXJySAiYSGxdcoQd
	whaTuHBvPVsXIxeHkMBSRoljvyeywxSt/7YFKrGIUWJfQzuU088k8WD9QTaQKjYBM4mDi1aD
	dYgIOEv8bl7DClLELHCUUWLPuddgRcIC3hKTXt5kBbFZBFQlbndMYAKxeQVcJZ7//QBkcwCt
	U5CYM8kGJMwJFO68s50FxBYScJFY13mJBeKiZewSU5frQ4wRkPg2+RALRKusxKYDzBAlkhIH
	V9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYNCf/vesfwfj3QPWhxiTgcZN
	ZJYSTc4HRk1eSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamDcLRlnJikk6bP879loAyNpWdGMT7eq37wq+D/bll1q6XOehhd59sHnP1a3lGcvmHPd
	iXOvMv80O4V9J39tmKDzRLb7VQhv9XPr25/mNNcFXDnW8Yh3lW1Q2pkLdy+sadFNL7A4prqA
	u5GVq2iz4L7cw280/NffkLC4eOX+S3OxoHtZZY6v/hcpsRRnJBpqMRcVJwIA+sjDi5ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2DW4zBBpNXSlvcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b0/z+ZC46I
	VFzp/MfewPhJoIuRk0NCwERi/bctbBC2mMSFe+uBbC4OIYFFjBL7GtqhnH4miQfrD4JVsQmY
	SRxctJodxBYRcJb43byGFaSIWeAoo8Sec6/BioQFvCUmvbzJCmKzCKhK3O6YwARi8wq4Sjz/
	+wHI5gBapyAxZ5INSJgTKNx5ZzsLiC0k4CKxrvMSywRG3gWMDKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgqPqmdQOxpUNFocYBTgYlXh4DaoZg4VYE8uKK3MPMUpwMCuJ8NquAwrxpiRW
	VqUW5ccXleakFh9iTAY6aiKzlGhyPjDi80riDY1NzE2NTS1NLEzMLEkTVhLnPdBqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBcYnyUoktZxT4H0zn+HBdZsGdD7Kt9/fKTq9f3RG15/zMxR2Xf2Ur
	beL0nyX/MD2W75i9TmP6lswn/2VrD2qxZAUWbT/6uXDW/iIFxa+u77wZFKekL/X7suq+S9lU
	57Ikmbz3/02TeyVXdm8RyFgmvF7q+InX0vLibsWinw+y9Lxc9mnSj9Q9rUosxRmJhlrMRcWJ
	AFBR4y7uAgAA
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
CC: David S. Miller <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v6:
None

 drivers/crypto/s5p-sss.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 429b4c1..61a80c1 100644
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

