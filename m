Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3EBFti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:49:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53721 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3EBFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:49:36 -0400
X-AuditID: cbfee68f-b7f066d000003683-26-5181fe67d6d3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/7] watchdog: at32ap700x_wdt: use devm_*() functions
Date: Thu, 02 May 2013 14:49:27 +0900
Message-id: <000101ce46f8$cedbd430$6c937c90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+JziU8WvvE6PSae9gPVIytE5nA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zA930f42BBh1/jSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bWmSvZChr4Kt6eXMfewLiBu4uRk0NCwETi7coudghbTOLCvfVsXYxcHEIC
	yxglrv1ewApTdOHcPyaIxHRGid5ls8ESQgK/GCW2XZAAsdkE1CS+fDkMNImDQ0RAX6KtRQOk
	nllgE6PE3939YPXCAj4S69tWMIHYLAKqEm2bf4DZvAKWEifXv2aFsAUlfky+xwJiMwtoSazf
	eZwJwpaX2LzmLTPEQQoSO86+ZgSxRQT0JG5ebmaFqBGR2PfiHSNEzTl2if5dgRC7BCS+TT7E
	AnKbhICsxKYDUGMkJQ6uuMEygVFsFpLNs5BsnoVk8ywkGxYwsqxiFE0tSC4oTkovMtYrTswt
	Ls1L10vOz93ECInA/h2Mdw9YH2JMBlo/kVlKNDkfGMF5JfGGxmZGFqYmpsZG5pZmpAkrifOq
	tVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA8nD7/31JtgZhPCfuP6D/UvlRk6CI18YwU
	j/crA46gpgfLRGye/mXc3CVWIW/L82WuywaZmtOlLyecDf/OlTY39otinWTsjzesZwPl5ng/
	0Lf58MFW3tzWk/He0tijd1ewFyluDN8mvi5pVqiKzPcV7J6S3w4+2nj6xIzQbS0/k/X5wrzd
	SsqVWIozEg21mIuKEwEV7wKN1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd30f42BBm/f6FnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZW2euZCto4Kt4e3IdewPjBu4uRk4O
	CQETiQvn/jFB2GISF+6tZ+ti5OIQEpjOKNG7bDYrSEJI4BejxLYLEiA2m4CaxJcvh9m7GDk4
	RAT0JdpaNEDqmQU2MUr83d0PVi8s4COxvm0F2FAWAVWJts0/wGxeAUuJk+tfs0LYghI/Jt9j
	AbGZBbQk1u88zgRhy0tsXvOWGeIgBYkdZ18zgtgiAnoSNy83s0LUiEjse/GOcQKjwCwko2Yh
	GTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO8GdSOxhXNlgcYhTgYFTi
	4f2g2xgoxJpYVlyZe4hRgoNZSYR3wWugEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDk09e
	SbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAmv3PYqNG4vr60
	ftqi5P3q74vOe23e7nZaufonq6xl0mpehk07mB5eeXl539c9fX0X2Ar9Z7yq1k8R/bXdaemF
	c5/+rRZTvxC227NPT26VsnrTTyblDUl1GxpKl5XOOvt/Quq9jTl2nsfPKiW5zt4gs1F+JkP5
	kh/aMbK/2qcIH7O7trb4bP8EJZbijERDLeai4kQAlGZAxTQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
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


