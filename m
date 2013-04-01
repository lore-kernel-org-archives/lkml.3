Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3DAJnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:43:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19722 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab3DAJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:43:09 -0400
X-AuditID: cbfee68d-b7f786d000005188-cd-515956ac1872
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 03/27] rtc: rtc-bfin: use devm_*() functions
Date: Mon, 01 Apr 2013 18:43:08 +0900
Message-id: <000e01ce2ebd$50eae0f0$f2c0a2d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAABktQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY901YZGBBjeeSVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsXdhK1NBn0DFrlUODYy9vF2MHBwSAiYSM0+UdjFyApliEhfurWfrYuTiEBJYxijx
	71APO0zN2Q3+EPFFjBK31/5mgXB+MUpc3LOWCaSbTUBN4suXw2ANIgL6Em0tGiA1zAK9jBJn
	enezg9QICdhK/Dj7nRnE5hSwk3izcB4jiC0sYCOxcOV0MJtFQFXi1eznbCA2L1D9nI0boWxB
	iR+T77GA2MwCWhLrdx5ngrDlJTavecsMcai6xKO/uiBhEQEjiY+NJ1khSkQk9r14xwhyj4TA
	PXaJvZ8h7mEREJD4NvkQC0SvrMSmA8yQgJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJEp7dzDePmB9iDEZaP1EZinR5HxglOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTE6mPtr5sefd7dI
	nDv7ZcONOXbzV8zTTAxRbjf6t6nk0v1PH8SuVtysf5L5Z8tzjd5yv7gntXdDfny2/V97VprJ
	LaKNaZZwadQ0TYkV01NO3Od+ccRUQl2j6o7gmyhHFiU+Cd9XQZfLW+VOrgrgbD3uUzFx4nK2
	P1dXz0pd4FJ4p9Hsq763/wIlluKMREMt5qLiRAC3rAQX6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd01YZGBBofniFksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLF3YStTQZ9Axa5VDg2MvbxdjBwcEgImEmc3
	+HcxcgKZYhIX7q1n62Lk4hASWMQocXvtbxYI5xejxMU9a5lAqtgE1CS+fDnMDtIsIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3Ej7PfmUFsTgE7iTcL5zGC2MICNhILV04Hs1kEVCVezX7OBmLz
	AtXP2bgRyhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQR6tLPPqrCxIWETCS+Nh4khWiRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwEngm
	vYNxVYPFIUYBDkYlHt6ICxGBQqyJZcWVuYcYJTiYlUR4fb4BhXhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmKDySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFRb+KMrgsWiw5kJmQUGB9kyiy8JtWWHci/MbArZ5H52qNvzD79WRrBceH+PRcu919zfzO9
	OhL0/09ywvdjz1K2mt/bGG+SUqjcu2Vjv7bawsalt0yZsyqO8b1d7bam6qNHpM1V6cd7rSVZ
	W3eINK77NseFRe6xzJruJzH7DVO/rjMxeCrD0u6pxFKckWioxVxUnAgAJsuW30YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-bfin.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 4ec614b..d8b06f5 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -352,14 +352,14 @@ static int bfin_rtc_probe(struct platform_device *pdev)
 	dev_dbg_stamp(dev);
 
 	/* Allocate memory for our RTC struct */
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
 	platform_set_drvdata(pdev, rtc);
 	device_init_wakeup(dev, 1);
 
 	/* Register our RTC with the RTC framework */
-	rtc->rtc_dev = rtc_device_register(pdev->name, dev, &bfin_rtc_ops,
+	rtc->rtc_dev = devm_rtc_device_register(dev, pdev->name, &bfin_rtc_ops,
 						THIS_MODULE);
 	if (unlikely(IS_ERR(rtc->rtc_dev))) {
 		ret = PTR_ERR(rtc->rtc_dev);
@@ -367,9 +367,10 @@ static int bfin_rtc_probe(struct platform_device *pdev)
 	}
 
 	/* Grab the IRQ and init the hardware */
-	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, 0, pdev->name, dev);
+	ret = devm_request_irq(dev, IRQ_RTC, bfin_rtc_interrupt, 0,
+				pdev->name, dev);
 	if (unlikely(ret))
-		goto err_reg;
+		goto err;
 	/* sometimes the bootloader touched things, but the write complete was not
 	 * enabled, so let's just do a quick timeout here since the IRQ will not fire ...
 	 */
@@ -381,23 +382,16 @@ static int bfin_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_reg:
-	rtc_device_unregister(rtc->rtc_dev);
 err:
-	kfree(rtc);
 	return ret;
 }
 
 static int bfin_rtc_remove(struct platform_device *pdev)
 {
-	struct bfin_rtc *rtc = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
 
 	bfin_rtc_reset(dev, 0);
-	free_irq(IRQ_RTC, dev);
-	rtc_device_unregister(rtc->rtc_dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(rtc);
 
 	return 0;
 }
-- 
1.7.2.5


