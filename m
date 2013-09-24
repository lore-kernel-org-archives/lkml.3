Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3IXJ0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:26:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30952 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3IXJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:26:35 -0400
X-AuditID: cbfee68e-b7f756d000004512-7e-52415ac7cfc4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 8/8] backlight: tdo24m: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:26:30 +0900
Message-id: <006901ceb908$27331860$75994920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAAH1cg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI93jUY5BBq2PxCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyZf+6w
	FPRyVTx5Mo+1gXElRxcjJ4eEgInE0QWnWSFsMYkL99azgdhCAssYJXZtlISp2XNsDlANF1B8
	OqPEjK8XGSGcX4wSB892MYNUsQmoSXz5cpi9i5GDQ0RAX6KtRQMkzCyQI3H/ySx2iKG2Eqtn
	XgWzOQXsJN5PPcMCYgsLuElsWrmDEcRmEVCVuNS+EuwgXqD6hiUtTBC2oMSPyfdYIGZqSWze
	1sQKYctLbF7zlhlkrYSAusSjv7ogYREBI4mGBc2MECUiEvtevAM7WULgErvEvic3mSF2CUh8
	m3yIBaJXVmLTAWaIfyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0itO
	zC0uzUvXS87P3cQIicm+HYw3D1gfYkwGWj+RWUo0OR8Y03kl8YbGZkYWpiamxkbmlmakCSuJ
	86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJT6tPaoZYP4o0vNHKblhWHqf4Mbrp66
	kvYi7e9bVl2taa1r1dfu2VpQ/fnFu4oQxwaHK9MtT1sYxt5RiepTUZmRmuUgJvuG6+ZVZ9uT
	+/fKfF32aprLx2dnRStX+9/+/vb3lKDf9kdPCHg6H3lt2P1pneCyPP2TK4XO1E/pmvad2+HQ
	gqLuq3uUWIozEg21mIuKEwHDghCp3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd3jUY5BBpd+CFnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZM//cYSno5ap48mQeawPjSo4uRk4OCQETiT3H5rBC2GISF+6t
	Z+ti5OIQEpjOKDHj60VGCOcXo8TBs13MIFVsAmoSX74cZu9i5OAQEdCXaGvRAAkzC+RI3H8y
	ix3EFhKwlVg98yqYzSlgJ/F+6hkWEFtYwE1i08odjCA2i4CqxKX2lWCLeYHqG5a0MEHYghI/
	Jt9jgZipJbF5WxMrhC0vsXnNW2aQtRIC6hKP/uqChEUEjCQaFjQzQpSISOx78Y5xAqPQLCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI75Z1I7GFc2WBxiFOBg
	VOLh3eHtECTEmlhWXJl7iFGCg1lJhPeGrWOQEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucD
	01FeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAeuPZxXnfx
	2qptl1+te9kgE2h65jXHXdmOw5WH24KldoScWnz6etuVx6sklnw4JfE0equv4smp4llz6iXM
	PW/1x9b0zCh/ni6w9cGe0Adq1tMelzx+82Kx4wnPD+rbJd6frV3PLC2xadmmQnnWjov+jPxd
	+k+6PaaJX4h4brrk2CalZ9t4VI/EKLEUZyQaajEXFScCAEep8EY9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tdo24m.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 2ccfa46..908016f 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -385,21 +385,17 @@ static int tdo24m_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	lcd->lcd_dev = lcd_device_register("tdo24m", &spi->dev,
-					lcd, &tdo24m_ops);
+	lcd->lcd_dev = devm_lcd_device_register(&spi->dev, "tdo24m", &spi->dev,
+						lcd, &tdo24m_ops);
 	if (IS_ERR(lcd->lcd_dev))
 		return PTR_ERR(lcd->lcd_dev);
 
 	spi_set_drvdata(spi, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
 	if (err)
-		goto out_unregister;
+		return err;
 
 	return 0;
-
-out_unregister:
-	lcd_device_unregister(lcd->lcd_dev);
-	return err;
 }
 
 static int tdo24m_remove(struct spi_device *spi)
@@ -407,8 +403,6 @@ static int tdo24m_remove(struct spi_device *spi)
 	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(lcd->lcd_dev);
-
 	return 0;
 }
 
-- 
1.7.10.4


