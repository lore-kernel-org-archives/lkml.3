Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaDYKRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:17:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23950 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaDYKQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:46 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-14-535a360c2752
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org
Subject: [PATCH 5/5] iio: exynos_adc: do a reinit_completion before the
 conversion
Date: Fri, 25 Apr 2014 15:44:47 +0530
Message-id: <1398420888-5506-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSq8tjFhVscPKMkcXLQ5oWZ5cdZLNo
	XryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mB06P2Q0XWTx2zrrL7rF/7hp2
	jyVvDrF69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bRK9tZCt6zVvx4NIO1gfEvSxcjJ4eE
	gInExKaVULaYxIV769m6GLk4hASWMkqcer2bEabo3e1JUInpjBKvv01lgXD6mSRWN3xlA6li
	EzCTOLhoNXsXIweHiICsxMxuPZAaZoELjBI/v0xgBYkLC4RI7HiUBVLOIqAqcX/TQ1YQm1fA
	RWLSwUlMICUSAgoScybZgIQ5BVwl1u8+BlYiBFRyf8sfVpCREgLb2CVab/5jhpgjIPFt8iEW
	iF5ZiU0HmCFulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAiPg9L9n
	fTsYbx6wPsSYDDRuIrOUaHI+MILySuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAOj4b63NtGzu2LDUi57bT939UDL75BLzG1bBF2YhfcpR+/6UROU
	pcLPMHPrce8rumbumpximkq6FXv3sbb+PLOWry55+YId5dvfr/tVo33QfnV6pLbCQ7t46674
	42IOU24LWRS3qbIvOur+OMKuNFX8Ta/w5rfh/rF2L35qh6kUrXhUMz2D+Z4SS3FGoqEWc1Fx
	IgC8ZMPrlgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQV0es6hgg8mvtS1eHtK0OLvsIJtF
	8+L1bBavjvxgslgyeT6rxbwj71gsLu+aw2Yx4/w+JotF2/4zO3B6zG64yOKxc9Zddo/9c9ew
	eyx5c4jVo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	HL2ynaXgPWvFj0czWBsY/7J0MXJySAiYSLy7PYkNwhaTuHBvPZDNxSEkMJ1R4vW3qSwQTj+T
	xOqGr2BVbAJmEgcXrWbvYuTgEBGQlZjZrQdSwyxwgVHi55cJrCBxYYEQiR2PskDKWQRUJe5v
	esgKYvMKuEhMOjiJCaREQkBBYs4kG5Awp4CrxPrdx8BKhIBK7m/5wzqBkXcBI8MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOD4eia9g3FVg8UhRgEORiUe3gmykcFCrIllxZW5hxglOJiV
	RHhlTaKChXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGPt5JfGGxibmpsamliYWJmaWpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDoLPrRZvK6rc99G5br3IhY+s/v2qJ/Ji9SrE6w
	M37iWGjSMHv++ZU7LBlXap4JSI/nitfo6nrY3Kfes7rQ0/dBccXNnMaG+8sz7QUfTCqed9uH
	d/769zU7n1k6ibI5G9e9uhf85Pmted5pv+8VzU+7prl3wq3YzPmmncfbWE3do2o73rxT7Vyr
	xFKckWioxVxUnAgA9NKzMfMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reinit_completion() before the wait_for_completion_timeout in
raw_read() call.

Change-Id: I70fa00841bc49eba838a5bd6779015844297dfdb
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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

