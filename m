Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbaDXMfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:35:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45064 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbaDXMfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:35:02 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-03-535904f148ed
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 8/9] extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
Date: Thu, 24 Apr 2014 21:34:56 +0900
Message-id: <1398342897-23670-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSoPuRJTLYYMZaNYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+P4jicsBdtEK74eucLcwNgp1MXI
	ySEhYCLx5PspZghbTOLCvfVsXYxcHEICSxklds89ytTFyAFWdPKbNkR8OqPE59b1rBBOE5PE
	wq0bGEG62QS0JPa/uMEGYosIKEhs7n0GVsQs8IxR4sTVE2ArhAUCJC7tmcYEYrMIqEp87FsK
	1swr4CrxbedzNogz5CQ+7HnEDmJzCrhJnL1wFSwuBFSzsuEf2FAJgV3sEt9vv2eGGCQg8W3y
	IRaIU2UlNh2AekdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiMhdP/
	nk3cwXj/gPUhxmSgcROZpUST84GxlFcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjDt3dEeZbNuXtdxfotvBtNniTJq/mWWwzLpvJw+uU35/Z4vq
	j+rOHSEOohpn788R2nS2xtfMikmbY3l3tIlYyel2nusHIiue6Ps+b8m61Hew7fCBrBu3Vr48
	rTSpOOHoVN5rgbXXE7VELG/umeXkcSLloLZwfeFuK+lTj/+VyCmL6E6ym3TpuhJLcUaioRZz
	UXEiANkyz02bAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd2PLJHBBiu3yVkcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzju94wlKwTbTi65ErzA2MnUJdjBwcEgImEie/aXcxcgKZYhIX7q1n62Lk4hASmM4o8bl1
	PSuE08QksXDrBkaQKjYBLYn9L26wgdgiAgoSm3ufgRUxCzxjlDhx9QQzSEJYIEDi0p5pTCA2
	i4CqxMe+pWDNvAKuEt92PmeDWCcn8WHPI3YQm1PATeLshatgcSGgmpUN/1gnMPIuYGRYxSia
	WpBcUJyUnmuoV5yYW1yal66XnJ+7iREcac+kdjCubLA4xCjAwajEw3vgQniwEGtiWXFl7iFG
	CQ5mJRHe2f8igoV4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5H5gE8kriDY1NzIwsjcwNLYyM
	zUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0f0+n6j8Nu0nJ8s87PJfL4vwuL3dV399
	ucGxF0FquU+v/uDRTfPmeLny+i7F3J9bV1v7nIwNnSE9x2WmuZfIngevFsvHcDHnhkVOrNx2
	qfdSecF/3wa5JY9Uui9Mf6v9v8Fff+afe1c1q/NqZO/FFv+9uJjjaKDpy7McK8WOR3+d8edo
	vZWCphJLcUaioRZzUXEiAIIwvnT4AgAA
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
index 43af34c..41e2157 100644
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
 
-	ret = devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.0

