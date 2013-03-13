Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3CMJCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:02:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMJCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:02:36 -0400
X-AuditID: cbfee68e-b7f946d000001e37-67-514040a71c48
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, cw00.choi@samsung.com
Subject: [PATCH 2/3] extcon: max77693: Fix bug of wrong pointer when platform
 data is not used
Date: Wed, 13 Mar 2013 18:02:17 +0900
Message-id: <1363165338-989-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
References: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t8zXd3lDg6BBp9fq1tc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZ+1+9ZytYrlQx/+EaxgbG
	CTJdjBwcEgImEqv253YxcgKZYhIX7q1nA7GFBJYxSvy8zAhTsuGUZBcjF1B4OqPElfuT2CCc
	/4wSS649ZwFpYBPQktj/4gZYs4iAgsTm3mesIDazgJ/Em81fGUFsYYEEidkrtzCB2CwCqhId
	L0+DxXkFnCWuLOtihDhCTuLDnkfsIIs5BVwkDlwoh7jHWWL5zV8sIHslBD6zSTy98JgFYo6A
	xLfJh1ggDpWV2HSAGWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kR
	EqR9OxhvHrA+xJgMNG4is5Rocj4wyPNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwGh5eYbJ07qDGm+e3tW67cC096TjwWLWp58T2v+Hunzq63xj
	//S6sou9WEhcc5LDi28z7SyLvj/+v3IyT+J93a+8UQ0f9AWyFJwDkm/65B0V7jCPbrizPOfF
	c5FZCRd0khV3KyyaoZiQeOveqoTAGe3TxRc0vJBniKgxO9I/P8Rc+d9MJ0cVJyWW4oxEQy3m
	ouJEACQp5QdoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd3lDg6BBl/vKVlc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGftfvWcrWK5UMf/hGsYGxgkyXYwcHBICJhIbTkl2MXICmWISF+6tZ+ti5OIQEpjO
	KHHl/iQo5z+jxJJrz1lAqtgEtCT2v7jBBmKLCChIbO59xgpiMwv4SbzZ/JURxBYWSJCYvXIL
	E4jNIqAq0fHyNFicV8BZ4sqyLkaIbXISH/Y8Ygc5glPAReLAhXKQsBBQyfKbv1gmMPIuYGRY
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcB8+kdzCuarA4xCjAwajEwyuRZh8oxJpYVlyZ
	e4hRgoNZSYT3m41DoBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA2M0ryTe0NjEzMjSyMzY
	xNzYmDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYOT4EFDu8yn2/9JPaJa8le1fJNR3Y
	7y9u9TFwlvO2KD6DxeXXdz/lULdMuCtzeL1d4Ev2K/sP/61X9WgNStFr0W+5J+r/YLKtGptE
	xrtzzj+U7+3y2pi7QHrfpCMzXKdlbvh0KGCOvbDxw2SripzT6TcXPwyzYEyYZ3LMrUoy/+Ps
	twFvVN3dlFiKMxINtZiLihMBdmKnc8cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix wrong pointer of platform data. If each machine set
platform data for h/w path or delay time of workqueue, this driver
happen kernel panic related to null pointer.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 90 +++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index b70e381..fea1062 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1045,7 +1045,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 {
 	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
 	struct max77693_platform_data *pdata = dev_get_platdata(max77693->dev);
-	struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
 	struct max77693_muic_info *info;
 	int delay_jiffies;
 	int ret;
@@ -1145,44 +1144,63 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	/* Initialize MUIC register by using platform data */
-	for (i = 0 ; i < muic_pdata->num_init_data ; i++) {
-		enum max77693_irq_source irq_src = MAX77693_IRQ_GROUP_NR;
-
-		max77693_write_reg(info->max77693->regmap_muic,
-				muic_pdata->init_data[i].addr,
-				muic_pdata->init_data[i].data);
-
-		switch (muic_pdata->init_data[i].addr) {
-		case MAX77693_MUIC_REG_INTMASK1:
-			irq_src = MUIC_INT1;
-			break;
-		case MAX77693_MUIC_REG_INTMASK2:
-			irq_src = MUIC_INT2;
-			break;
-		case MAX77693_MUIC_REG_INTMASK3:
-			irq_src = MUIC_INT3;
-			break;
+	if (pdata->muic_data) {
+		struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
+
+		/* Initialize MUIC register by using platform data */
+		for (i = 0 ; i < muic_pdata->num_init_data ; i++) {
+			enum max77693_irq_source irq_src
+					= MAX77693_IRQ_GROUP_NR;
+
+			max77693_write_reg(info->max77693->regmap_muic,
+					muic_pdata->init_data[i].addr,
+					muic_pdata->init_data[i].data);
+
+			switch (muic_pdata->init_data[i].addr) {
+			case MAX77693_MUIC_REG_INTMASK1:
+				irq_src = MUIC_INT1;
+				break;
+			case MAX77693_MUIC_REG_INTMASK2:
+				irq_src = MUIC_INT2;
+				break;
+			case MAX77693_MUIC_REG_INTMASK3:
+				irq_src = MUIC_INT3;
+				break;
+			}
+
+			if (irq_src < MAX77693_IRQ_GROUP_NR)
+				info->max77693->irq_masks_cur[irq_src]
+					= muic_pdata->init_data[i].data;
 		}
 
-		if (irq_src < MAX77693_IRQ_GROUP_NR)
-			info->max77693->irq_masks_cur[irq_src]
-				= muic_pdata->init_data[i].data;
-	}
+		/*
+		 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
+		 * h/w path of COMP2/COMN1 on CONTROL1 register.
+		 */
+		if (muic_pdata->path_uart)
+			info->path_uart = muic_pdata->path_uart;
+		else
+			info->path_uart = CONTROL1_SW_UART;
 
-	/*
-	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
-	 * h/w path of COMP2/COMN1 on CONTROL1 register.
-	 */
-	if (muic_pdata->path_uart)
-		info->path_uart = muic_pdata->path_uart;
-	else
-		info->path_uart = CONTROL1_SW_UART;
+		if (muic_pdata->path_usb)
+			info->path_usb = muic_pdata->path_usb;
+		else
+			info->path_usb = CONTROL1_SW_USB;
 
-	if (muic_pdata->path_usb)
-		info->path_usb = muic_pdata->path_usb;
-	else
+		/*
+		 * Default delay time for detecting cable state
+		 * after certain time.
+		 */
+		if (muic_pdata->detcable_delay_ms)
+			delay_jiffies =
+				msecs_to_jiffies(muic_pdata->detcable_delay_ms);
+		else
+			delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
+	} else {
 		info->path_usb = CONTROL1_SW_USB;
+		info->path_uart = CONTROL1_SW_UART;
+		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
+	}
 
 	/* Set initial path for UART */
 	 max77693_muic_set_path(info, info->path_uart, true);
@@ -1208,10 +1226,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max77693_muic_detect_cable_wq);
-	if (muic_pdata->detcable_delay_ms)
-		delay_jiffies = msecs_to_jiffies(muic_pdata->detcable_delay_ms);
-	else
-		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
 	schedule_delayed_work(&info->wq_detcable, delay_jiffies);
 
 	return ret;
-- 
1.8.0

