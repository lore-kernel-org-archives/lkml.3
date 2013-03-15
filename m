Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3COJPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:15:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53636 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:15:50 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-d8-5142e6c5bdbb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
In-reply-to: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Subject: [PATCH 5/6] gpio: mc33880: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:15:49 +0900
Message-id: <006601ce215d$af1f6af0$0d5e40d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2AAADXDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY92jz5wCDWbsMbN4dWYjm8XlhZdY
	Lab8Wc5kcXnXHDYHFo871/awefRtWcXo8fOljsfnTXIBLFFcNimpOZllqUX6dglcGR/n/mAp
	mMRZcepHegPjFvYuRk4OCQETibmPD7FA2GISF+6tZ+ti5OIQEljGKPFu6hugBAdY0YKH5hDx
	6YwSG+evY4JwfjFKzD31nBGkm01ATeLLl8NgU0UE9CRuXOgAizMLFEk875rFCmILCdhKHLn+
	CWwbp4CdxLN1fWBxYQEziZeXZjCD2CwCqhL/XkwEq+EFqu9YfwTKFpT4MfkeC8RMLYn1O48z
	QdjyEpvXvGWGOFRd4tFfXYgTjCQ23djGClEiIrHvxTtGiCdPsUv8fx4IsUpA4tvkQ1A/ykps
	OsAMUSIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+
	7iZGSDz272C8e8D6EGMy0PqJzFKiyfnAeM4riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Pdo6ibCpMk7vwozcm/eC7267Vwpq1NAbnhrH6xq7hC
	tiWX1va+XTl1+5IOkd7fklZSfpwWa0OOL2XYOMlQsDPsVNOexNJLLkGZuZJHTAw2fdks8vFh
	+ZudertMvI/8CBfoLu7Y+mP/3PuTeRZM39n8YnfhYa5JW7NnpH3c6/Aixj5QKCop4okSS3FG
	oqEWc1FxIgA9lTLj3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd2jz5wCDbbMMrJ4dWYjm8XlhZdY
	Lab8Wc5kcXnXHDYHFo871/awefRtWcXo8fOljsfnTXIBLFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBkf5/5gKZjEWXHqR3oD4xb2LkYODgkBE4kFD827GDmBTDGJC/fW
	s3UxcnEICUxnlNg4fx0ThPOLUWLuqeeMIFVsAmoSX74cZgexRQT0JG5c6ACLMwsUSTzvmsUK
	YgsJ2Eocuf6JBcTmFLCTeLauDywuLGAm8fLSDGYQm0VAVeLfi4lgNbxA9R3rj0DZghI/Jt9j
	gZipJbF+53EmCFteYvOat8wQR6tLPPqrC3GCkcSmG9tYIUpEJPa9eMc4gVFoFpJJs5BMmoVk
	0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf7M+kdjKsaLA4xCnAwKvHwOjx0
	DBRiTSwrrsw9xCjBwawkwvvxolOgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDU1FeSbyh
	sYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCu3DXbIGPzNtkOy0mO
	DLG9D02+vTgUttvzzvH7JT78GdJNCV8r5t97vGvdRZcep1d/T5k8uNVYFf/oetKrvoeRf0/c
	3n3tuWtPU+SLsnN+P09N+iM00aQnU3zxv723gmynL9vueWPr/2tXbH9sFliz5H/hvxNWvfti
	vTprpWUiTPe1HuZPe82+SImlOCPRUIu5qDgRAEfoSMc7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-mc33880.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mc33880.c b/drivers/gpio/gpio-mc33880.c
index 6a8fdc2..b161489 100644
--- a/drivers/gpio/gpio-mc33880.c
+++ b/drivers/gpio/gpio-mc33880.c
@@ -101,7 +101,7 @@ static int mc33880_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	mc = kzalloc(sizeof(struct mc33880), GFP_KERNEL);
+	mc = devm_kzalloc(&spi->dev, sizeof(struct mc33880), GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
 
@@ -143,7 +143,6 @@ static int mc33880_probe(struct spi_device *spi)
 exit_destroy:
 	dev_set_drvdata(&spi->dev, NULL);
 	mutex_destroy(&mc->lock);
-	kfree(mc);
 	return ret;
 }
 
@@ -159,10 +158,9 @@ static int mc33880_remove(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, NULL);
 
 	ret = gpiochip_remove(&mc->chip);
-	if (!ret) {
+	if (!ret)
 		mutex_destroy(&mc->lock);
-		kfree(mc);
-	} else
+	else
 		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
 			ret);
 
-- 
1.7.2.5


