Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaDUJh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDUJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:29 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-43-5354e69abdf1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 9/9] extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
Date: Mon, 21 Apr 2014 18:36:26 +0900
Message-id: <1398072986-17386-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSrDvrWUiwwb8fihYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2iwV7Shy4PTat6mTzeDnx
	N5tH35ZVjB5Tp/xl9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZs889Yi6YKFlxf9ZktgbG
	maJdjJwcEgImErO2f2aHsMUkLtxbz9bFyMUhJLCUUWLP+ycsMEWff59khkgsYpSYcGExlNPE
	JDGn+wQzSBWbgJbE/hc32EBsEQEFic29z1hBipgFGoCKPi1gAkkIC/hJNPzeD2azCKhKPHs4
	B2w3r4CbxO7Jd1kh1slJfNjzCCzOCRRf96MbLC4k4CrR8b6PEWSohMA2domWvduYIQYJSHyb
	fAjoVg6ghKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJjveLE3OLSvHS95PzcTYzA
	qDj971n/Dsa7B6wPMSYDjZvILCWanA+MqrySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwBi2tk/C1WjtD0m2WRWi1srVN8/9fcvxW/CJucRpZqZL
	SlEr+hs8l85k7miaOzv3nML06WUa/6c2S3rxOb7QdhU/W6tsI7Zqo2brPc+buZHS33X2XEpK
	83pwMXPflcIfBq3GYclvfPW4oqd9mv4qM9vwrovtusNfWB4WzGoJ3HJ9Kl9lEpP2LCWW4oxE
	Qy3mouJEAA6qnpagAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd1Zz0KCDVpfS1ocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYLBbsKXHg9ti0qpPN4+XE
	32wefVtWMXpMnfKX0eP4je1MHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzJh97hFzwUTJivuzJrM1MM4U7WLk5JAQMJH4/PskM4QtJnHh3nq2LkYuDiGBRYwS
	Ey4sZoZwmpgk5nSfAKtiE9CS2P/iBhuILSKgILG59xkrSBGzQANQ0acFTCAJYQE/iYbf+8Fs
	FgFViWcP57CD2LwCbhK7J99lhVgnJ/FhzyOwOCdQfN2PbrC4kICrRMf7PsYJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgTH3DPpHYyrGiwOMQpwMCrx8L7IDwkWYk0sK67MPcQo
	wcGsJMIbsR4oxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAdJBXEm9obGJmZGlkbmhhZGxO
	mrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyLHi9Qfm1o1f2KXzG1TjhW/75yRlPmjf/B
	Ao9uai/dffly5YcyPoWGv4XrLGuy5dqSS3qP6Hia1qdWLn4mr+zNv4tF8uV3rjRHi7jymKXl
	pzJ+zLylk6pl6FxQ9CCjQpFpb2HdyntM3xSn6p1RMbM99nD5/Uftsc5PtFRjlaXSwk6tOi9x
	S4mlOCPRUIu5qDgRAEZHDav9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-gpio.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..567eba2 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -32,7 +32,7 @@
 #include <linux/extcon/extcon-gpio.h>
 
 struct gpio_extcon_data {
-	struct extcon_dev edev;
+	struct extcon_dev *edev;
 	unsigned gpio;
 	bool gpio_active_low;
 	const char *state_on;
@@ -53,7 +53,7 @@ static void gpio_extcon_work(struct work_struct *work)
 	state = gpio_get_value(data->gpio);
 	if (data->gpio_active_low)
 		state = !state;
-	extcon_set_state(&data->edev, state);
+	extcon_set_state(data->edev, state);
 }
 
 static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
@@ -67,9 +67,10 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
 
 static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 {
-	struct gpio_extcon_data	*extcon_data =
-		container_of(edev, struct gpio_extcon_data, edev);
+	struct device *dev = edev->dev.parent;
+	struct gpio_extcon_data *extcon_data = dev_get_drvdata(dev);
 	const char *state;
+
 	if (extcon_get_state(edev))
 		state = extcon_data->state_on;
 	else
@@ -98,15 +99,21 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	if (!extcon_data)
 		return -ENOMEM;
 
-	extcon_data->edev.name = pdata->name;
-	extcon_data->edev.dev.parent = &pdev->dev;
+	extcon_data->edev = devm_extcon_dev_allocate(&pdev->dev, NULL);
+	if (!extcon_data->edev) {
+		dev_err(&pdev->dev, "failed to allocate extcon device\n");
+		return -ENOMEM;
+	}
+	extcon_data->edev->name = pdata->name;
+	extcon_data->edev->dev.parent = &pdev->dev;
+
 	extcon_data->gpio = pdata->gpio;
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
 	extcon_data->check_on_resume = pdata->check_on_resume;
 	if (pdata->state_on && pdata->state_off)
-		extcon_data->edev.print_state = extcon_gpio_print_state;
+		extcon_data->edev->print_state = extcon_gpio_print_state;
 
 	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
 				    pdev->name);
@@ -121,7 +128,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 				msecs_to_jiffies(pdata->debounce);
 	}
 
-	ret = extcon_dev_register(&extcon_data->edev);
+	ret = extcon_dev_register(extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
@@ -146,7 +153,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	extcon_dev_unregister(&extcon_data->edev);
+	extcon_dev_unregister(extcon_data->edev);
 
 	return ret;
 }
@@ -157,7 +164,7 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&extcon_data->work);
 	free_irq(extcon_data->irq, extcon_data);
-	extcon_dev_unregister(&extcon_data->edev);
+	extcon_dev_unregister(extcon_data->edev);
 
 	return 0;
 }
-- 
1.8.0

