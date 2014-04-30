Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaD3J2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:28:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51874 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaD3J2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:28:48 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-3b-5360c24e6ef3
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 1/5 v3] iio: exynos_adc: use indio_dev->dev structure to handle
 child nodes
Date: Wed, 30 Apr 2014 14:56:51 +0530
Message-id: <1398850015-17761-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSpet3KCHY4Oo7PYu7zw8zWrw8pGlx
	dtlBNovmxevZLF4d+cFksWTyfFaLeUfesVhc3jWHzWLG+X1MFou2/We2WD/jNYsDt8fshoss
	Hjtn3WX32D93DbvHkjeHWD36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY8u9SWwFP/grDsxv
	YGtgPMbbxcjJISFgInGr7xsLhC0mceHeerYuRi4OIYGljBJvO1vZuxg5wIqu7A8BqRESmM4o
	cW2HNkRNP5PEpL27GUESbAJmEgcXrQarFxGQlZjZrQdSwywwkUni/PITrCA1wgKxEh9WzGAD
	sVkEVCUuNz1jB7F5BVwltn54AbVLQWLOJBuQMKeAm0Tz0YUsEHtdJZrOHmYCmSkhcIxd4vT0
	WywQcwQkvk0+xALRKyux6QAzxC+SEgdX3GCZwCi8gJFhFaNoakFyQXFSepGpXnFibnFpXrpe
	cn7uJkZgTJz+92ziDsb7B6wPMSYDjZvILCWanA+MqbySeENjMyMLUxNTYyNzSzPShJXEedMf
	JQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBR82HP/xK/3lny+rReSghlz7rp4BIgcK+IQ
	Vq9TWPjwRdzDR59W1UYFi73cEZB0RDPs2kcPvnfXOjYrF8jVsDzor2RZ1sQ1ie36682XVyXU
	fEpdbu6ySmt3itqSt5NLdZgPb7EVnHcm44XAXslsC5ZPz9W1ZM8IX8vmtDfkWKDy+8ZW+2a1
	EiWW4oxEQy3mouJEAJ6F/TefAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV2/QwnBBi//KVvcfX6Y0eLlIU2L
	s8sOslk0L17PZvHqyA8miyWT57NazDvyjsXi8q45bBYzzu9jsli07T+zxfoZr1kcuD1mN1xk
	8dg56y67x/65a9g9lrw5xOrRt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QPcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwlrGDO23JvEVvCDv+LA/Aa2BsZjvF2MHBwSAiYSV/aHdDFyApliEhfurWcDsYUE
	pjNKXNuh3cXIBWT3M0lM2rubESTBJmAmcXDRanaQXhEBWYmZ3XogNcwCE5kkzi8/wQpSIywQ
	K/FhxQywQSwCqhKXm56xg9i8Aq4SWz+8YIfYqyAxZ5INSJhTwE2i+ehCFoi9rhJNZw8zTWDk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOOKeSe1gXNlgcYhRgINRiYdXYGt8sBBr
	YllxZe4hRgkOZiUR3oyOhGAh3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgcmg7ySeENjE3NT
	Y1NLEwsTM0vShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYKyyXPe2acJD5bNlGy80Vkiu
	zjysIqVz7IPi55IVVWuSojZbFS0POxCmupH/wdLZrdt5WPQsFZZMaPkw3ShwYc79hf8MluRN
	T/tz71eXmeOp1fPWacXUfWW9t/jpWtULNdEXFvSVJU5aW7Nm5sK0b+8dLhmmKdS0TF76dv+R
	2a8XM2+Punu2+8N1JZbijERDLeai4kQAi275T/wCAAA=
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
Reported-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---
Changes since v2:
None
Changes since v1:
Adding Doug's tags
v0:
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

