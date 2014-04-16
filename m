Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaDPK1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10660 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaDPK1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:11 -0400
X-AuditID: cbfee690-b7f266d00000287c-51-534e5afecdbb
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 8/8] extcon: arizona: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:27:03 +0900
Message-id: <1397644023-32516-9-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkQPdflF+wwcwN7BbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8b1t7sYC84KVPRcfcrawPiO
	t4uRk0NCwERiR+c+ZghbTOLCvfVsXYxcHEICSxklOh88YIEpWtn6CCqxiFFi9rJOFginjUli
	U+cidpAqNgFdiScHLoONEhEIlug4eZwJxGYW8JSYO7kLqJuDQ1jARWLHHx6QMIuAqsT0qS/B
	SngFPCQ+7F0DViIhoCAxZ5INSJgTqHPzq2/MIGEhoJJ7X81AtkoIvGaT2HNmFSPEGAGJb5MP
	sUC0ykpsOgD1i6TEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERikp/89
	m7CD8d4B60OMyUDjJjJLiSbnA4M8ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoY2c8UrxXJ1VDUuHJj14yqPf71fR/0b7/cMWPfoTtN+ze41L0p
	qLy43WOqtfovR/b5LJnrzXIXSkQYNLnd/Xww+Oajd+5emvHvlEUmTdc+8Jx388cbUpeL77tr
	ex+PeLPSwFs2lPOCTtQLu22HvNvy2mJuZS+/ZVSkuEL/9roo6U8vGr+dlDzhp8RSnJFoqMVc
	VJwIAA0zadRoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAd2/UX7BBi/O2Fhc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZ19/uYiw4K1DRc/UpawPjO94uRk4OCQETiZWtj9ggbDGJC/fWA9lcHEICixglZi/r
	ZIFw2pgkNnUuYgepYhPQlXhy4DIziC0iECzRcfI4E4jNLOApMXdyF1A3B4ewgIvEjj88IGEW
	AVWJ6VNfgpXwCnhIfNi7BqxEQkBBYs4kG5AwJ1Dn5lffmEHCQkAl976aTWDkXcDIsIpRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOAaeSe1gXNlgcYhRgINRiYd3Ro5vsBBrYllxZe4hRgkO
	ZiUR3sZIv2Ah3pTEyqrUovz4otKc1OJDjMlAN01klhJNzgfGZ15JvKGxiZmRpZG5oYWRsTlp
	wkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MEYkqG5fPklHtmaXT41jjJzj0W9Vl09yeH3f
	9a40bBnjoimVFUtm/jnQ3rtXaZXfNI4XU3gYphb16wassnpj8Wnn93P9M8+Fhxt4/ZhpeFJC
	SWKhReZsk1bGz/KRB8If8Z5ar2z5yK05/sXEn75dKS6F5zlEPrxb2fu//0yX5MUu/kd72gRL
	apVYijMSDbWYi4oTAajYvVrFAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource-managed extcon device register function (i.e.
devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
is attached with this function, that extcon device is automatically unregistered
on driver detach. That reduces tiresome managing code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-arizona.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..40e6c0b 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
 	if (IS_ERR(info->micvdd)) {
-		ret = PTR_ERR(info->micvdd);
 		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
-		goto err;
+		return PTR_ERR(info->micvdd);
 	}
 
 	mutex_init(&info->lock);
@@ -1155,11 +1153,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info->edev.dev.parent = arizona->dev;
 	info->edev.supported_cable = arizona_cable;
 
-	ret = extcon_dev_register(&info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	info->input = devm_input_allocate_device(&pdev->dev);
@@ -1410,8 +1408,6 @@ err_rise:
 err_input:
 err_register:
 	pm_runtime_disable(&pdev->dev);
-	extcon_dev_unregister(&info->edev);
-err:
 	return ret;
 }
 
@@ -1445,7 +1441,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-	extcon_dev_unregister(&info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

