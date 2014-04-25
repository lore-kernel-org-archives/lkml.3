Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaDYKSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:18:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28122 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaDYKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:41 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-00-535a3608b5d1
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org
Subject: [PATCH 3/5] iio: exynos_adc: reduce timeout and use
 wait_for_completion_timeout
Date: Fri, 25 Apr 2014 15:44:45 +0530
Message-id: <1398420888-5506-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSq8thFhVs0DSD1+LlIU2Ls8sOslk0
	L17PZvHqyA8miyWT57NazDvyjsXi8q45bBYzzu9jsli07T+zA6fH7IaLLB47Z91l99g/dw27
	x5I3h1g9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2P2lvOsBTP4K5r37mRuYNzD08XIySEh
	YCLxcOFFNghbTOLCvfVANheHkMBSRonTTy8wdzFygBX17C6HiE9nlFiw5AALhNPPJLH870Ym
	kG42ATOJg4tWs4M0iAjISszs1gOpYRa4wCjx88sEVpAaYYEoiclLvzCB1LAIqErsmywCEuYV
	cJGY8uIdK8QuBYk5k2xAwpwCrhLrdx8D6xQCKrm/5Q8ryEgJgW3sEhefdIOtZREQkPg2+RAL
	RK+sxKYDzBC/SEocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgeF/+t+z
	CTsY7x2wPsSYDDRuIrOUaHI+MH7ySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoGxsX3K4kNPQs/W8S0MffdFWbsyNHrFm8jFogIezF0Mn5acPRqa
	E3GjT43LubdY/uPkxsPBW6Z7am9KFn3Wadr2wUpO889uEaOTcx7u3rDLOeZiLZPVzux7Tq1x
	lk/9f1+45Lh1+W11S3FPrmcvjh3sOspTcu6YqsnZ9qe966JZ3XP+/TAvlZBQYinOSDTUYi4q
	TgQA2LCJupUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQV0Os6hgg8YDLBYvD2lanF12kM2i
	efF6NotXR34wWSyZPJ/VYt6RdywWl3fNYbOYcX4fk8Wibf+ZHTg9ZjdcZPHYOesuu8f+uWvY
	PZa8OcTq0bdlFaPH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	Zm85z1owg7+iee9O5gbGPTxdjBwcEgImEj27y7sYOYFMMYkL99azdTFycQgJTGeUWLDkAAuE
	088ksfzvRiaQKjYBM4mDi1azgzSLCMhKzOzWA6lhFrjAKPHzywRWkBphgSiJyUu/MIHUsAio
	SuybLAIS5hVwkZjy4h0rxF4FiTmTbEDCnAKuEut3HwPrFAIqub/lD+sERt4FjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYKj65nUDsaVDRaHGAU4GJV4eD+oRQYLsSaWFVfmHmKU4GBW
	EuGVNYkKFuJNSaysSi3Kjy8qzUktPsSYDHTTRGYp0eR8YOTnlcQbGpuYmxqbWppYmJhZkias
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPj0dAe3jpejcDHN/ctPrkhvfysxtx0C2ah+b7Z
	1x3PLvrLlf7FZ/+tJez73QTW1jn9f7LoyKWWWXJFt8PyU83v/E3cEaOznklQ3sk40vzlr9dW
	89N6dAyqSmyztqUvN3Kf0SWgFDFj3fLQmdenKLtXRdZMepopeVI+zXzGcrU9EXole46zdvMr
	sRRnJBpqMRcVJwIAKvk3fPICAAA=
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

Also, handle the return values in exynos_raw_read() call.

Change-Id: Icb8cade162094b2777c9f3c77120635deef5947c
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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

