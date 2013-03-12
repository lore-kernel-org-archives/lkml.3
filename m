Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3CLFun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:50:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30461 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CLFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:50:42 -0400
X-AuditID: cbfee68d-b7f786d000005188-48-513ec22bf28f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 05/14] backlight: adp8860: convert adp8860 to dev_pm_ops
Date: Tue, 12 Mar 2013 14:50:35 +0900
Message-id: <004201ce1ee5$84512ea0$8cf38be0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAADB9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zQ13tQ3aBBrvOGlvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmPHn1k
	KjjKV7G3oY25gbGZp4uRk0NCwETi+eJP7BC2mMSFe+vZuhi5OIQEljFKtK/Zyw5TdH3CN2aI
	xHRGif3nmpggnF+MEvemNDODVLEJqEl8+XIYqIODQ0RAX6KtRQMkzCxQKrH1wXsWEFtIwFbi
	7vrnjCAlnAJ2Elv+ZoGEhQU8JI5PmM0MEmYRUJX4ttIWJMwLVL34/nomCFtQ4sfkeywQE7Uk
	1u88zgRhy0tsXvMWrFVCQF3i0V9dkLCIgJHE/DOToEpEJPa9eMcIcrCEwDl2iWlzH4G9xSIg
	IPFt8iEWiF5ZiU0HmCG+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQ
	rzgxt7g0L10vOT93EyMkInt3MN4+YH2IMRlo/URmKdHkfGBE55XEGxqbGVmYmpgaG5lbmpEm
	rCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUWDVdvMMle5bd4T287tOfxTEuf5P
	4AnjrdwhOjL8kz7zRW15uknQ0UmuO1LLSbhoiYKuTPrVldMUVD/eKmgyuOE613iap5Il34/H
	whacOqx7FB8J8s8/V8yv5VA1femCmT4Mf1aLfDV851G/zJL7eczmog5vPdcY8a58T7v9y96r
	FBm06j5RYinOSDTUYi4qTgQAG+NKJd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV3tQ3aBBitP6VvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZjx59ZCo4ylext6GNuYGxmaeLkZNDQsBE4vqEb8wQtpjEhXvr
	2boYuTiEBKYzSuw/18QE4fxilLg3pRmsik1ATeLLl8PsXYwcHCIC+hJtLRogYWaBUomtD96z
	gNhCArYSd9c/ZwQp4RSwk9jyNwskLCzgIXF8wmxmkDCLgKrEt5W2IGFeoOrF99czQdiCEj8m
	32OBmKglsX7ncSYIW15i85q3YK0SAuoSj/7qgoRFBIwk5p+ZBFUiIrHvxTvGCYxCs5BMmoVk
	0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjen0ntYFzZYHGIUYCDUYmH
	V/GbbaAQa2JZcWXuIUYJDmYlEd6MzXaBQrwpiZVVqUX58UWlOanFhxiTgf6cyCwlmpwPTEV5
	JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDIPe/Wn6q+Wsn5
	mt0ROUltgpv+rorgaJ4Q/fzOLJeKiR4yj7uqtb9f/1FkO1lU6utX1aMndgvfn3nHVrLC37CT
	n+VIybPLNTEbPvnp3/ex38sT9+klv0rb2hM/xCfOyUg+HtlhfsIjTStlkvgtV6nQFIeTXHsy
	v3k2ri4QeeZxwtBNyunbvnwlluKMREMt5qLiRAD1f7fUOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8860_bl.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index a77c9ca..6bb7f36 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -773,25 +773,29 @@ static int adp8860_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int adp8860_i2c_suspend(struct i2c_client *client, pm_message_t message)
+#ifdef CONFIG_PM_SLEEP
+static int adp8860_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8860_clr_bits(client, ADP8860_MDCR, NSTBY);
 
 	return 0;
 }
 
-static int adp8860_i2c_resume(struct i2c_client *client)
+static int adp8860_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8860_set_bits(client, ADP8860_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
-#else
-#define adp8860_i2c_suspend NULL
-#define adp8860_i2c_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp8860_i2c_pm_ops, adp8860_i2c_suspend,
+			adp8860_i2c_resume);
+
 static const struct i2c_device_id adp8860_id[] = {
 	{ "adp8860", adp8860 },
 	{ "adp8861", adp8861 },
@@ -802,12 +806,11 @@ MODULE_DEVICE_TABLE(i2c, adp8860_id);
 
 static struct i2c_driver adp8860_driver = {
 	.driver = {
-		.name = KBUILD_MODNAME,
+		.name	= KBUILD_MODNAME,
+		.pm	= &adp8860_i2c_pm_ops,
 	},
 	.probe    = adp8860_probe,
 	.remove   = adp8860_remove,
-	.suspend = adp8860_i2c_suspend,
-	.resume  = adp8860_i2c_resume,
 	.id_table = adp8860_id,
 };
 
-- 
1.7.2.5


