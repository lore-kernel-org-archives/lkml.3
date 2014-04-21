Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaDUJgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:36:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15914 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaDUJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:26 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-35-5354e699f156
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/9] extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev
Date: Mon, 21 Apr 2014 18:36:23 +0900
Message-id: <1398072986-17386-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkWHfms5Bgg10fuCwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4//Uoo8XlXXPYLG43rmCzON3NarFgT4kD
	r8emVZ1sHneu7WHzmHcy0OPlxN9sHn1bVjF6TJ3yl9Hj+I3tTB6fN8kFcERx2aSk5mSWpRbp
	2yVwZXzc/Zu94KVmxZrWRawNjE+Uuxg5OSQETCROfzzABmGLSVy4tx7I5uIQEljKKPF0ykom
	mKKjE28zQiQWMUo0ff4BVdXEJDHr+zIWkCo2AS2J/S9ugI0SEVCQ2Nz7jBWkiFngFJPE+jv3
	wUYJCwRItHevYwexWQRUJfbsmMoMYvMKuEoca/0CtU5O4sOeR2A1nAJuEut+dLOC2EJANR3v
	+8DOkBC4xi4x/9EOVohBAhLfJh8CuoIDKCErsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4
	Kb3IRK84Mbe4NC9dLzk/dxMjMHJO/3s2YQfjvQPWhxiTgcZNZJYSTc4HRl5eSbyhsZmRhamJ
	qbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDyfFwgdOCF78ufLXvi
	2O33RVzlf5nj1uLcKsImLDjT0ubke9Ej0wQd1LkPr+2Nu7V55bJZqR835z+aYqEutq6E+47l
	CTndO/suiipUbUq2DFxzx+iGw/4fv9a/u/dSYusc/bU+zanCl49N9l+0Z9vklN0y2ezxeYVf
	Q/1e1O8Ib5ct2iQve0NbiaU4I9FQi7moOBEAgLAUsbICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd2Zz0KCDQ53MlkcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25x/+tRRovLu+awWdxuXMFmcbqb1WLBnhIH
	Xo9NqzrZPO5c28PmMe9koMfLib/ZPPq2rGL0mDrlL6PH8RvbmTw+b5IL4IhqYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpXSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxcfdv9oKXmhVrWhexNjA+Ue5i5OSQEDCRODrx
	NiOELSZx4d56ti5GLg4hgUWMEk2ff0A5TUwSs74vYwGpYhPQktj/4gYbiC0ioCCxufcZK0gR
	s8ApJon1d+4zgSSEBQIk2rvXsYPYLAKqEnt2TGUGsXkFXCWOtX5hglgnJ/FhzyOwGk4BN4l1
	P7pZQWwhoJqO932MExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjstn0jsYVzVY
	HGIU4GBU4uF9kR8SLMSaWFZcmXuIUYKDWUmEN2I9UIg3JbGyKrUoP76oNCe1+BBjMtBVE5ml
	RJPzgSkjryTe0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYWbYd
	/Vgkw/DilepFrvx2EccvOtacinty5Z8I8b98I82yI1Z89bMji4Rfn12j+6S41qyu43mR9QSr
	7UczS9TXxlrf3WkpvMN/oU5r1PtTBndXp/Z8ds5es8ZvSZzZrO9nhXbd050uHuasrzEtwyaO
	VzNjZn1ZrZXDNR+fspQf/vtrbSQ+vPFUYinOSDTUYi4qTgQARa1XzQ8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-palmas.c | 37 +++++++++++++++++++++----------------
 include/linux/mfd/palmas.h     |  2 +-
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 51db5bc..0b67a63f 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -57,7 +57,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
 	if (vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS) {
 		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
 			palmas_usb->linkstat = PALMAS_USB_STATE_VBUS;
-			extcon_set_cable_state(&palmas_usb->edev, "USB", true);
+			extcon_set_cable_state(palmas_usb->edev, "USB", true);
 			dev_info(palmas_usb->dev, "USB cable is attached\n");
 		} else {
 			dev_dbg(palmas_usb->dev,
@@ -66,7 +66,7 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
 	} else if (!(vbus_line_state & PALMAS_INT3_LINE_STATE_VBUS)) {
 		if (palmas_usb->linkstat == PALMAS_USB_STATE_VBUS) {
 			palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-			extcon_set_cable_state(&palmas_usb->edev, "USB", false);
+			extcon_set_cable_state(palmas_usb->edev, "USB", false);
 			dev_info(palmas_usb->dev, "USB cable is detached\n");
 		} else {
 			dev_dbg(palmas_usb->dev,
@@ -93,7 +93,7 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
+		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
 		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
 	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
@@ -101,17 +101,17 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
 			PALMAS_USB_ID_INT_LATCH_CLR,
 			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
+		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
 		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
 				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
+		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", false);
 		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
 	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
 				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
 		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
-		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
+		extcon_set_cable_state(palmas_usb->edev, "USB-HOST", true);
 		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
 	}
 
@@ -187,15 +187,20 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, palmas_usb);
 
-	palmas_usb->edev.supported_cable = palmas_extcon_cable;
-	palmas_usb->edev.dev.parent = palmas_usb->dev;
-	palmas_usb->edev.name = kstrdup(node->name, GFP_KERNEL);
-	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
+	palmas_usb->edev = devm_extcon_dev_allocate(&pdev->dev,
+						    palmas_extcon_cable);
+	if (!palmas_usb->edev) {
+		dev_err(&pdev->dev, "failed to allocate extcon device\n");
+		return -ENOMEM;
+	}
+	palmas_usb->edev->name = kstrdup(node->name, GFP_KERNEL);
+	palmas_usb->edev->dev.parent = palmas_usb->dev;
+	palmas_usb->edev->mutually_exclusive = mutually_exclusive;
 
-	status = extcon_dev_register(&palmas_usb->edev);
+	status = extcon_dev_register(palmas_usb->edev);
 	if (status) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-		kfree(palmas_usb->edev.name);
+		kfree(palmas_usb->edev->name);
 		return status;
 	}
 
@@ -232,8 +237,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	return 0;
 
 fail_extcon:
-	extcon_dev_unregister(&palmas_usb->edev);
-	kfree(palmas_usb->edev.name);
+	extcon_dev_unregister(palmas_usb->edev);
+	kfree(palmas_usb->edev->name);
 
 	return status;
 }
@@ -242,8 +247,8 @@ static int palmas_usb_remove(struct platform_device *pdev)
 {
 	struct palmas_usb *palmas_usb = platform_get_drvdata(pdev);
 
-	extcon_dev_unregister(&palmas_usb->edev);
-	kfree(palmas_usb->edev.name);
+	extcon_dev_unregister(palmas_usb->edev);
+	kfree(palmas_usb->edev->name);
 
 	return 0;
 }
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 9974e38..b8f87b7 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -415,7 +415,7 @@ struct palmas_usb {
 	struct palmas *palmas;
 	struct device *dev;
 
-	struct extcon_dev edev;
+	struct extcon_dev *edev;
 
 	int id_otg_irq;
 	int id_irq;
-- 
1.8.0

