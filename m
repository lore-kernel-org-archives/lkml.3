Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaD3JaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:30:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817AbaD3J2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:28:51 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-37-5360c2520dab
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: [PATCH 3/5 v3] iio: exynos_adc: reduce timeout and use
 wait_for_completion_timeout
Date: Wed, 30 Apr 2014 14:56:53 +0530
Message-id: <1398850015-17761-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSqxt0KCHY4PVpDouXhzQtzi47yGbR
	vHg9m8WrIz+YLJZMns9qMe/IOxaLy7vmsFnMOL+PyWLRtv/MFutnvGZx4PKY3XCRxWPnrLvs
	HvvnrmH3WPLmEKtH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZRx/0c9cMIG/Ytf/G+wNjOt5
	uhg5OSQETCTO3ZvGBGGLSVy4t56ti5GLQ0hgKaPEzlPv2GGKGveuBbOFBKYzSmy8Uwth9zNJ
	fPidBWKzCZhJHFy0GqiGg0NEQFZiZrceyBxmgSeMEj+2vGYGqREWiJWYd3oz2DIWAVWJhk3X
	2EBsXgFXib23/7GA9EoIKEjMmWQDEuYUcJNoPrqQBWKVq0TT2cNQd+5il3j0MgJijIDEt8mH
	oFplJTYdYIYokZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAuPg9L9n
	E3Yw3jtgfYgxGWjcRGYp0eR8YBzllcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAPjnMlO/xnunKzNO164Qab7XvqxT8saHivba5SyFXPeZO9sXCuf
	lpJ/pXOC54ndW5aIdB49b9HaqvJsvdzc5i33r8aorDpqxrqA532F69+9EUt3bn5WY11Z9bMk
	YG9Z1dGu7z5nvdNnrT1j8yBlxt55jKujJRxc+maHTrzB6nkqZm7TPz9u+2trlFiKMxINtZiL
	ihMBwC1VS5kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd2gQwnBBh8DLV4e0rQ4u+wgm0Xz
	4vVsFq+O/GCyWDJ5PqvFvCPvWCwu75rDZjHj/D4mi0Xb/jNbrJ/xmsWBy2N2w0UWj52z7rJ7
	7J+7ht1jyZtDrB59W1YxenzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMeP4i37mggn8Fbv+32BvYFzP08XIySEhYCLRuHctO4QtJnHh3no2EFtIYDqjxMY7tRB2
	P5PEh99ZIDabgJnEwUWrgeo5OEQEZCVmdut1MXJxMAs8YZT4seU1M0iNsECsxLzTm5lAbBYB
	VYmGTdfAZvIKuErsvf2PBaRXQkBBYs4kG5Awp4CbRPPRhSwQq1wlms4eZprAyLuAkWEVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnCUPZPewbiqweIQowAHoxIPr8DW+GAh1sSy4srcQ4wS
	HMxKIrwZHQnBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPTAB5JfGGxibmpsamliYWJmaW
	pAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAYUa7x8O7XKbvLtd41Pd+/nzesJW3zLy62
	rfHzjry++q7j1YqN/xZud48MfbPYbnngW6XPCYK9Gacem3+49IpxtzKPQWGiTeKxxxuMf5/s
	c2Ta1Bo6NePkom0BNn8Zzxmdqc8tEJhYk/z3gO7iR6Yh//yEbR4ksZ5Rj3X4V1ne61zAzuqf
	W7pPiaU4I9FQi7moOBEAaxaJ6vYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADC module on Exynos5 SoCs runs at 600KSPS. At this conversion rate,
waiting for 1000 msecs is wasteful (incase of h/w failure).

Hence, reduce the time out to 100msecs and use
wait_for_completion_timeout() instead of
wait_for_completion_interruptible_timeout()

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v2:
None
Changes since v1:
None
v0:
This change is a part of the patch reviewd at https://lkml.org/lkml/2013/11/5/92

 drivers/iio/adc/exynos_adc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index ff98c5d..939aaf7 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -82,7 +82,7 @@ enum adc_version {
 #define ADC_CON_EN_START	(1u << 0)
 #define ADC_DATX_MASK		0xFFF
 
-#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(1000))
+#define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
 struct exynos_adc {
 	void __iomem		*regs;
@@ -121,6 +121,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
 	u32 con1, con2;
+	int ret;
 
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
@@ -145,16 +146,19 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				ADC_V1_CON(info->regs));
 	}
 
-	timeout = wait_for_completion_interruptible_timeout
+	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
-	*val = info->value;
+	if (timeout == 0) {
+		ret = -ETIMEDOUT;
+	} else {
+		*val = info->value;
+		*val2 = 0;
+		ret = IIO_VAL_INT;
+	}
 
 	mutex_unlock(&indio_dev->mlock);
 
-	if (timeout == 0)
-		return -ETIMEDOUT;
-
-	return IIO_VAL_INT;
+	return ret;
 }
 
 static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
-- 
1.7.9.5

