Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3D3E7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:59:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24808 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3D3E7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:59:50 -0400
X-AuditID: cbfee690-b7f136d000000fea-d9-517f4fc4cba3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 1/7] watchdog: at32ap700x_wdt: use devm_*() functions
Date: Tue, 30 Apr 2013 13:59:48 +0900
Message-id: <000d01ce455f$8a789110$9f69b330$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX4giBksd3S8/Rs2s+6yoclSgdA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ92j/vWBBn+kLOasX8NmcXnhJVaL
	y7vmsFncWLeP3eLJwjNMFrdmvGB1YPO4tlnM48SM3yweO783sHv0bVnF6PF5k1wAaxSXTUpq
	TmZZapG+XQJXxtnpy9kKjvFVPHvM2sD4iruLkZNDQsBE4tnW7cwQtpjEhXvr2UBsIYFljBIn
	V5nB1Fxa+Ieli5ELKD6dUWLK/k2MEEW/GCVu7OUFsdkE1CS+fDnM3sXIwSEioC/R1qIBUs8s
	sIlR4u/uflaQGmEBD4k5n46A2SwCqhLfJ39mB7F5BSwlOs/3QdmCEj8m32MBsZkFtCTW7zzO
	BGHLS2xe8xbqUAWJHWdfg90gIqAncWbXL0aIGhGJfS/eMYIslhA4xw7kXGeDWCYg8W3yIRaQ
	4yQEZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGJXnFibnFp
	Xrpecn7uJkZI9E3YwXjvgPUhxmSg9ROZpUST84HRm1cSb2hsZmRhamJqbGRuaUaasJI4r3qL
	daCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxszSVVUBAZ6Kpm9NvU46xZUvMr394Omt+psf
	LrJ01B8tUdE//DZiot2zfbu1WEovJ10PSFmZo6Qh+cLJKtD54oGMUv3lx3iyFjcfl/T6dm7J
	5AnP1aOY5DyCeoPWLfn2tFQ+Svdv0t0e/hP98x4suTzda/rspXszBTtyJ72/P/G8JGdNmceK
	v0osxRmJhlrMRcWJAEKF+dPUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd0j/vWBBtfnWlrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZZ6cvZys4xlfx7DFrA+Mr7i5GTg4J
	AROJSwv/sEDYYhIX7q1n62Lk4hASmM4oMWX/JkaQhJDAL0aJG3t5QWw2ATWJL18Os3cxcnCI
	COhLtLVogNQzC2xilPi7u58VpEZYwENizqcjYDaLgKrE98mf2UFsXgFLic7zfVC2oMSPyffA
	FjMLaEms33mcCcKWl9i85i0zxEEKEjvOvga7QURAT+LMrl+MEDUiEvtevGOcwCgwC8moWUhG
	zUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP7mdQOxpUNFocYBTgYlXh4
	dyypCxRiTSwrrsw9xCjBwawkwhvtWB8oxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA1JNX
	Em9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyMa9oN2x5WVWRe
	U+x5d79vd8Y89p6SV/d3ZK1lz/M8s3Jenu2lHg7ZuXKV3xo6tlxyqu/g2pi+uCTB67Zl6JK1
	CiU1KQcyH1X2qIb93bLJVMRl/69Sl+5zW8PuLfn7I/X01rshZ2PzNSavqxbnizmRPINn+X/p
	f7fr/r+zKhILP2O1xcxU6bASS3FGoqEWc1FxIgClIws5MwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/watchdog/at32ap700x_wdt.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 7a715e3..c4cb552 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -321,13 +321,14 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
+			GFP_KERNEL);
 	if (!wdt) {
 		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
 		return -ENOMEM;
 	}
 
-	wdt->regs = ioremap(regs->start, resource_size(regs));
+	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!wdt->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
@@ -342,7 +343,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "CPU must be reset with external "
 				"reset or POR due to silicon errata.\n");
 		ret = -EIO;
-		goto err_iounmap;
+		goto err_free;
 	} else {
 		wdt->users = 0;
 	}
@@ -375,10 +376,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 err_register:
 	platform_set_drvdata(pdev, NULL);
-err_iounmap:
-	iounmap(wdt->regs);
 err_free:
-	kfree(wdt);
 	wdt = NULL;
 	return ret;
 }
@@ -391,8 +389,6 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 			at32_wdt_stop();
 
 		misc_deregister(&wdt->miscdev);
-		iounmap(wdt->regs);
-		kfree(wdt);
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
 	}
-- 
1.7.2.5


