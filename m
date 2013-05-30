Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab3E3BjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:39:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43819 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab3E3Biw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:38:52 -0400
X-AuditID: cbfee68f-b7f436d000000f81-9e-51a6ada60eb8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] rtc: rtc-mpc5121: use platform_{get,set}_drvdata()
Date: Thu, 30 May 2013 10:38:45 +0900
Message-id: <002201ce5cd6$6cd46a60$467d3f20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5c1mQfwiqEdSiURqixsvdx5ITquA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ91la5cFGkx6wWax5OJVdos569ew
	WVxeeInV4vKuOWwW+zs7GB1YPfZMPMnmcWLGbxaPvi2rGD2mz/vJ5PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxuaWRtaCN5wVc5vXMDUwLuHoYuTkkBAwkXi/ZgoThC0mceHeerYuRi4OIYFljBL7
	194ESnCAFR1dFAoRX8QosfJEEzuE84tR4s+0bhaQbjYBNYkvXw6zgzSICOhLtLVogNQwC3Qz
	SjxqnssMUiMs4CYx89wmdhCbRUBV4lXvXDYQm1fAUuJow0EWCFtQ4sfke2A2s4CWxPqdx5kg
	bHmJzWveMkNcqiCx4+xrRhBbREBP4viLK1D1IhL7XrxjBFksIXCMXeL8zBOsEMsEJL5NPsQC
	8Y2sxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L
	10vOz93ECIm9/h2Mdw9YH2JMBlo/kVlKNDkfGLt5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgH
	CgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBsME9bxrW9d++duR1Op7at5u786eRjsUpJvS3t
	RK7i7SMx/KvX//6Qk180+Yik2v1+7riiozN+33XapOFoOCW3e+fHJWHM2XMkwufsn3z93KEN
	z64HdO+QaHKd9uAJs3BdUPGesrV1G3VszhbvEvgeEpH19sv0DYxnutkqDGZdn7FsZ2LInGx+
	JZbijERDLeai4kQADPyR1dMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd1la5cFGlydwWyx5OJVdos569ew
	WVxeeInV4vKuOWwW+zs7GB1YPfZMPMnmcWLGbxaPvi2rGD2mz/vJ5PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bmlkbWgjecFXOb1zA1MC7h6GLk4JAQMJE4
	uii0i5ETyBSTuHBvPVsXIxeHkMAiRomVJ5rYIZxfjBJ/pnWzgFSxCahJfPlymB2kWURAX6Kt
	RQOkhlmgm1HiUfNcZpAaYQE3iZnnNrGD2CwCqhKveueygdi8ApYSRxsOskDYghI/Jt8Ds5kF
	tCTW7zzOBGHLS2xe85YZ4iIFiR1nXzOC2CICehLHX1yBqheR2PfiHeMERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNnPpHYwrmywOMQowMGoxMO7QWtZ
	oBBrYllxZe4hRgkOZiUR3jXaQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OByadvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgDDkW+jCkNZ4vcqtKWd2l
	Sz0n2FPl2MuUlPQVthYeFe2Z67hBaM8S/uc/ixK1HnIv/WPIf27fiv67K4XlE4odbZ5ma/1R
	9MkreiOo1RI/5dC/tralnJflDb/us+Z+HCwuNCdrR4Hxkoz/5aZ2sStuecT/drSf18nO+369
	/Mm8/poHCWZTZjoosRRnJBpqMRcVJwIA6lJ7RTADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- fixed conflicts with rtc-rtc-mpc5121-use-devm_-functions.patch

 drivers/rtc/rtc-mpc5121.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 4c02497..9c8f609 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -324,7 +324,7 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 
 	device_init_wakeup(&op->dev, 1);
 
-	dev_set_drvdata(&op->dev, rtc);
+	platform_set_drvdata(op, rtc);
 
 	rtc->irq = irq_of_parse_and_map(op->dev.of_node, 1);
 	err = request_irq(rtc->irq, mpc5121_rtc_handler, 0,
@@ -382,7 +382,7 @@ out_dispose:
 
 static int mpc5121_rtc_remove(struct platform_device *op)
 {
-	struct mpc5121_rtc_data *rtc = dev_get_drvdata(&op->dev);
+	struct mpc5121_rtc_data *rtc = platform_get_drvdata(op);
 	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
 
 	/* disable interrupt, so there are no nasty surprises */
-- 
1.7.10.4


