Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaBGF1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:27:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24731 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaBGF1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:27:20 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-95-52f46eb61645
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 9/9 v6] crypto:s5p-sss: Look for the next request in the queue
Date: Fri, 07 Feb 2014 10:57:02 +0530
Message-id: <1391750822-27572-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390987621-19019-1-git-send-email-ch.naveen@samsung.com>
References: <1390987621-19019-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSndb3pcgg62bzC3uPj/MaPHykKbF
	nPMtLBbdr2Qs7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV8bRjDnPBEZGK1rOPmRoYPwl0MXJySAiYSNy9/ZwR
	whaTuHBvPVsXIxeHkMBSRokV/5+wwxSt+7+UHSKxiFHiee8bJginn0niwc2jYFVsAmYSBxet
	BrNFBJwlfjevYQUpYha4zSix6NhbFpCEsICfxIf/vWwgNouAqsT2Y9PAGngFXCWuPewGmsoB
	tE5BYs4kG5Awp4CbxNsNc8BKhIBKXu9tAbtCQmAVu8S33SuYIOYISHybfIgFoldWYtMBZoir
	JSUOrrjBMoFReAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwLA//e/ZxB2M9w9YH2JM
	Bho3kVlKNDkfGDd5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cCYL8fru03wuu6VvpeHtWPVC4KLuP5G/+N/VG659Nye1KycjTnrf08MNHcRYpDy
	aeZLy7Lhll0ce8/i2p1OCYYrtV0WpY9yK8wWT6n5OOV7XZHLxWXlpnd3n/ouuzGmc++Ud2nu
	/1fMviV5wnyewSSeG5p57CeW3lP+L3T3pP+fU4ejdl2I9ZuuxFKckWioxVxUnAgA6vy3q5EC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd1teV+CDP5M07W4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi7NzDjE5cHpsWXmTyWPnrLvsHtsOqHr0
	bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoynHXOYC46I
	VLSefczUwPhJoIuRk0NCwERi3f+l7BC2mMSFe+vZuhi5OIQEFjFKPO99wwTh9DNJPLh5FKyK
	TcBM4uCi1WC2iICzxO/mNawgRcwCtxklFh17ywKSEBbwk/jwv5cNxGYRUJXYfmwaWAOvgKvE
	tYfdQFM5gNYpSMyZZAMS5hRwk3i7YQ5YiRBQyeu9LewTGHkXMDKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAiOqmfSOxhXNVgcYhTgYFTi4T2x9HOQEGtiWXFl7iFGCQ5mJRFe7oQvQUK8
	KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4z4vJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgXBm7l/u7otytLbN+GWxbGHz9iL7ggy8q7ZKqqWHCn8Oa3Uy0
	o759TH3VJKm1caP4M8Z30kxfA99pbO4X6pLo3P7ad8JFBevFzEUGtx88NtvOcN1JpD6HXZHx
	mdls05cqRhybTz6Mentk49L92zZOYdwuvVX+7CLHWv2wRYH3TlqbcLqVB0s+UWIpzkg01GIu
	Kk4EADsn47zuAgAA
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
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
changes since v5:
None

 drivers/crypto/s5p-sss.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index d35a477..63dd679 100644
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

