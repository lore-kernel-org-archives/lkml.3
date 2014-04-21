Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaDUMCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:02:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaDUMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:24 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-87-535508ceeb27
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 9/9] extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
Date: Mon, 21 Apr 2014 21:02:22 +0900
Message-id: <1398081742-24277-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqHuOIzTY4OkFUYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+P4jicsBdtEK74eucLcwNgp1MXI
	ySEhYCKxasYXZghbTOLCvfVsXYxcHEICSxkl/k2ayAJTdPTRGyaIxCJGiZuHDjJCOE1MEofv
	72AFqWIT0JLY/+IGG4gtIqAgsbn3GStIEbPAM0aJE1dPgO0QFgiQOP5wDpjNIqAqsereSvYu
	Rg4OXgE3icMfhCG2yUl82PMILMwJFL5wohwkLCTgKvHo92awvRIC29glHn7exgIxRkDi2+RD
	LCD1EgKyEpsOQH0jKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIERsLp
	f8/6djDePGB9iDEZaNxEZinR5HxgJOWVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsYyI728T3u362z/UNzw/9G6JQzaHJZPn7vOmVAo/oPl3wp1
	nelHZhs6qnktk/rtkNbRevf31U06kmFTEl323jyz7Mw6j6NPHmdGLS5441s0x5+1kl203VK1
	XfaxgNTnYyb3lsYb7xBhV1tSo815iDH+d96rwiqWD1U8Su0pq/VLJMR3CzW8aFFiKc5INNRi
	LipOBACB9kMFmgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd1zHKHBBst/8locvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzju94wlKwTbTi65ErzA2MnUJdjJwcEgImEkcfvWGCsMUkLtxbz9bFyMUhJLCIUeLmoYOM
	EE4Tk8Th+ztYQarYBLQk9r+4wQZiiwgoSGzufcYKUsQs8IxR4sTVE8wgCWGBAInjD+eA2SwC
	qhKr7q1k72Lk4OAVcJM4/EEYYpucxIc9j8DCnEDhCyfKQcJCAq4Sj35vZpzAyLuAkWEVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnCcPZPawbiyweIQowAHoxIP74ySkGAh1sSy4srcQ4wS
	HMxKIrwR64FCvCmJlVWpRfnxRaU5qcWHGJOBbprILCWanA9MAXkl8YbGJmZGlkbmhhZGxuak
	CSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwKimbLLLauubu6euxPSd2FmwO8h2q5h3b+xP
	JQ5BYfvP5xg3V3g9CzDbYm4btZHd0unBhbiNOzID3+jrHmDm9C6xPvSVX2leZkiv9G7O1VZ/
	c5rLbY3TLn1xva+uvesaT5lBqtQ7+yVv9WUOene2bfxdPme31KP6K5XXcuVXaanoXGU2crpg
	qMRSnJFoqMVcVJwIAFlKmgP3AgAA
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

