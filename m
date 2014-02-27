Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaB0FEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:04:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44508 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaB0FEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:04:32 -0500
X-AuditID: cbfee690-b7f266d00000287c-d0-530ec75c6df3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Jamie Iles'" <jamie@jamieiles.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
In-reply-to: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
Subject: [PATCH 3/5] hwrng: pixocell - Use devm_clk_get()
Date: Thu, 27 Feb 2014 14:04:28 +0900
Message-id: <004001cf3379$64363fd0$2ca2bf70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zeMUulUPjKSZTQeuQ54WfZho3FgAAFZBA
Content-language: ko
x-cr-hashedpuzzle: BJUC BUw1 Kv/V P8Oc RjN2 Vxn5 V0Tg WHTH X8/t bN4Z bfvc eCAF
 gwWm hh50 llnQ
 n78+;4;aABlAHIAYgBlAHIAdABAAGcAbwBuAGQAbwByAC4AYQBwAGEAbgBhAC4AbwByAGcALgBhAHUAOwBqAGEAbQBpAGUAQABqAGEAbQBpAGUAaQBsAGUAcwAuAGMAbwBtADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{2BA754ED-9503-43E3-A38F-33EF4EC23F42};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 27 Feb 2014 05:04:22
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANQBdACAAaAB3AHIAbgBnADoAIABwAGkAeABvAGMAZQBsAGwAIAAtACAAVQBzAGUAIABkAGUAdgBtAF8AYwBsAGsAXwBnAGUAdAAoACkA
x-cr-puzzleid: {2BA754ED-9503-43E3-A38F-33EF4EC23F42}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ92Y43zBBrefall0v5KxmLF5PpPF
	5YWXWC0u75rD5sDise2Aqsee7v/sHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXR8f0iW8FP
	roqOuX+YGxg7OLsYOTkkBEwkvj9azgJhi0lcuLeerYuRi0NIYBmjxOYlWxhhijr7FzNDJBYx
	Smz7/44RwvnNKLF/wzo2kCo2ATWJL18Os4PYIgJ6En3rG8G6mQWyJC4uPQFmCwnYSjybtASs
	nlPATmLChHVgq4UFLCXetJ8AinNwsAioSlz57wgS5gUq/9SxghHCFpT4MfkeC8RILYnN25pY
	IWx5ic1r3jKDtEoIqEs8+qsLcYGRRMfCw0wQJSIS+15AnCwh8IVF4si0s8wQj5lKNJ94DZW4
	xy5xfPFRsGUsAgIS3yYfYoEYKiux6QBUvaTEwRU3WCYwSs1CctIsJCfNQnLSLCS7FzCyrGIU
	TS1ILihOSi8y0StOzC0uzUvXS87P3cQIieEJOxjvHbA+xJgMtH4is5Rocj4wBeSVxBsamxlZ
	mJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+MyTRuFJ4tLFxlx
	MGreL1pxX3Hf83qNhsxVRtPCdE89nfPvd7zm4V9+ThOOGrZLlV7Mu72bR8H4UgmHc8fZeG0B
	VWcX9zPr/3KardyxXuXF59R4lksHY+5xnxPYNGG1UV9AlVXEy7vP7DoTN6j1ut9dESh2bfXi
	0EV8TlU/JddZfmS9H2X9O0uJpTgj0VCLuag4EQBOUqxs9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd2Y43zBBlsa1S26X8lYzNg8n8ni
	8sJLrBaXd81hc2Dx2HZA1WNP9392j74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM6Ph+ka3gJ1dFx9w/zA2MHZxdjJwcEgImEp39i5khbDGJC/fWs3Ux
	cnEICSxilNj2/x0jhPObUWL/hnVsIFVsAmoSX74cZgexRQT0JPrWNzKC2MwCWRIXl54As4UE
	bCWeTVoCVs8pYCcxYcI6FhBbWMBS4k37CaA4BweLgKrElf+OIGFeoPJPHSsYIWxBiR+T77FA
	jNSS2LytiRXClpfYvOYtM0irhIC6xKO/uhAXGEl0LDzMBFEiIrHvBcTJEgJfWCSOTDsL9Zip
	RPOJ14wTGEVmIVkxC8mKWUhWzEIyawEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4ATx
	THoH46oGi0OMAhyMSjy8P3T5goVYE8uKK3MPMUpwMCuJ8B5yAQrxpiRWVqUW5ccXleakFh9i
	TAYGwERmKdHkfGDyyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGRoc8nfUl/2y/sr2OOMBfUSFWu/O4bm9bxa6QEodjp85vWp16qX59nkGj5eIkWdN53P5t
	9ssqvwieatg9b8/PU65vQnr3i+/SuuzYrjjvrLtEq5dbqMG2/gh1Q9GsxIV//Yr+XHFZt799
	6yU3z/uG+txH50pcfZxzX29bS1lBqm7WsuOcrEFNSizFGYmGWsxFxYkAemW2L1QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/picoxcell-rng.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
index c03beee..eab5448 100644
--- a/drivers/char/hw_random/picoxcell-rng.c
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -108,7 +108,7 @@ static int picoxcell_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng_base))
 		return PTR_ERR(rng_base);
 
-	rng_clk = clk_get(&pdev->dev, NULL);
+	rng_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rng_clk)) {
 		dev_warn(&pdev->dev, "no clk\n");
 		return PTR_ERR(rng_clk);
@@ -117,7 +117,7 @@ static int picoxcell_trng_probe(struct platform_device *pdev)
 	ret = clk_enable(rng_clk);
 	if (ret) {
 		dev_warn(&pdev->dev, "unable to enable clk\n");
-		goto err_enable;
+		return ret;
 	}
 
 	picoxcell_trng_start();
@@ -132,9 +132,6 @@ static int picoxcell_trng_probe(struct platform_device *pdev)
 
 err_register:
 	clk_disable(rng_clk);
-err_enable:
-	clk_put(rng_clk);
-
 	return ret;
 }
 
@@ -142,7 +139,6 @@ static int picoxcell_trng_remove(struct platform_device *pdev)
 {
 	hwrng_unregister(&picoxcell_trng);
 	clk_disable(rng_clk);
-	clk_put(rng_clk);
 
 	return 0;
 }
-- 
1.7.10.4


