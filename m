Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab3EWKnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:43:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54277 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3EWKnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:43:45 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-c0-519df2e03a0e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] watchdog: cpwd: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:43:43 +0900
Message-id: <003401ce57a2$658fbb80$30af3280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Xol5MPcv9O9HOS+iEihh1rpoqPA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ90Hn+YGGmzokrKYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBkN1z+xFOxir/i37DhrA2MLWxcjJ4eEgIlEz/NlLBC2mMSFe+uB4lwcQgLL
	GCVaz1+CK1o79SorRGI6o8SGB2+gnF+MEtPXL2QFqWITUJP48uUwexcjB4eIgL5EW4sGSA2z
	wCZGib+7+8FqhAVcJS609jCB2CwCqhKPVr1kBLF5BSwllszaAGULSvyYfA/sJGYBLYn1O48z
	QdjyEpvXvGWGuEhBYsfZ14wQu/QkPky0higRkdj34h0jyF4JgWPsEvu/fWWH2CUg8W3yIRaQ
	egkBWYlNB6DGSEocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRESgxN2MN47YH2IMRlo/URmKdHkfGAM55XEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUXvOqpl6c97+28h09dzJjhdHLPpsMi+E1ZzQ
	+nE/OTTmyqrnbj/kT5lq2FV3BOhNPRGgx3QyM3GnVM/RKVaJoeGV8a6MlWI16p0ZO1MtZq3/
	sOXR//PRfO93vQ87XbLs3Mzv/nfEj4gsjNaIXi950914/4xbWYm8nE4bfQ5JBbP3ZaWmJtqs
	VGIpzkg01GIuKk4EADythfXXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd0Hn+YGGryeLGYxZ/0aNovLCy+x
	WlzeNYfN4sa6fewWTxaeYbK4NeMFqwObx7XNYh4nZvxm8dj5vYHdo2/LKkaPz5vkAlijGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuUFIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmNFz/xFKwi73i37LjrA2MLWxdjJwc
	EgImEmunXmWFsMUkLtxbDxTn4hASmM4oseHBG1YI5xejxPT1C8Gq2ATUJL58OczexcjBISKg
	L9HWogFSwyywiVHi7+5+sBphAVeJC609TCA2i4CqxKNVLxlBbF4BS4klszZA2YISPybfYwGx
	mQW0JNbvPM4EYctLbF7zlhniIgWJHWdfM0Ls0pP4MNEaokREYt+Ld4wTGAVmIZk0C8mkWUgm
	zULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIQ/k97BuKrB4hCjAAejEg+vxO05
	gUKsiWXFlbmHGCU4mJVEeDf3zA0U4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5Hxg8skriTc0
	NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkavbNfLe74aflALrbwR
	cIP7pNpcZh/nAM8E492CngU1WXvaV5l1774X/fLAYdGYWK/fonvnJKT9bltj1KS1IPxIAeMP
	7tAXxlVfmFdXfeNR1fzrZ27vnb1x7sSJz75/unYjb1OD0hYb7z0Rkbyyn96wiMo+FJZ5e8bA
	K/FOe9sR51NM3zuLBJVYijMSDbWYi4oTASQKZlE0AwAA
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
 drivers/watchdog/cpwd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 7038758..213225e 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -621,7 +621,7 @@ static int cpwd_probe(struct platform_device *op)
 			WD_BADMODEL);
 	}
 
-	dev_set_drvdata(&op->dev, p);
+	platform_set_drvdata(op, p);
 	cpwd_device = p;
 	err = 0;
 
@@ -642,7 +642,7 @@ out_free:
 
 static int cpwd_remove(struct platform_device *op)
 {
-	struct cpwd *p = dev_get_drvdata(&op->dev);
+	struct cpwd *p = platform_get_drvdata(op);
 	int i;
 
 	for (i = 0; i < WD_NUMDEVS; i++) {
-- 
1.7.10.4


