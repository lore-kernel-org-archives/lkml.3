Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3H3ERK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:17:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63431 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3H3ERI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:17:08 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-1b-52201cc2a16e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Evgeniy Polyakov'" <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] w1: w1-gpio: use dev_get_platdata()
Date: Fri, 30 Aug 2013 13:17:06 +0900
Message-id: <002e01cea537$c9b15730$5d140590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6lN8WeMbrNZ1LKSuiE3q4f6N2buQ==
Content-language: ko
x-cr-hashedpuzzle: BPI/ DwY8 Gckl K221 MOe/ NhfT NmJR OZ6l QPNt RqdJ TUsC Xp7F
 a9YY iWJy jAG8
 rIC9;4;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAegBiAHIAQABpAG8AcgBlAG0AYQBwAC4AbgBlAHQA;Sosha1_v1;7;{444CBE6D-5CA1-4DF1-8155-27E5E362B6B6};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 30 Aug 2013 04:16:59
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMgBdACAAdwAxADoAIAB3ADEALQBnAHAAaQBvADoAIAB1AHMAZQAgAGQAZQB2AF8AZwBlAHQAXwBwAGwAYQB0AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {444CBE6D-5CA1-4DF1-8155-27E5E362B6B6}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA91DMgpBBmv2MFnMWb+GzeLywkus
	Fpd3zWGz+LX6HJsDi8fjHduZPE7M+M3i0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBln/89h
	LJgnVHH+zhq2BsZj/F2MnBwSAiYS9949ZYawxSQu3FvP1sXIxSEksIxRYtntPcwwRZfW3INK
	LGKUaL/Zxgzh/GKUeDBpCiNIFZuAmsSXL4fZuxg5OEQE9CXaWjRAwswCORKHH81iAQkLC1hI
	PDnsCBJmEVCV6Nm0DKyTV8BW4tK1bWwQtqDEj8n3WCBatSTW7zzOBGHLS2xe85YZZIyEgLrE
	o7+6IGERAT2Jx6/WskGUiEjse/GOEeQyCYEnLBLTTt9mhbjfVOLvxudQ9jl2iXUvBCFuEJD4
	NvkQC8RMWYlNB6DelZQ4uOIGywRGiVlILpqF5KJZSC6ahWT1AkaWVYyiqQXJBcVJ6UWmesWJ
	ucWleel6yfm5mxghMTlxB+P9A9aHGJOB1k9klhJNzgfGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFduXNjzaE3XTMWrm1Qduz2nb7WWWD95
	95fN9sGfHt41Fen4yeT75rzGR6UX2//4BZTcm81w6/yGvt9T7p1tYu5OZmqSeulmvoApSlta
	MsvQ70+IzeniQjezZS+Om60Or494XLVhgWrga9EtClOtV04ymMuRdr5RzKROIez6qVUsd7w/
	VU2el6zEUpyRaKjFXFScCABEuwlw3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd2DMgpBBi9vWlvMWb+GzeLywkus
	Fpd3zWGz+LX6HJsDi8fjHduZPE7M+M3i0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZZ//PYSyYJ1Rx/s4atgbGY/xdjJwcEgImEpfW3GODsMUkLtxb
	D2RzcQgJLGKUaL/Zxgzh/GKUeDBpCiNIFZuAmsSXL4fZuxg5OEQE9CXaWjRAwswCORKHH81i
	AQkLC1hIPDnsCBJmEVCV6Nm0DKyTV8BW4tK1bWwQtqDEj8n3WCBatSTW7zzOBGHLS2xe85YZ
	ZIyEgLrEo7+6IGERAT2Jx6/WskGUiEjse/GOEeQyCYEnLBLTTt9mhbjfVOLvxuesExiFZiFZ
	MQvJillIVsxCMmsBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCYfya1g3Flg8UhRgEO
	RiUe3gfB8kFCrIllxZW5hxglOJiVRHjjtwGFeFMSK6tSi/Lji0pzUosPMSYDQ2Ais5Rocj4w
	HeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2N6zO7j+W02
	j5q7V4czNVQvDL4921Y7RFPO108qdN/D7zy9F94v2KVdvGHP39ehj5928fCp2pTzx7+PO1tq
	fEviwe4KhbNGP9wc98rrN30V043aGMLN9aNPtJS7l9fs48k7d8+VZNqbBetnOh1w4k64IXZ8
	uerTjwoZ897Lv913//1v+0XOZkosxRmJhlrMRcWJAHdRJGs9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/w1/masters/w1-gpio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index f54ece2..101a366 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -56,7 +56,7 @@ MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
 
 static int w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
@@ -87,7 +87,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
 		}
 	}
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No configuration data\n");
@@ -157,7 +157,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
 static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -176,7 +176,7 @@ static int w1_gpio_remove(struct platform_device *pdev)
 
 static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -186,7 +186,7 @@ static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 
 static int w1_gpio_resume(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
-- 
1.7.10.4


