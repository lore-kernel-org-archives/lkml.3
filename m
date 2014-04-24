Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaDXMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:43:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaDXMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:35:00 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-68-535904f2c674
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCHv3 9/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:57 +0900
Message-id: <1398342897-23670-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkWPcTS2SwQds3AYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C3ufz3KaHF51xw2i9uNK9gsTnezOvB4bFrV
	yeZx59oeNo95JwM9Xk78zebRt2UVo8fUKX8ZPY7f2M7k8XmTXABHFJdNSmpOZllqkb5dAlfG
	zO3LmAradCpenLzJ3sC4QrWLkYNDQsBE4vdLoy5GTiBTTOLCvfVsXYxcHEICSxkltr89xwqR
	MJE4+XInC0RiOqPEurm9rBBOE5PEwq0bGEGq2AS0JPa/uMEGYosIKEhs7n0GVsQssIFJYtmp
	JWAJYYEQiQd3TjCB2CwCqhI/P/Szg5zBK+Am8fR3BcQ2OYkPex6xg9icQOGzF66CtQoJuEqs
	bPgHNlNC4BK7xK8T3WwQcwQkvk0+xALxjqzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CJjveLE3OLSvHS95PzcTYzAaDn971n/Dsa7B6wPMSYDjZvILCWanA+MtrySeENjMyMLUxNT
	YyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDhR+vyK9ZpBJ96Kanf7
	O0oad/EFs+heipIIfsHzh+nv9z9Tu7i3rmqcK+J5f/Vl5+t+SZd3uJdXFvKI6nVVvdrI4a7m
	ZnlIc+1t/rZvV9Zazf52/do1zevnT+w9VjHfrE74Saz398bJH4sO3Fbfm/JV19a5ZZ7WKSnW
	RcdT3zpmKH66d7B2yk4lluKMREMt5qLiRABPJoUorAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQd1PLJHBBvMXsFscvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25x/+tRRovLu+awWdxuXMFmcbqb1YHHY9Oq
	TjaPO9f2sHnMOxno8XLibzaPvi2rGD2mTvnL6HH8xnYmj8+b5AI4ohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYwZszcvoypoE2n4sXJm+wNjCtUuxg5OSQETCROvtzJAmGL
	SVy4t56ti5GLQ0hgOqPEurm9rBBOE5PEwq0bGEGq2AS0JPa/uMEGYosIKEhs7n0GVsQssIFJ
	YtmpJWAJYYEQiQd3TjCB2CwCqhI/P/SzdzFycPAKuEk8/V0BsU1O4sOeR+wgNidQ+OyFq2Ct
	QgKuEisb/rFOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Gp9J72Bc1WBxiFGA
	g1GJh1fhVniwEGtiWXFl7iFGCQ5mJRHe2f8igoV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5
	H5go8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0dQ9+tnL
	+wue5sRvMeSYNq/4Reg369gSm53md5vr75Z63zVcdGvniTuNFosPzv50oyhDj0uYKf2d2rvn
	Tcv9gu/MvcTqsXed4o2g7Xo7b1p5x79OeTrzo81MpbpU/sOJW22fi+svFORt3SWXzKrw1Pme
	4m+1BpurS2Ze3FrYmev6fVKW7c4JOkosxRmJhlrMRcWJAEnK6R0KAwAA
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
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/extcon/extcon-palmas.c | 35 ++++++++++++++++++++---------------
 include/linux/mfd/palmas.h     |  2 +-
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 1a770e0..a9299ea 100644
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
 
-	status = devm_extcon_dev_register(&pdev->dev, &palmas_usb->edev);
+	status = devm_extcon_dev_register(&pdev->dev, palmas_usb->edev);
 	if (status) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-		kfree(palmas_usb->edev.name);
+		kfree(palmas_usb->edev->name);
 		return status;
 	}
 
@@ -209,7 +214,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		if (status < 0) {
 			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->id_irq, status);
-			kfree(palmas_usb->edev.name);
+			kfree(palmas_usb->edev->name);
 			return status;
 		}
 	}
@@ -224,7 +229,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		if (status < 0) {
 			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->vbus_irq, status);
-			kfree(palmas_usb->edev.name);
+			kfree(palmas_usb->edev->name);
 			return status;
 		}
 	}
@@ -238,7 +243,7 @@ static int palmas_usb_remove(struct platform_device *pdev)
 {
 	struct palmas_usb *palmas_usb = platform_get_drvdata(pdev);
 
-	kfree(palmas_usb->edev.name);
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

