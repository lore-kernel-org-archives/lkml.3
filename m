Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3CFHz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:55:58 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47075 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3CFHzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:55:53 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-c9-5136f6870cb2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 25/30] rtc: rtc-tps6586x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:55:50 +0900
Message-id: <009301ce1a40$0566b7d0$10342770$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAS2xw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA92Ob2aBBpvFLZZcvMpuMWf9GjaL
	ywsvsVpc3jWHzWJ/ZwejA6vHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+SC2CN4rJJSc3JLEst
	0rdL4MpYs3UdY8Etzopj3esYGxg7OLoYOTkkBEwkHp1ayQJhi0lcuLeerYuRi0NIYBmjRNPR
	rSwwRSf2dLNAJKYzStzc0gTl/GKUOH76HjtIFZuAmsSXL4eBbA4OEQF9ibYWDZAaZoFeRokz
	vbvB4kICthI983hAyjkF7CSmTHwM1ios4C3xfGIzE4jNIqAqsfDKLbDFvCDlDxewQ9iCEj8m
	3wOLMwtoSazfeZwJwpaX2LzmLTPIeAkBdYlHf3VBwiICRhKzbv9khigRkdj34h0jyDkSAvfY
	JZoa90PtEpD4NvkQC0SvrMSmA8wQ/0pKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQ
	XFCclF5kpFecmFtcmpeul5yfu4kREqd9OxhvHrA+xJgMtH4is5Rocj4wzvNK4g2NjU3MTExN
	zC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTE/6iiTBzuvo8X15F4p
	72hVuaLFz8NuB+xqfbn9JGvvp/U3Qxbdf+usb7jUzZ2xo2izWt88Z0tTTafVhmvd1T52vHhU
	tc2H14LvfkFmduDvi+83zNfrKVA66cX5bvv+I9feLeeU8xSc/01XU/hWxy4BcRGZxEWZKjKJ
	ue8scxbVr4yQOyD1SImlOCPRUIu5qDgRAG7a00LpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd32b2aBBoevWVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFm6zrGglucFce61zE2MHZwdDFyckgImEic
	2NPNAmGLSVy4t56ti5GLQ0hgOqPEzS1NLBDOL0aJ46fvsYNUsQmoSXz5chjI5uAQEdCXaGvR
	AKlhFuhllDjTuxssLiRgK9EzjweknFPATmLKxMdgrcIC3hLPJzYzgdgsAqoSC6/cAlvMC1L+
	cAE7hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMoOMlxBQl3j0VxckLCJgJDHr9k9miBIRiX0v
	3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWngmdQO
	xpUNFocYBTgYlXh4LZTMAoVYE8uKK3MPMUpwMCuJ8HKdAQrxpiRWVqUW5ccXleakFh9iTAZ6
	dCKzlGhyPjBF5ZXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkG
	xsOOp69Hl4hZ/l55rff7TD8t/0VcEe8z2IyWi7+ddOAh/1Px3zcq1OrcK9Y6nJq3LnTWgyVf
	ljueZC2889nrjEmpse3aJV6GGye/V/l5itW/XqI65OWkbZ8/Saw9p/9tO6v94dnJMzWMmr/z
	XK1av22C1r4PIRIKOwTdTe8eMF3bv124sozPu0qJpTgj0VCLuag4EQDEzb4ARwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-tps6586x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index aab4e8c..b6aab9f 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -274,7 +274,7 @@ static int tps6586x_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtc = rtc_device_register(dev_name(&pdev->dev), &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, dev_name(&pdev->dev),
 				       &tps6586x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -306,12 +306,10 @@ fail_rtc_register:
 
 static int tps6586x_rtc_remove(struct platform_device *pdev)
 {
-	struct tps6586x_rtc *rtc = platform_get_drvdata(pdev);
 	struct device *tps_dev = to_tps6586x_dev(&pdev->dev);
 
 	tps6586x_update(tps_dev, RTC_CTRL, 0,
 		RTC_ENABLE | OSC_SRC_SEL | PRE_BYPASS | CL_SEL_MASK);
-	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


