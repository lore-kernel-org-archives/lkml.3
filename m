Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3IXJXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:23:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30271 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IXJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:23:07 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-40-524159e32aac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 2/8] backlight: ili922x: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:22:43 +0900
Message-id: <006301ceb907$9fb59430$df20bc90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAAAW9A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ93HkY5BBo/W6FvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlHdx1k
	KdjHUfHpwlOWBsZ29i5GTg4JAROJQy+nM0PYYhIX7q1nA7GFBJYxStxekAFTc7BjCmsXIxdQ
	fDqjRF/3V1aIol+MEj0/nEFsNgE1iS9fDgMN5eAQEdCXaGvRAAkzC+RI3H8yix2i3FZi9cyr
	YDangJ3E+6lnWEBsYQF3iY3LZoLZLAKqEiu3bWYEsXmB6je/OQhlC0r8mHyPBWKmlsTmbU2s
	ELa8xOY1b5lB1koIqEs8+qsLEhYRMJJYuWsRVLmIxL4X7xghXjnFLvHrVynEKgGJb5MPsUC0
	ykpsOgANBUmJgytusExglJiFZPEsJItnIVk8C8mGBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1
	kvNzNzFC4rF/B+PdA9aHGJOB1k9klhJNzgfGc15JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE0y7DfH6So5Opute6gRq1yypzjzudu9i3v+XOpc
	unUVb1XUp4lXNjpslRIUan4udZi5rn1KoWDQhccrDZUExcXnFZ4p/Vrt+XpzirH24m+T3tcz
	PL6n4p7+b7Labs3phRuKxWd+mCXmOntRouGh6xonc7frK/3X4DjlanPmUs7+b9NONGumOimx
	FGckGmoxFxUnAgBrfxCR3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd3HkY5BBm0/tC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMo7sOshTs46j4dOEpSwNjO3sXIyeHhICJxMGOKawQtpjEhXvr
	2boYuTiEBKYzSvR1fwVLCAn8YpTo+eEMYrMJqEl8+XIYqJmDQ0RAX6KtRQMkzCyQI3H/ySx2
	iHJbidUzr4LZnAJ2Eu+nnmEBsYUF3CU2LpsJZrMIqEqs3LaZEcTmBarf/OYglC0o8WPyPRaI
	mVoSm7c1sULY8hKb17xlBlkrIaAu8eivLkhYRMBIYuWuRVDlIhL7XrxjnMAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj/pnUDsaVDRaHGAU4GJV4eHd4
	OwQJsSaWFVfmHmKU4GBWEuG9YesYJMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wGSUVxJv
	aGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MHv3n7T46rLNtWunR
	Y+Qv/rNZXszl59O2zA8svCtDz5z2EJm4OfHAozqJ995tj6v3V3VFuJ1iWGd6Weaa1dMalmPp
	Z3ZYzVwiZXRZlCv97sGUPXcv3+S4zLlS6tvyP5bGcdx3Su5W//ZteFPbt9ylx3Gal7vfzmmX
	ZnNdX5H92zFnycEbvcGflFiKMxINtZiLihMB1HMtGTwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili922x.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index d9f65c2..73464e4 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -513,8 +513,8 @@ static int ili922x_probe(struct spi_device *spi)
 
 	ili->power = FB_BLANK_POWERDOWN;
 
-	lcd = lcd_device_register("ili922xlcd", &spi->dev, ili,
-				  &ili922x_ops);
+	lcd = devm_lcd_device_register(&spi->dev, "ili922xlcd", &spi->dev, ili,
+					&ili922x_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(&spi->dev, "cannot register LCD\n");
 		return PTR_ERR(lcd);
@@ -530,10 +530,7 @@ static int ili922x_probe(struct spi_device *spi)
 
 static int ili922x_remove(struct spi_device *spi)
 {
-	struct ili922x *ili = spi_get_drvdata(spi);
-
 	ili922x_poweroff(spi);
-	lcd_device_unregister(ili->ld);
 	return 0;
 }
 
-- 
1.7.10.4


