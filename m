Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaD1KsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:48:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52688 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaD1KrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:47:10 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-0a-535e31ad2779
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 7/7 v8] crypto:s5p-sss: Look for the next request in the queue
Date: Mon, 28 Apr 2014 16:14:59 +0530
Message-id: <1398681899-20782-8-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRnetYVywwaVb/BYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKmHlZqOCiSMXvWxOZGxj/CnQxcnJICJhIbD+ygg3C
	FpO4cG89kM3FISSwlFFiybw2dpiik42rWSES0xklts27zATh9DNJzL28nBGkik3ATOLgotVg
	HSICzhK/m9eAdTALrGOU+PTmMBNIQljAT2JJ63uwIhYBVYm25jawZl4BV4mfn74B1XAArVOQ
	mDPJBiTMKeAmcXX9ObASIaCSpb0/mEFmSgisYpc4P20eG8QcAYlvkw+xQPTKSmw6wAxxtaTE
	wRU3WCYwCi9gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERj0p/89693BePuA9SHGZKBx
	E5mlRJPzgVGTVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2M6tc6ejyD82U+3L/x+kdAjbr4/q0ptTvk2Xdz67K8SmA/wKTyL3XTJj8JDd4z7cem
	M23bZpHQw3ku7MbdtAvTryu+u5V37E3Kb717b/20Vt66V/qUcf6Gl6sfSGzsPnrNRabl66Rk
	0VN3vj7Yt/Wx2e8u3pSLrJsmvWffs/BWbeQFETFeXlv+a0osxRmJhlrMRcWJAJ57X0KQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd21hnHBBpv/sVu8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bMy0IFF0Uq
	ft+ayNzA+Fegi5GTQ0LAROJk42pWCFtM4sK99WxdjFwcQgLTGSW2zbvMBOH0M0nMvbycEaSK
	TcBM4uCi1ewgtoiAs8Tv5jWsIEXMAusYJT69OcwEkhAW8JNY0voerIhFQFWirbkNrJlXwFXi
	56dvQDUcQOsUJOZMsgEJcwq4SVxdfw6sRAioZGnvD+YJjLwLGBlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgTH1DPpHYyrGiwOMQpwMCrx8EbMiQ0WYk0sK67MPcQowcGsJMK7XyIuWIg3
	JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgfGeVxJvaGxibmpsamliYWJmSZqwkjjvwVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MC5ese7FcLaPu7w3F9RLzrA7wam5clstxpHq56TaVWRMmx0r9
	b/5+8umElyzHXjx5dbPd++fPFYv6lp6OZPVre8BkOEvJO1W0N3Hb+5APNpvWmtustjilLdH3
	TlUixfVc5pZUoZzTN75/9xFfwCzGclj0Gt/qoyvKl2zulGUKf3ib1/OSN593iRJLcUaioRZz
	UXEiALq8ZULtAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the driver enqueues a request only if the busy bit is
false. And every request initiates a dequeue. If 2 requests arrive
simultaneously, only one of them will be dequeued.

To avoid this senario, we will enqueue the next request irrespective
of the system condition (that is what queue is here for). Also
schedule at a tasklet immediatly after the current request is done.
The tasklet will dequeue the next request in the queue, giving
continuous loop. tasklet will exit if there are no requests in the
queue.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Changes since v6:
None

 drivers/crypto/s5p-sss.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index ea7d478..47c568e 100644
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
@@ -683,6 +689,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		}
 	}
 
+	pdata->busy = false;
 	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
-- 
1.7.9.5

