Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab3EWKo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:44:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54351 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab3EWKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:44:24 -0400
X-AuditID: cbfee68f-b7f436d000000f81-02-519df307dff0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/5] watchdog: da9055: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:44:23 +0900
Message-id: <003601ce57a2$7d2617d0$77724770$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XonxtcmYAEE1oT1uu+pmp3ZqsbQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI132z3MDDWa8MrKYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBk337czFfRwVqzpXsLawHiXvYuRk0NCwETiUe8mRghbTOLCvfVsXYxcHEIC
	yxglNk25xgpT9HTiBxaIxHRGifcLrrBDOL8YJSY+W8cEUsUmoCbx5cthoAQHh4iAvkRbiwZI
	DbPABkaJk///gq0TFnCX2DX7HhuIzSKgKnF1XzvYBl4BS4k9e/ezQNiCEj8m3wOzmQW0JNbv
	PM4EYctLbF7zlhniIgWJHWdfg50tIqAncfzwbjaIGhGJfS/eMYIslhA4xy7x9c56dohlAhLf
	Jh9iATlOQkBWYtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525ihERh/w7GuwesDzEmA62fyCwlmpwPjOK8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAeZvg0PUpz6ua4FT3le955c97pKubu
	f679Tyh+j+Xn2/P3nzv5WPf9ss3qYimlhl++rZgoLFL95PoNaz+HsM9tUU7Hjk7+YL/xjvh1
	4dm6j//tr/vuz5ErEqFgLPBE956T9bvZc2/FbFDv7PzpOuNNRYZEr8PGFYsn18VttO3wE//x
	Q8BL9NJrJZbijERDLeai4kQAtQJbq9gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQV32z3MDDc7M0LeYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzbr5vZyro4axY072EtYHxLnsXIyeH
	hICJxNOJH1ggbDGJC/fWs3UxcnEICUxnlHi/4Ao7hPOLUWLis3VMIFVsAmoSX74cBkpwcIgI
	6Eu0tWiA1DALbGCUOPn/L9hUYQF3iV2z77GB2CwCqhJX97Wzgti8ApYSe/buZ4GwBSV+TL4H
	ZjMLaEms33mcCcKWl9i85i0zxEUKEjvOvmYEsUUE9CSOH97NBlEjIrHvxTvGCYwCs5CMmoVk
	1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjGn0nvYFzVYHGIUYCDUYmH
	V+L2nEAh1sSy4srcQ4wSHMxKIrybe+YGCvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MP3k
	lcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjUok/nFxO8zay
	BZ608Xx5//3ej7vvqLV9kV3rJ1BwbtU0n7jPnZMz5wY8ObFZ8fLh+133HPUbG1MeRfGY/7Er
	UP1lGF6f+eDlvA0namx2rfbw2faSe+eeu/Hqa/7MDeyqvJgRUhd3PyywmfvPi58aBh0Hvr5y
	0K1i63H0dipM7ssTfNzUvmWyEktxRqKhFnNRcSIAUZ/ikDUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/da9055_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
index f5ad105..575f37a 100644
--- a/drivers/watchdog/da9055_wdt.c
+++ b/drivers/watchdog/da9055_wdt.c
@@ -174,7 +174,7 @@ static int da9055_wdt_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 
 	ret = watchdog_register_device(&driver_data->wdt);
 	if (ret != 0)
@@ -187,7 +187,7 @@ err:
 
 static int da9055_wdt_remove(struct platform_device *pdev)
 {
-	struct da9055_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+	struct da9055_wdt_data *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 	kref_put(&driver_data->kref, da9055_wdt_release_resources);
-- 
1.7.10.4


