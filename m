Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaDYAnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:43:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaDYAmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:42 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-49-5359af7cbe2f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 8/9] extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
Date: Fri, 25 Apr 2014 09:42:23 +0900
Message-id: <1398386544-16295-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSoFuzPjLY4M97EYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2Pt1y/sBXtFK75Oq2lgnCDUxcjJ
	ISFgIrHn93EWCFtM4sK99WxdjFwcQgJLGSV6LjUBJTjAig7PK4OIT2eUONbUzArSICTQxCSx
	YUokiM0moCWx/8UNNhBbREBBYnPvM1aQBmaBZ4wSJ66eYAZJCAsESPy/PR2siEVAVWLK8qVM
	IDavgKvE+6ctUFfISXzY84gdxOYUcJM4dKKXBWKZq8Src3OYQIZKCOxilzhz9BHUIAGJb5MP
	QV0qK7HpADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzAOTv97
	NmEH470D1ocYk4HGTWSWEk3OB8ZRXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwKj4zNPVddcHt08rJy92dW34xaTqkuYSmMVhV//q2wTkqvSvv
	K9OEnHOSSx/cjGV+0XSlXW/BfjbRU5IGbbdE9bUMg85fYbi7a8c145f18RrPtuzvDZX8k3Rl
	XvsxxVcHgxwP/PlVZbl96/sF6V7cx55+yp/fnqRge/tJ3PVP9/02vDoo+KVrixJLcUaioRZz
	UXEiAADNAWiZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd2a9ZHBBo8f8lgcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz1n79wl6wV7Ti67SaBsYJQl2MHBwSAiYSh+eVdTFyApliEhfurWfrYuTiEBKYzihxrKmZ
	FSQhJNDEJLFhSiSIzSagJbH/xQ02EFtEQEFic+8zVpAGZoFnjBInrp5gBkkICwRI/L89HayI
	RUBVYsrypUwgNq+Aq8T7py0sENvkJD7secQOYnMKuEkcOtHLArHMVeLVuTlMExh5FzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIjrJn0jsYVzVYHGIU4GBU4uGdIBsZLMSaWFZcmXuI
	UYKDWUmEV3kVUIg3JbGyKrUoP76oNCe1+BBjMtBVE5mlRJPzgQkgryTe0NjEzMjSyNzQwsjY
	nDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYGScfXXFtj8Si9cpc3vuOpSde0HOO+mRk
	KXbhFXfaiYijsvoPl2Z37rA5FDTtkswy8/oTpiePFbdcuSG4ID/YPq3KozhKPnRb1hujl3sF
	3d3ftgcV2dls+H7u8PqkVs8Te6uf31i0V6fostDv1XIGStc/P5oVtfF4k2mSeYSJq/Wfr/K5
	D1TfKrEUZyQaajEXFScCAEgOPNX2AgAA
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
 drivers/extcon/extcon-gpio.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 43af34c..645b283 100644
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
+	if (IS_ERR(extcon_data->edev)) {
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
 
-	ret = devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.0

