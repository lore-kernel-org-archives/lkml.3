Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3IXJYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:24:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23783 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3IXJYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:24:38 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-5e-52415a4f1976
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 5/8] backlight: lms501kf03: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:24:31 +0900
Message-id: <006601ceb907$e0013c10$a003b430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAAEnvQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY13/KMcgg8c/DC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowPrxey
	F/xmr+idYNzAeJmti5GTQ0LAROLctMksELaYxIV764HiXBxCAssYJab07Icrurp+KVRiOqNE
	/5XXTBDOL0aJHxengbWzCahJfPlymL2LkYNDREBfoq1FAyTMLJAjcf/JLHYQW0jAVmL1zKtg
	NqeAncT7qWfAWoUFvCQWzF7OCmKzCKhK7Lx6ACzOC1T/5GETO4QtKPFj8j0WiJlaEpu3NbFC
	2PISm9e8ZQZZKyGgLvHory5IWETASKLh+Dc2iBIRiX0v3jGCnCwhcI5dYsXRxWwQuwQkvk0+
	xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YW
	l+al6yXn525ihMTkhB2M9w5YH2JMBlo/kVlKNDkfGNN5JfGGxmZGFqYmpsZG5pZmpAkrifOq
	t1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDUz/jXMlNjdvV+9UnBp7QCjrYGv/r70NxS
	RvHRteXT/i3jSTtyW2irQPeU3K18hTUbtB9t8/I+M90muDHF+te7/av7hYN4Q7fs516isSf6
	95MHbXH/nmULn3u63uFpj199QaGnwn+rg3+rLq1M2bH9aaKqiug11ukVv3XffZuTzeHneWeB
	dUCREktxRqKhFnNRcSIADMlrsd8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV3/KMcggzfr9SzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMD68Xshf8Zq/onWDcwHiZrYuRk0NCwETi6vqlULaYxIV764Fs
	Lg4hgemMEv1XXjNBOL8YJX5cnMYCUsUmoCbx5cth9i5GDg4RAX2JthYNkDCzQI7E/Sez2EFs
	IQFbidUzr4LZnAJ2Eu+nngFrFRbwklgwezkriM0ioCqx8+oBsDgvUP2Th03sELagxI/J91gg
	ZmpJbN7WxAphy0tsXvOWGWSthIC6xKO/uiBhEQEjiYbj39ggSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/wz6R2MqxosDjEKcDAq8fBe
	SHAIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJKK8k
	3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGGV9//lqTeu2Mb97
	87r9txuTir/Frl7omrk9ptj9yqIajQ3l0wyy5+YJPWTYc+5Q8P6YZdpmlhmb3/IdUbl4I8Dj
	jozHk4yPk8rOr089r3Sjzabg4yYvUea9+8PY7x6274vQq3nrw8kg8nfTQbFWWf1JX9PeSHx2
	2LAk5peB0uPHEt+Wei5PFFdiKc5INNRiLipOBAAt5WkmPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms501kf03.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index ff46e19..77258b7 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -350,8 +350,8 @@ static int lms501kf03_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	ld = lcd_device_register("lms501kf03", &spi->dev, lcd,
-				&lms501kf03_lcd_ops);
+	ld = devm_lcd_device_register(&spi->dev, "lms501kf03", &spi->dev, lcd,
+					&lms501kf03_lcd_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -382,8 +382,6 @@ static int lms501kf03_remove(struct spi_device *spi)
 	struct lms501kf03 *lcd = spi_get_drvdata(spi);
 
 	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(lcd->ld);
-
 	return 0;
 }
 
-- 
1.7.10.4


