Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaB0FH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:07:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38412 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaB0FHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:07:54 -0500
X-AuditID: cbfee68e-b7f566d000002344-2b-530ec828e7da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Alexander Clouter'" <alex@digriz.org.uk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
In-reply-to: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
Subject: [PATCH 5/5] hwrng: timeriomem - Use devm_*() functions
Date: Thu, 27 Feb 2014 14:07:52 +0900
Message-id: <004201cf3379$ddf4a190$99dde4b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zeMUulUPjKSZTQeuQ54WfZho3FgAAOmTQ
Content-language: ko
x-cr-hashedpuzzle: Babd D8qS FL7t PSQR PdPI UuJY U/6g XM6f XcjP ZbTk aWlg azto
 bXKi eTzL gBwo
 tIaB;4;YQBsAGUAeABAAGQAaQBnAHIAaQB6AC4AbwByAGcALgB1AGsAOwBoAGUAcgBiAGUAcgB0AEAAZwBvAG4AZABvAHIALgBhAHAAYQBuAGEALgBvAHIAZwAuAGEAdQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{6D93E72C-55B7-42FE-A5AC-52777AA435A7};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 27 Feb 2014 05:07:45
 GMT;WwBQAEEAVABDAEgAIAA1AC8ANQBdACAAaAB3AHIAbgBnADoAIAB0AGkAbQBlAHIAaQBvAG0AZQBtACAALQAgAFUAcwBlACAAZABlAHYAbQBfACoAKAApACAAZgB1AG4AYwB0AGkAbwBuAHMA
x-cr-puzzleid: {6D93E72C-55B7-42FE-A5AC-52777AA435A7}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zA13NE3zBBh9uMFp0NIdYdL+Ssbi8
	8BKrxeVdc9gcWDzWzZvL5rHtgKpH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZVyf+J6xYJJE
	xayutawNjO+Euxg5OSQETCR+Td3ODGGLSVy4t56ti5GLQ0hgGaPE0iNtTDBF1zdvgkosYpRo
	2faZGcL5zSixvOczI0gVm4CaxJcvh9lBbBEBPYm+9Y1AcQ4OZoECifOzXUDCQgK2Es8mLWED
	sTkF7CQmTFjHAmILC9hL/PtxB2wZi4CqxJ95rWAX8QLVX7r/nBHCFpT4MfkeWD2zgJbE5m1N
	rBC2vMTmNW+ZQVZJCKhLPPqrC3GBkcSW5Q1QJSIS+168YwQ5WUKghVXi4sx1rBCPmUosfdLK
	BJF4xC5xftVMqCMEJL5NPsQCMVRWYtMBaAhJShxccYNlAqPULCQnzUJy0iwkJ81CsnsBI8sq
	RtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJAI7tvBePOA9SHGZKD1E5mlRJPzgQkgryTe0NjM
	yMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwLl2cX6oX1b6V
	5Vad1JxkmTPFaRdZOI9ndKSyNOYYvGzYUsskq/Ro4+HqqEu20hXXRXrZbFxY3VgzxQ6tdrDe
	pDrxWKljoO77jz5TVog8Ev8aviBWusZ0yrdk9m0c2S3/XNbUfa5alrm+ZK3fxRkrD6RUzT+b
	wtjTkfdKREDsH1eGsPnit8+UWIozEg21mIuKEwGCbmb09gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAV2NE3zBBlNOWVl0NIdYdL+Ssbi8
	8BKrxeVdc9gcWDzWzZvL5rHtgKpH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMWZcn/iesWCSRMWsrrWsDYzvhLsYOTkkBEwkrm/exAZhi0lcuLceyObi
	EBJYxCjRsu0zM4Tzm1Fiec9nRpAqNgE1iS9fDrOD2CICehJ96xuB4hwczAIFEudnu4CEhQRs
	JZ5NWgI2lFPATmLChHUsILawgL3Evx93mEBsFgFViT/zWplBbF6g+kv3nzNC2IISPybfA6tn
	FtCS2LytiRXClpfYvOYtM8gqCQF1iUd/dSEuMJLYsrwBqkREYt+Ld4wgJ0sItLBKXJy5jhXi
	MVOJpU9amSYwisxCsmIWkhWzkKyYhWTWAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	6eGZ9A7GVQ0WhxgFOBiVeHh/6PIFC7EmlhVX5h5ilOBgVhLhPeQCFOJNSaysSi3Kjy8qzUkt
	PsSYDAyBicxSosn5wNSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgt
	TBycUg2Mc07uLfPmsLjL+TuUK2HRk82r67pVvA+d3Nlv4btngVzgnbalC9s/R88P0ynanXcn
	ZcvDLIm+4An13wUbUr9eNLELC7OUmvLHVtG46u41/a5pPpXy6TqHV+73du+P1tEwuvB1bZmw
	+dy+5runr8Z9K9e9qyHo/6Xu17WmxCrGiH0vV8U2ep9VYinOSDTUYi4qTgQAFQ/WYlMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/timeriomem-rng.c |   40 ++++++++-----------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 73ce739..439ff8b 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -118,7 +118,8 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate memory for the device structure (and zero it) */
-	priv = kzalloc(sizeof(struct timeriomem_rng_private_data), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev,
+			sizeof(struct timeriomem_rng_private_data), GFP_KERNEL);
 	if (!priv) {
 		dev_err(&pdev->dev, "failed to allocate device structure.\n");
 		return -ENOMEM;
@@ -134,17 +135,16 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 			period = i;
 		else {
 			dev_err(&pdev->dev, "missing period\n");
-			err = -EINVAL;
-			goto out_free;
+			return -EINVAL;
 		}
-	} else
+	} else {
 		period = pdata->period;
+	}
 
 	priv->period = usecs_to_jiffies(period);
 	if (priv->period < 1) {
 		dev_err(&pdev->dev, "period is less than one jiffy\n");
-		err = -EINVAL;
-		goto out_free;
+		return -EINVAL;
 	}
 
 	priv->expires	= jiffies;
@@ -160,24 +160,16 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	priv->timeriomem_rng_ops.data_read	= timeriomem_rng_data_read;
 	priv->timeriomem_rng_ops.priv		= (unsigned long)priv;
 
-	if (!request_mem_region(res->start, resource_size(res),
-				dev_name(&pdev->dev))) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		err = -EBUSY;
+	priv->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->io_base)) {
+		err = PTR_ERR(priv->io_base);
 		goto out_timer;
 	}
 
-	priv->io_base = ioremap(res->start, resource_size(res));
-	if (priv->io_base == NULL) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		err = -EIO;
-		goto out_release_io;
-	}
-
 	err = hwrng_register(&priv->timeriomem_rng_ops);
 	if (err) {
 		dev_err(&pdev->dev, "problem registering\n");
-		goto out;
+		goto out_timer;
 	}
 
 	dev_info(&pdev->dev, "32bits from 0x%p @ %dus\n",
@@ -185,30 +177,18 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 
 	return 0;
 
-out:
-	iounmap(priv->io_base);
-out_release_io:
-	release_mem_region(res->start, resource_size(res));
 out_timer:
 	del_timer_sync(&priv->timer);
-out_free:
-	kfree(priv);
 	return err;
 }
 
 static int timeriomem_rng_remove(struct platform_device *pdev)
 {
 	struct timeriomem_rng_private_data *priv = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	hwrng_unregister(&priv->timeriomem_rng_ops);
 
 	del_timer_sync(&priv->timer);
-	iounmap(priv->io_base);
-	release_mem_region(res->start, resource_size(res));
-	kfree(priv);
 
 	return 0;
 }
-- 
1.7.10.4


