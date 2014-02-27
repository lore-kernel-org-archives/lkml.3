Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaB0FAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:00:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:20112 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaB0FAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:00:16 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-19-530ec6595f53
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] hwrng: atmel - Use devm_clk_get()
Date: Thu, 27 Feb 2014 14:00:09 +0900
Message-id: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zeMUulUPjKSZTQeuQ54WfZho3Fg==
Content-language: ko
x-cr-hashedpuzzle: E0Ln FNIT LlOY Ns3B SJ9l TGa5 XsCb ZKUW bP8f cHyd eESL qLSM
 wL2r zGnk 0D2f
 0FRO;5;aABlAHIAYgBlAHIAdABAAGcAbwBuAGQAbwByAC4AYQBwAGEAbgBhAC4AbwByAGcALgBhAHUAOwBqAGEAYwBtAGUAdABAAHMAdQBuAHMAaQB0AGUALgBkAGsAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG4AaQBjAG8AbABhAHMALgBmAGUAcgByAGUAQABhAHQAbQBlAGwALgBjAG8AbQA=;Sosha1_v1;7;{C07C2E4A-7B1C-4D91-8F58-3964F407DB65};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 27 Feb 2014 05:00:01
 GMT;WwBQAEEAVABDAEgAIAAxAC8ANQBdACAAaAB3AHIAbgBnADoAIABhAHQAbQBlAGwAIAAtACAAVQBzAGUAIABkAGUAdgBtAF8AYwBsAGsAXwBnAGUAdAAoACkA
x-cr-puzzleid: {C07C2E4A-7B1C-4D91-8F58-3964F407DB65}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY93IY3zBBnMXaVu8PKRp0f1KxuL0
	pWuMFpcXXmK1uLxrDpvFt8vN7A5sHgt+bWXx2HZA1aNvyypGj2mvz7N5fN4kF8AaxWWTkpqT
	WZZapG+XwJVxbN9dloIPnBUfHjWyNzD2cXQxcnJICJhIfHm+hgXCFpO4cG89WxcjF4eQwDJG
	iRdbf7PBFO3+Np8dIrGIUWLPwgfMEM5vRom37U9YQarYBNQkvnw5zA5iiwjoSfStb2QEKWIW
	mMEoMfXjBGaQhLCAmcTxt8uAxnJwsAioStzb6AsS5hWwlVj06zcrhC0o8WPyPbCTmAW0JDZv
	a2KFsOUlNq95ywzSKiGgLvHory6ICbJqyT5PiAoRiX0v3oFtlRBYwSrx6uYkZogHTCU2T5nJ
	BJF4xC4x/eh7RpAEi4CAxLfJh1ggZspKbDoAVS8pcXDFDZYJjBKzkFw0C8lFs5BcNAvJ7gWM
	LKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQuJ14g7G+wesDzEmA62fyCwlmpwPjPe8knhD
	YzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAUMD8mmRTw
	7PK2e8uaRffXnzorPpeXtf3D7qbTSxsuyepPUIk46sy1Jq/UotTnc0xj0Va1yxsWXGFhXtSr
	GlEhG5RYWneTK8h1btq0e4IPlLew7zF68iOj6pj7xosXgq5rKj7S2DTF7Xy6vtDDTdpfNjs0
	9d6UOfS4XGJ/ZdStrf71kXcPcjUosRRnJBpqMRcVJwIAk3qaO+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd3IY3zBBg8b1S1eHtK06H4lY3H6
	0jVGi8sLL7FaXN41h83i2+Vmdgc2jwW/trJ4bDug6tG3ZRWjx7TX59k8Pm+SC2CNamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
	SCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOLbvLkvBB86KD48a2RsY+zi6GDk5JARM
	JHZ/m88OYYtJXLi3nq2LkYtDSGARo8SehQ+YIZzfjBJv25+wglSxCahJfPlyGKxDREBPom99
	IyNIEbPADEaJqR8nMIMkhAXMJI6/XQY0ioODRUBV4t5GX5Awr4CtxKJfv1khbEGJH5PvsYDY
	zAJaEpu3NbFC2PISm9e8ZQZplRBQl3j0VxfEBFm1ZJ8nRIWIxL4X78C2SgisYJV4dXMSM8QD
	phKbp8xkmsAoNAvJhllINsxCsmEWklkLGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQn
	g2dSOxhXNlgcYhTgYFTi4VVg4wsWYk0sK67MPcQowcGsJMJ7yAUoxJuSWFmVWpQfX1Sak1p8
	iDEZ6P+JzFKiyfnARJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYw9Jzf4q4RbKc/Ydvxd9R/bDSdvqd4T/vZj1gzNG991/W9dCj5bniCrP08jyPsJD/8v
	l3U76llE7dbsygl/8eTUXJGiGevFlM+8TawWnPzy55ZVrif0KrQNA4w+rCvIje69/j+52Uu0
	5vr+BzsuVayRWrvm84vlFpcu5JjNKmlanJvRuIlpDW+WEktxRqKhFnNRcSIAKIc3mUoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/atmel-rng.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index dfeddf2..851bc7e 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -63,13 +63,13 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(trng->base))
 		return PTR_ERR(trng->base);
 
-	trng->clk = clk_get(&pdev->dev, NULL);
+	trng->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(trng->clk))
 		return PTR_ERR(trng->clk);
 
 	ret = clk_enable(trng->clk);
 	if (ret)
-		goto err_enable;
+		return ret;
 
 	writel(TRNG_KEY | 1, trng->base + TRNG_CR);
 	trng->rng.name = pdev->name;
@@ -85,9 +85,6 @@ static int atmel_trng_probe(struct platform_device *pdev)
 
 err_register:
 	clk_disable(trng->clk);
-err_enable:
-	clk_put(trng->clk);
-
 	return ret;
 }
 
@@ -99,7 +96,6 @@ static int atmel_trng_remove(struct platform_device *pdev)
 
 	writel(TRNG_KEY, trng->base + TRNG_CR);
 	clk_disable(trng->clk);
-	clk_put(trng->clk);
 
 	return 0;
 }
-- 
1.7.10.4


