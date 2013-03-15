Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3COQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:29:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42361 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3COQ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:29:02 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-01-51434c4c1062
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de
Subject: [RFC: PATCH 2/2] iio: adc: exynos_adc: Handle timeout and race
 conditions
Date: Fri, 15 Mar 2013 21:56:41 +0530
Message-id: <1363364801-23684-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkWtfHxznQ4MMhPYuzyw6yWTQvXs9m
	sWTyfFaLeUfesVhc3jWHzWLG+X1MFou2/Wd2YPeY3XCRxWPnrLvsHvvnrmH3WPLmEKvH501y
	AaxRXDYpqTmZZalF+nYJXBl7e26zFvwXqtiy9TB7A+Ny/i5GTg4JAROJnnfbGSFsMYkL99az
	dTFycQgJLGWU2H/uCzNM0cdbp5ghEtOBEl93MkE4PUwSd269ZQKpYhMwkzi4aDV7FyMHh4iA
	rMTMbj2QGmaB5YwSS659YAepERYIkWg6toYFxGYRUJU4eewuWC+vgKvEhe8trCC9EgIKEnMm
	2YD0Sgi0swNdsZYNol5A4tvkQywQNbISmw5AHScpcXDFDZYJjIILGBlWMYqmFiQXFCelFxnr
	FSfmFpfmpesl5+duYgSG7el/z/p3MN49YH2IMRlo3ERmKdHkfGDY55XEGxqbGVmYmpgaG5lb
	mpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0ST4TbGI9wvR8Deeh8Q7Ap1P
	90e9fPH7YtpjCbHf/RUvY9TWV1zmaC1eKFP9SOH5jiz57rsV73axN3fsPpmo/OSnUWPu6ptm
	tU38BQZ8GW5s7+wcfTbZv7si1n7AI//sWtH+LXN1TQQ95BUjInUPd3MveHlsVY6Bd613kL3Q
	6RM3RN/Hnn+oxFKckWioxVxUnAgAE+G0dHECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV0fH+dAgxc7VS3OLjvIZtG8eD2b
	xZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/Zgd1jdsNFFo+ds+6ye+yfu4bdY8mbQ6wenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2Ntzm7Xgv1DFlq2H2RsY
	l/N3MXJySAiYSHy8dYoZwhaTuHBvPVsXIxeHkMB0Ron9X3cyQTg9TBJ3br1lAqliEzCTOLho
	NXsXIweHiICsxMxuPZAaZoHljBJLrn1gB6kRFgiRaDq2hgXEZhFQlTh57C5YL6+Aq8SF7y2s
	IL0SAgoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCqeSe9gXNVgcYhR
	gINRiYdXwcY5UIg1say4MvcQowQHs5II7zt9oBBvSmJlVWpRfnxRaU5q8SHGZKDlE5mlRJPz
	gRGbVxJvaGxibmpsamliYWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mxhtfvf/m
	+VvvWIlh9Rsl8S2hOQcXFhjpK93Q8TOKPxFw3Yvnef6BQK2/gm8l+RvjErfdeLiF6f5tP+a5
	GkW63ra+/1zzVvEm5GjM/yUk+uOeluiE+5vOaMZ9mrsjX9UhrLmvpeu2zdc6K94Liq6yj9cH
	vkmc8nHG6m9J01KVeLJqehb+PvxUiaU4I9FQi7moOBEAVjtpsc4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the following
1. Handle the return values of wait_for_completion_interruptible_timeout
2. Add spin locks to avoid race conditions during ISR.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
Discussion thread for this patch can be found at
http://www.gossamer-threads.com/lists/linux/kernel/1693284?page=last

I've not seen any reference to spin lock usage in IIO.
Kindly, suggest me if there is a better way to avoid the race.

Thanks,
Naveen
 drivers/iio/adc/exynos_adc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index ed6fdd7..4de28ae 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -91,6 +91,7 @@ struct exynos_adc {
 
 	struct completion	completion;
 
+	spinlock_t		reg_lock;
 	u32			value;
 	unsigned int            version;
 };
@@ -117,7 +118,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				long mask)
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
-	unsigned long timeout;
+	long timeout;
 	u32 con1, con2;
 
 	if (mask != IIO_CHAN_INFO_RAW)
@@ -143,15 +144,19 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				ADC_V1_CON(info->regs));
 	}
 
+	INIT_COMPLETION(info->completion);
+
 	timeout = wait_for_completion_interruptible_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
+
 	*val = info->value;
 
 	mutex_unlock(&indio_dev->mlock);
 
 	if (timeout == 0)
 		return -ETIMEDOUT;
-
+	else if (timeout < 0)
+		return timeout;
 	return IIO_VAL_INT;
 }
 
@@ -159,6 +164,8 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 {
 	struct exynos_adc *info = (struct exynos_adc *)dev_id;
 
+	spin_lock(&info->reg_lock);
+
 	/* Read value */
 	info->value = readl(ADC_V1_DATX(info->regs)) &
 						ADC_DATX_MASK;
@@ -170,6 +177,8 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 
 	complete(&info->completion);
 
+	spin_unlock(&info->reg_lock);
+
 	return IRQ_HANDLED;
 }
 
@@ -327,6 +336,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	else
 		indio_dev->num_channels = MAX_ADC_V2_CHANNELS;
 
+	spin_lock_init(&info->reg_lock);
 	ret = iio_device_register(indio_dev);
 	if (ret)
 		goto err_irq;
-- 
1.7.9.5

