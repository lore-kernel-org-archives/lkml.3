Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaDZLlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:41:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20345 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaDZLjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:45 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-3d-535b9b00fc48
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org
Subject: [PATCH 3/5 v2] iio: exynos_adc: reduce timeout and use
 wait_for_completion_timeout
Date: Sat, 26 Apr 2014 17:07:54 +0530
Message-id: <1398512276-4105-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSq8swOzrY4O49bYuXhzQtzi47yGbR
	vHg9m8WrIz+YLB40rWKyWDJ5PqvFvCPvWCwu75rDZjHj/D4mi0Xb/jM7cHnMbrjI4rFz1l12
	j02rOtk89s9dw+6x5M0hVo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKONn7l6ngJl/FqZ3/
	mBsY23i6GDk5JARMJH5vaGWEsMUkLtxbz9bFyMUhJLCUUWLTzc8sMEUdy+8yQySmM0oc6b7O
	DuH0M0lcOLiOHaSKTcBM4uCi1UA2B4eIgKzEzG49kBpmgUeMEjMe9oKtEBaIlVi1bx4TiM0i
	oCqxY/EasA28Ai4SW+93M4L0SggoSMyZZAMS5hRwlZi46CpYuRBQyduJr8H2SggcY5f48OoR
	I8QcAYlvkw+xQPTKSmw6wAxxtKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKpXnJhbXJqXrpec
	n7uJERgXp/89m7iD8f4B60OMyUDjJjJLiSbnA+MqryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJ
	QUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY/XrzHGtWnRZsnfDzfO7Zz5q6/yqb8x57rLre
	xBeXGf8ywPF9cD+/ysV7cyMDJSM+3+i6yDRP2y44YnmP4JId2zbpzWhaZWsntE628Zm7tt7M
	OcrHriXq1fyd6Je0L37lrIfzC6qdwpMWOcfs3nX7zRsu1g/NP74rLQw/2LHV8pVxDd/KL1Pz
	lFiKMxINtZiLihMB0CvweaECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQV2G2dHBBp/OK1u8PKRpcXbZQTaL
	5sXr2SxeHfnBZPGgaRWTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e2xa1cnmsX/uGnaPJW8OsXr0bVnF6PF5k1wAe1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8
	qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0H1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1D
	guB6jAzQQMIaxoyTvX+ZCm7yVZza+Y+5gbGNp4uRk0NCwESiY/ldZghbTOLCvfVsXYxcHEIC
	0xkljnRfZ4dw+pkkLhxcxw5SxSZgJnFw0Wogm4NDREBWYma3HkgNs8AjRokZD3sZQWqEBWIl
	Vu2bxwRiswioSuxYvIYFxOYVcJHYer+bEaRXQkBBYs4kG5Awp4CrxMRFV8HKhYBK3k58zT6B
	kXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCoeya1g3Flg8UhRgEORiUe3h05UcFC
	rIllxZW5hxglOJiVRHgXpUQHC/GmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MCHklcQbGpuY
	mxqbWppYmJhZkiasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjZs5DmUlz8itPbkvwOVmS
	bfouao9Z/opMq7xJh3/PEU11e3U2j2ETx1611nMeMtkPvn4KvO8m8djKUaqF98pCxT9yvq9T
	covjLZlZq28f+ShtIVtY80/HQHrTz+zeKU81nl1eNcUjpkpXwu43v/m7CkntxmmLTiYsbp2x
	8cH7g1qxt8JMhT8rsRRnJBpqMRcVJwIA0KZb7f4CAAA=
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
This change is a part of the patch reviewd at https://lkml.org/lkml/2013/11/5/92

 drivers/iio/adc/exynos_adc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index a2b8b1a..4d2467a 100644
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

