Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3EWKoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:44:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38708 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab3EWKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:44:10 -0400
X-AuditID: cbfee68e-b7f276d000002279-4b-519df2f919e1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/5] watchdog: da9052: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:44:09 +0900
Message-id: <003501ce57a2$749344d0$5db9ce70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XonPdRC2jZ0uKQ7OgKuig6p3Kzg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA92fn+YGGmxbIm0xZ/0aNovLCy+x
	WlzeNYfN4sa6fewWTxaeYbK4NeMFqwObx7XNYh4nZvxm8dj5vYHdo2/LKkaPz5vkAlijuGxS
	UnMyy1KL9O0SuDJmvL7NVHCEo+LAwt/sDYwL2LsYOTkkBEwkprT9Z4OwxSQu3FsPZHNxCAks
	Y5RYPf0EG0zRy3PbGSES0xklpt16ww7h/GKUeLNzKgtIFZuAmsSXL4eBEhwcIgL6Em0tGiA1
	zAIbGCVO/v8Ltk5YwF1i8uOFTCA2i4CqxO+GXmYQm1fAUuLF74dQtqDEj8n3wGYyC2hJrN95
	nAnClpfYvOYtM8RFChI7zr5mBLFFBPQk+hbdZ4aoEZHY9+Id2KUSAufYJVauvcICsUxA4tvk
	Qywgx0kIyEpsOgA1R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CIjveLE
	3OLSvHS95PzcTYyQKOzbwXjzgPUhxmSg9ROZpUST84FRnFcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxlm6Zf2WW1evk9jbMFHryneOT4t/yEzM
	vTzhbvzNZMeH9svq7vbv25RwqjTqmUhuxU8pZbmIG3eipqslzutavj571vrnRon6giFbeFbc
	FG/9e9pDsybdU+mddduyGLEVH2617/BhYau7v+SS8Xk2rq8Jh5dKrzq/6V/jgZhlt9z0TI/L
	zvSeE6TEUpyRaKjFXFScCABrIvZy2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd2fn+YGGtxZK24xZ/0aNovLCy+x
	WlzeNYfN4sa6fewWTxaeYbK4NeMFqwObx7XNYh4nZvxm8dj5vYHdo2/LKkaPz5vkAlijGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuUFIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmzHh9m6ngCEfFgYW/2RsYF7B3MXJy
	SAiYSLw8t50RwhaTuHBvPVsXIxeHkMB0Rolpt96wQzi/GCXe7JzKAlLFJqAm8eXLYaAEB4eI
	gL5EW4sGSA2zwAZGiZP//4JNFRZwl5j8eCETiM0ioCrxu6GXGcTmFbCUePH7IZQtKPFj8j2w
	mcwCWhLrdx5ngrDlJTavecsMcZGCxI6zr8GuExHQk+hbdJ8ZokZEYt+Ld4wTGAVmIRk1C8mo
	WUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIw/k97BuKrB4hCjAAejEg+v
	xO05gUKsiWXFlbmHGCU4mJVEeDf3zA0U4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5Hxg+skr
	iTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbWzxXN8f3bfIyU
	47ceP+IbEdnpWPNTTWrb5wOa/crJ143/a0ab2LAvXPB5zeZPeiuj9M/dF5oS5nXoTchP4TyN
	B3mLWt85zfbctOn8vMsWric3H67QTjvNsz9p4Uy1xAuepVOCJzalJ/tM6rUqXtuyZaW4Ysre
	dWHBO6zL38xdX68RcGz1v6lKLMUZiYZazEXFiQB/0N1KNQMAAA==
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
 drivers/watchdog/da9052_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index 3674450..f09c54e 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -215,14 +215,14 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	dev_set_drvdata(&pdev->dev, driver_data);
+	platform_set_drvdata(pdev, driver_data);
 err:
 	return ret;
 }
 
 static int da9052_wdt_remove(struct platform_device *pdev)
 {
-	struct da9052_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+	struct da9052_wdt_data *driver_data = platform_get_drvdata(pdev);
 
 	watchdog_unregister_device(&driver_data->wdt);
 	kref_put(&driver_data->kref, da9052_wdt_release_resources);
-- 
1.7.10.4


