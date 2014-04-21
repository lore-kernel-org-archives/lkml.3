Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaDUMDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:03:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaDUMCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:21 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-23-535508ccdcc3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCHv2 6/9] extcon: palmas: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:19 +0900
Message-id: <1398081742-24277-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkSPcMR2iwwb8uaYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C3ufz3KaHF51xw2i9uNK9gsTnezOvB4bFrV
	yeZx59oeNo95JwM9Xk78zebRt2UVo8fUKX8ZPY7f2M7k8XmTXABHFJdNSmpOZllqkb5dAlfG
	q5fLGQtuaVdsnOrfwNio2sXIwSEhYCKxZqlSFyMnkCkmceHeerYuRi4OIYGljBKtz08yQiRM
	JN78PgSVWMQocWLnCyiniUnix99lTCBVbAJaEvtf3GADsUUEFCQ29z5jBSliFtjAJLHs1BI2
	kHXCAiESC1odQWpYBFQlJv36zgwS5hVwlZh9wgRimZzEhz2P2EHCnAJuEhdOlIOEhYAqHv3e
	zAgyUULgHLvE/73XWCHGCEh8m3yIBeIZWYlNB5ghxkhKHFxxg2UCo/ACRoZVjKKpBckFxUnp
	RYZ6xYm5xaV56XrJ+bmbGIFxcvrfs94djLcPWB9iTAYaN5FZSjQ5HxhneSXxhsZmRhamJqbG
	RuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKFPSyev6Omev7M3tXN8C
	5vxsm3Nr5nfFmMlKy40bN/YZzl1ldnD94sKokDOdxq7q8xY5NjDeSj4fkTHlql6L1aurd2Wm
	xTxtO/sx72K1gfHUv99yQ89vceVIKUp6mMPV1Z1X/Xehk+bPTR/fT+Thyq258NrJ/FlOCfdf
	Y9MLfS0Owv/+L3HJVGIpzkg01GIuKk4EABuGi/ipAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd0zHKHBBtuvCFocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25x/+tRRovLu+awWdxuXMFmcbqb1YHHY9Oq
	TjaPO9f2sHnMOxno8XLibzaPvi2rGD2mTvnL6HH8xnYmj8+b5AI4ohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYwZrx6uZyx4JZ2xcap/g2MjapdjJwcEgImEm9+H2KDsMUk
	LtxbD2RzcQgJLGKUOLHzBZTTxCTx4+8yJpAqNgEtif0vboB1iAgoSGzufcYKUsQssIFJYtmp
	JUAJDg5hgRCJBa2OIDUsAqoSk359ZwYJ8wq4Ssw+YQKxTE7iw55H7CBhTgE3iQsnykHCQkAV
	j35vZpzAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAcPpPewbiqweIQowAHoxIP
	74v8kGAh1sSy4srcQ4wSHMxKIrwR64FCvCmJlVWpRfnxRaU5qcWHGJOBbprILCWanA9MEXkl
	8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJjdnPR2a1Llv7l7
	V1uaTj/40fj4myg+q7nKk4XYzz9N71jxpUd4eoB62frvv63uHorYtOHN5lVm+e9Kf8vPZW76
	tlbXfJL8Zb0nm5lKpYVl7i6Qj+K1mCDoHxHnNv+DcI/+Mc7vuuf8ioRUU0OVo5uN1J9fur5S
	18t/Sf7srhmF00VLl250O6jEUpyRaKjFXFScCAAm25YMBwMAAA==
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

