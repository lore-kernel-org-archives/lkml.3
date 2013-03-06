Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3CFFg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:36:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50109 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3CFFgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:36:53 -0500
X-AuditID: cbfee68d-b7f636d0000009be-a1-5136d5f43c03
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 29/30] rtc: rtc-vt8500: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:36:51 +0900
Message-id: <005f01ce1a2c$9af00ef0$d0d02cd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAVTMw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI90vV80CDZrvaFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0XT/EXPBSu6KD3ufMDcwLufsYuTkkBAwkei/O4MNwhaTuHBvPZDNxSEksIxR4uHP
	9cwwRa++fQYrEhKYzijRdUIJougXo8SCNRvAitgE1CS+fDnM3sXIwSEioC/R1qIBUsMs0Mso
	caZ3NztEs63E1e5VYPWcAnYSyx/PYgGxhQXcJDpPnwRbwCKgKnHj13cmEJsXqL5jyUR2CFtQ
	4sfke2D1zAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcTGjZdYIUpEJPa9eMcIco+E
	wD12iVcr5zBD7BKQ+Db5EAtEr6zEpgNQ/0pKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUo
	mlqQXFCclF5kqFecmFtcmpeul5yfu4kREqm9OxhvH7A+xJgMtH4is5Rocj4w0vNK4g2NjU3M
	TExNzC1NzU1JE1YS55W7JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXHLci7PueYbLcJc
	jC05HIM2hTWkdin8PX+a5fXHWp+y/3e/eDK+/rwixdvGL5Gt5PZXrfCVkn7+O17dPSh+ckmS
	4ca1fGuYHlSyzDX6GiLRvNt/zs1lS7oPJ8zZv1qmrCDdcc2Nnxf0GU1Pu4X2yJnUB5yO7yvd
	8tw2Ue/7M7uJOk+mPz184KQSS3FGoqEWc1FxIgARBu216gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0vV80CDdY/ULNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaPp/iPmgpXcFR/2PmFuYFzO2cXIySEhYCLx
	6ttnNghbTOLCvfVgtpDAdEaJrhNKXYxcQPYvRokFazYwgyTYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzc7RLOtxNXuVWD1nAJ2Essfz2IBsYUF3CQ6T58EW8AioCpx49d3JhCbF6i+
	Y8lEdghbUOLH5Htg9cwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHExo2XWCFKRCT2
	vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSngWfS
	OxhXNVgcYhTgYFTi4Z2gYhYoxJpYVlyZe4hRgoNZSYSX6wxQiDclsbIqtSg/vqg0J7X4EGMy
	0KMTmaVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBK
	NTA61LnwbpokIRjyO/jY3xsKac3nWjo8Zs1oue249y6H5Z/7r4szGtkNFNfGXJiyYbroO8a0
	qWatpptMnlm+fJx2rMP12BGb5We4Nd9rGZidmqKZYbcvKvOc7jLFSbpHQy/pLc6SvifWyMUZ
	sXihuOeXZS1rrnLdrtg2ZbKD1bOn0r56gUJi4bxKLMUZiYZazEXFiQDoQO+yRwMAAA==
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
 drivers/rtc/rtc-vt8500.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index a000bc0..92fbb00 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -252,7 +252,7 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	writel(VT8500_RTC_CR_ENABLE,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
-	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
+	vt8500_rtc->rtc = devm_rtc_device_register("vt8500-rtc", &pdev->dev,
 					      &vt8500_rtc_ops, THIS_MODULE);
 	if (IS_ERR(vt8500_rtc->rtc)) {
 		ret = PTR_ERR(vt8500_rtc->rtc);
@@ -266,13 +266,11 @@ static int vt8500_rtc_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
-		goto err_unreg;
+		goto err_return;
 	}
 
 	return 0;
 
-err_unreg:
-	rtc_device_unregister(vt8500_rtc->rtc);
 err_return:
 	return ret;
 }
@@ -281,8 +279,6 @@ static int vt8500_rtc_remove(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(vt8500_rtc->rtc);
-
 	/* Disable alarm matching */
 	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
 
-- 
1.7.2.5


