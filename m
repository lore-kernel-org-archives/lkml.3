Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaBQJqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:46:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29405 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaBQJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:46:04 -0500
X-AuditID: cbfee690-b7f266d00000287c-32-5301da5b797f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 9/9 v7] crypto:s5p-sss: Look for the next request in the queue
Date: Mon, 17 Feb 2014 15:15:32 +0530
Message-id: <1392630332-8782-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkRjf6FmOwwfJNQhZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmP7/J3PBEZGKK53/2BsYPwl0MXJySAiYSDw538QM
	YYtJXLi3nq2LkYtDSGApo8Si9qtsMEUHX99jgUgsYpT4uWkvlNPPJPF+7TZ2kCo2ATOJg4tW
	g9kiAs4Sv5vXsIIUMQscZZTYc+412ChhAT+Jk/1zwGwWAVWJqSdOMXYxcnDwCrhIzP7mAGJK
	CChIzJlkA9IqIdDPLrFsyzlGiHIBiW+TD7FA1MhKbDoAdbWkxMEVN1gmMAouYGRYxSiaWpBc
	UJyUXmSiV5yYW1yal66XnJ+7iREYxKf/PZuwg/HeAetDjMlA4yYyS4km5wOjIK8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDmTDX+tZ3o2zf2p
	xFa/Tp7K5rsVs0+tPJnf5cye+p83/tLq2d+4OQ/v5vjG6+L+3GN/aOTyQiG5sE5Vj+ZlXme3
	MbtHcrj5vTl7Iy773EMJ9aAXj5/YzZbQzY6WvHG1MjG2xuBc++PSJ8vvbMsP/frU6uWPHqVm
	BqW9ezYtyo0TDeTcvSPFWYmlOCPRUIu5qDgRAMpcfU54AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jAd3oW4zBBt3vuSzuPj/MaPHykKbF
	nPMtLBbdr2Qs7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWP6/5/MBUdE
	Kq50/mNvYPwk0MXIySEhYCJx8PU9FghbTOLCvfVsXYxcHEICixglfm7aywLh9DNJvF+7jR2k
	ik3ATOLgotVgtoiAs8Tv5jWsIEXMAkcZJface80GkhAW8JM42T8HzGYRUJWYeuIUYxcjBwev
	gIvE7G8OIKaEgILEnEk2Exi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjpFn0jsY
	VzVYHGIU4GBU4uHtrGUMFmJNLCuuzD3EKMHBrCTCa7sOKMSbklhZlVqUH19UmpNafIgxGWj3
	RGYp0eR8YPzmlcQbGpuYmxqbWppYmJhZkiasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANj
	db79U4Zdhb1GclWbAsRqqpc4/ms+N6eVudHL/5mabqlB3IrwgE07bPdYX8uo3n6/o1jqpH7M
	acPJB7xdetb4XziaoO84tzXz5YMm87hVa847nZgVue2q6sHQDpYp2+9tLlj5enre3tL+Sj1b
	nj2b847veN9owH1jxdEv7zVfZwY3PanhutihxFKckWioxVxUnAgAk91jZ9UCAAA=
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

