Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaEZE5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:57:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20896 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEZE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:57:18 -0400
X-AuditID: cbfee690-b7fb56d000003439-e5-5382c9acdf1b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org
Subject: [PATCH] input: gpio_keys: Add IRQF_NO_SUSPEND flag to wake-up from
 freeze state
Date: Mon, 26 May 2014 13:57:14 +0900
Message-id: <1401080234-31174-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkSHfNyaZggw2rzSyuf3nOanF40QtG
	i5ufvrFaXN41h83i5J9eRgdWj52z7rJ73Lm2h82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mq7PO8BWsJiz4uPW28wNjD/Yuxg5OSQETCT+NK9ngbDFJC7cW8/WxcjFISSwlFFibft8hKKn
	mxkhEtMZJb6veQzlNDFJHLx3DKydTUBLYv+LG2wgtoiAgsTm3mesIEXMAvMYJeYsuMAKkhAW
	iJJYtOgrUBEHB4uAqkTzTzuQMK+Aq8Td+5uYIbbJSXzY8whq83s2iSldGiA2i4CAxLfJh1hA
	WiUEZCU2HYAql5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAgPz9L9n
	E3Yw3jtgfYgxGWjcRGYp0eR8YGDnlcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVANjUZ7R35aelYyXQ3KWh82O+HHz86mzjlrfzJqLrjKvtEz9F7ZX
	iK1QnbmopSfgWO8h/uCtB27faSri6mV1+R61ZP6Cmu8Mi94/nKQqeurn9daH04uiIiqWmFpc
	j12lkDJLZ4/saqbA3msyNWnv18z7xDCT5/Aj1pmSew12rxUw/709wNviS1SuEktxRqKhFnNR
	cSIA+Knl8mICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jQd01J5uCDY6d1rO4/uU5q8XhRS8Y
	LW5++sZqcXnXHDaLk396GR1YPXbOusvucefaHjaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcy4Pu8AW8FizoqPW28zNzD+YO9i5OSQEDCR+PN0MyOE
	LSZx4d56ti5GLg4hgemMEt/XPGaEcJqYJA7eO8YCUsUmoCWx/8UNNhBbREBBYnPvM1aQImaB
	eYwScxZcYAVJCAtESSxa9BWoiIODRUBVovmnHUiYV8BV4u79TcwQ2+QkPux5xD6BkXsBI8Mq
	RtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAfya1g3Flg8UhRgEORiUe3gPeTcFCrIllxZW5
	hxglOJiVRHgv5AKFeFMSK6tSi/Lji0pzUosPMSYDLZ/ILCWanA+MyrySeENjEzMjSyNzQwsj
	Y3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYCw6ov412swgaYeyM0OmgvfxtgVHTUWP
	/c03SO35XjklQ35jvkGao2j0j4rHbVMiPtzbcnKygN56r+Ag47TwA7sLQh2Nlv/adHXx08PM
	3LMlLBeFLWGYd6Sx+Nrhs9JaKdZb3PYWl8+ptHe0OxayYubJdK4C3nfXXMKWOTodWFrlt5Rl
	0oUnXEosxRmJhlrMRcWJAFsuT4DAAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add IRQF_NO_SUSPEND flag before requesting interrupt handler
if button->wakeup is true. If ther interrupt of gpio-keys hasn't included
IRQF_NO_SUSPEND, wouldn't wake-up from freeze state when pressing button.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/input/keyboard/gpio_keys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 2db1324..40f3963 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -503,6 +503,9 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 	if (!button->can_disable)
 		irqflags |= IRQF_SHARED;
 
+	if (button->wakeup)
+		irqflags |= IRQF_NO_SUSPEND;
+
 	error = request_any_context_irq(bdata->irq, isr, irqflags, desc, bdata);
 	if (error < 0) {
 		dev_err(dev, "Unable to claim irq %d; error %d\n",
-- 
1.8.0

