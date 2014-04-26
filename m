Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaDZLjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:39:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaDZLjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:49 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-5b-535b9b045e8d
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org
Subject: [PATCH 5/5 v2] iio: exynos_adc: do a reinit_completion before the
 conversion
Date: Sat, 26 Apr 2014 17:07:56 +0530
Message-id: <1398512276-4105-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrcsyOzrYYMVFLouXhzQtzi47yGbR
	vHg9m8WrIz+YLB40rWKyWDJ5PqvFvCPvWCwu75rDZjHj/D4mi0Xb/jM7cHnMbrjI4rFz1l12
	j02rOtk89s9dw+6x5M0hVo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DK+PfiAGPBW9aKIys+
	MDYw/mTpYuTkkBAwkfh2/AYThC0mceHeerYuRi4OIYGljBIrVj9hhylaeXsOO0RiOqPEylsf
	wBJCAv1MEru22YPYbAJmEgcXrQaKc3CICMhKzOzWA6lnFnjEKDHjYS8jSFxYIFxi51obkHIW
	AVWJxf0TwI7gFXCROPL4BDNIiYSAgsScSWAlnAKuEhMXXWWC2OQi8Xbia7ATJAQOsUsc3bSP
	BWKOgMS3yYdYIHplJTYdYIY4WVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vO
	z93ECIyJ0/+eTdjBeO+A9SHGZKBxE5mlRJPzgTGVVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOk
	ICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M2iKzH7z1sVk3Menxxazq/7OaBYx7BbqSHizn
	+1e158PW1PdiLYZ+758zp6xuP9ofnf13/hONvveqm9L//s27c+KYQe3/xzsOLTTl5go7waL8
	4tzvDJtmg8Nve2T2sHJMNnM6e7Y0qmv1uy6JWI3Ya93l7YrPVV35ivnS5n267lDaa1u+qTBL
	iaU4I9FQi7moOBEA1KV/R58CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV2W2dHBBpOvM1m8PKRpcXbZQTaL
	5sXr2SxeHfnBZPGgaRWTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e2xa1cnmsX/uGnaPJW8OsXr0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxox/Lw4wFrxlrTiy4gNjA+NPli5GTg4JAROJlbfnsEPYYhIX7q1n62Lk4hAS
	mM4osfLWB7CEkEA/k8SubfYgNpuAmcTBRauB4hwcIgKyEjO79UDqmQUeMUrMeNjLCBIXFgiX
	2LnWBqScRUBVYnH/BLBdvAIuEkcen2AGKZEQUJCYMwmshFPAVWLioqtMEJtcJN5OfM0+gZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgiHsmvYNxVYPFIUYBDkYlHt4dOVHBQqyJ
	ZcWVuYcYJTiYlUR4F6VEBwvxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjAZ5JXEGxqbmJsa
	m1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4wqrwovV65brvNsumZUkUW9k
	X7w4viJ2x+Grhln7r9e5TGt6GfLijO7H16bVu97EJn8+bn277obdte+7btkxOHiGbU1kPH9W
	VfjAy08tm90/qrNeWtf72EtGmkFf+dbxLz2ZPCdXP5COsRfmKWoVfP50RutaeUFJ3j1LbH7s
	dU9acyo5P7J4sRJLcUaioRZzUXEiAMJZCfv8AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reinit_completion() before the wait_for_completion_timeout in
raw_read() call.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 drivers/iio/adc/exynos_adc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 805c9f6..32290e6 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -151,6 +151,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 		return -EINVAL;
 
 	mutex_lock(&indio_dev->mlock);
+	reinit_completion(&info->completion);
 
 	/* Select the channel to be used and Trigger conversion */
 	if (info->version == ADC_V2) {
-- 
1.7.9.5

