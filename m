Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaDYKQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:16:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28099 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaDYKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:38 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-e4-535a36047346
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 1/5] iio: exynos_adc: use indio_dev->dev structure to handle
 child nodes
Date: Fri, 25 Apr 2014 15:44:43 +0530
Message-id: <1398420888-5506-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSpctiFhVs8KdNw+Lu88OMFi8PaVqc
	XXaQzaJ58Xo2i1dHfjBZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduDxmN1xk8dg56y67
	x/65a9g9lrw5xOrRt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGQf7n7IWzOSr+PT/MXsDYxtP
	FyMHh4SAicSBiyFdjJxAppjEhXvr2boYuTiEBJYySvy4+IcZImEisXHmMlaIxHRGiT99U6Cc
	fiaJHe33GUGq2ATMJA4uWs0OMlVEQFZiZrceSA2zwF9GiXkvt4DVCAtESVxf1c8CYrMIqEqs
	ef+DHcTmFXCRmP3nLjvERQoScybZgIQ5BVwl1u8+xgpiCwGV3N/yB2yvhMAhdonTp5+zQ8wR
	kPg2+RALRK+sxKYDUEdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB
	sXD637OJOxjvH7A+xJgMNG4is5Rocj4wlvJK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgTG4/ewB5ev1rfMufAyYlXRWWssv4rF2+zMOy4j/297f
	dkncFKKU4xXpeN4yIDPr19Lr4RO9FSbom6+dW+Fs5nD1zcMvBnYsOh8q9DQiqx7fLjjzw0zU
	+MTeSUsqdYInXuEP3KhVH7Z6Ic/Lr4JvpY6fSH74Y9+yova+ghq3zxodNRN6TS6XcCuxFGck
	GmoxFxUnAgD0VDhJmwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV0Ws6hgg7fn5S3uPj/MaPHykKbF
	2WUH2SyaF69ns3h15AeTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e+yfu4bdY8mbQ6wefVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHjYP9T1oKZfBWf/j9mb2Bs4+li5OSQEDCR2DhzGSuELSZx4d56ti5GLg4hgemMEn/6
	prBCOP1MEjva7zOCVLEJmEkcXLSavYuRg0NEQFZiZrceSA2zwF9GiXkvt4DVCAtESVxf1c8C
	YrMIqEqsef+DHcTmFXCRmP3nLlivhICCxJxJNiBhTgFXifW7j4EdIQRUcn/LH9YJjLwLGBlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH2jPpHYyrGiwOMQpwMCrx8E6QjQwWYk0sK67M
	PcQowcGsJMIraxIVLMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wDSQVxJvaGxibmpsamli
	YWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Msk+21U44OGf3FA+Ja3u8Fq1ynuPS
	pbrTW/qO9MULk040PJVVP/j6VZiY+oX5y1Sez3p7Uabh3NyUBetWrX9mt/vtidSqJVO3ptRz
	z6x6JzSd88fFl0+Sdq71eb3H0Evu8qlj181PCzz9nDTt4JT3i7mnnOw/sMT/WO7C9M0fW068
	3cDAdzsvq8xbiaU4I9FQi7moOBEAqqtjqvkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

Using pdev->dev with device_for_each_child() would iterate over all
of the children of the platform device and delete them.
Thus, causing crashes during module unload.

We should be using the indio_dev->dev structure for
registering/unregistering child nodes.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
This change was tested on top of 
   https://lkml.org/lkml/2014/4/21/481 from Doug.

 drivers/iio/adc/exynos_adc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..affa93f 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -344,7 +344,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	exynos_adc_hw_init(info);
 
-	ret = of_platform_populate(np, exynos_adc_match, NULL, &pdev->dev);
+	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed adding child nodes\n");
 		goto err_of_populate;
@@ -353,7 +353,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_populate:
-	device_for_each_child(&pdev->dev, NULL,
+	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
@@ -369,7 +369,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct exynos_adc *info = iio_priv(indio_dev);
 
-	device_for_each_child(&pdev->dev, NULL,
+	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
-- 
1.7.9.5

