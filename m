Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaDWEMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:12:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57763 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaDWEMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:12:39 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ca-53573db5bdfa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] usb: phy: tahvo: Use devm_extcon_dev_* function for resource
 management of extcon
Date: Wed, 23 Apr 2014 13:12:43 +0900
Message-id: <1398226363-19536-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkUHebbXiwwWchi4P36y2uf3nOatG8
	eD2bxeVdc9gsFi1rZXZg9dg/dw27R9+WVYwex29sZ/L4vEkugCWKyyYlNSezLLVI3y6BK2Pi
	xePMBd/lK+4fPMvawPhOqouRk0NCwETiwvqvTBC2mMSFe+vZuhi5OIQEljJKnOh5A5TgACu6
	clIfIr6IUeL0tA9MEE4Tk8Te1XfZQbrZBLQk9r+4wQZiiwjoSMz+cZERxGYWSJbYc+cjWI2w
	QIpE14Y9YHEWAVWJK6c2gW3mFXCVmH/7N9QVchIf9jxiB1kgIfCeTaJlYw8rRIOAxLfJh1gg
	LpKV2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDMrT/55N
	2MF474D1IcZkoHETmaVEk/OBQZ1XEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYxGV2s0Mkz2N12R3/1679c52fo3rHRitAVKnpw5oTl1h+H08hv7
	41RYw428O1ecmaHYkZWU8HvX9ktivaZTF5c27zq9gHVN2aucE19WVVfnbTqq77LDz0tt3nSn
	yfqmy7pkrvqpfPD+X+B4aXbJE8XHGxzmCUpKzwwrLhcuzFxpt+Th/TKZ9z+VWIozEg21mIuK
	EwH6LtByYAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jAd2ttuHBBit+m1gcvF9vcf3Lc1aL
	5sXr2Swu75rDZrFoWSuzA6vH/rlr2D36tqxi9Dh+YzuTx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhDWMGRMvHmcu+C5fcf/gWdYGxndSXYwcHBICJhJXTup3MXIC
	mWISF+6tZ+ti5OIQEljEKHF62gcmCKeJSWLv6rvsIFVsAloS+1/cYAOxRQR0JGb/uMgIYjML
	JEvsufMRrEZYIEWia8MesDiLgKrElVObmEBsXgFXifm3fzNBbJOT+LDnEfsERu4FjAyrGEVT
	C5ILipPSc430ihNzi0vz0vWS83M3MYKD/pn0DsZVDRaHGAU4GJV4eCWWhwULsSaWFVfmHmKU
	4GBWEuGd+REoxJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR5HxgROaVxBsam5gZWRqZG1oYGZuT
	Jqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Oh03W9rEV6OoorqgWaVG4Ge7h9V7/+00Vm
	Spuui3v3hqt7ZuYX81/fMHuHPuP+vaaZoYZ/jpw+9pUxz+Q/S9Dm6ri/V9j85cw/u6xm8E9R
	1LfYf/Pj8xkrt2ZI3+LfZSJk63Dc6vZ09vilVbqZtyPV3j162Tgj+/F8m4/iCW9evK+dzp7x
	iFuJpTgj0VCLuag4EQDIAeaxvgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses devm_extcon_dev_{allocate, register} function for automatically
resource management of extcon device instead of legacy method and simplifies
the behavior of register/unregister for extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
This patch has dependency about following patches[1-2]:
[1] https://lkml.org/lkml/2014/4/21/140
[2] https://lkml.org/lkml/2014/4/21/164

 drivers/usb/phy/phy-tahvo.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index cc61ee4..8cde928 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -57,7 +57,7 @@ struct tahvo_usb {
 	struct clk		*ick;
 	int			irq;
 	int			tahvo_mode;
-	struct extcon_dev	extcon;
+	struct extcon_dev	*extcon;
 };
 
 static const char *tahvo_cable[] = {
@@ -118,7 +118,7 @@ static void check_vbus_state(struct tahvo_usb *tu)
 	prev_state = tu->vbus_state;
 	tu->vbus_state = reg & TAHVO_STAT_VBUS;
 	if (prev_state != tu->vbus_state) {
-		extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
+		extcon_set_cable_state(tu->extcon, "USB", tu->vbus_state);
 		sysfs_notify(&tu->pt_dev->dev.kobj, NULL, "vbus_state");
 	}
 }
@@ -127,7 +127,7 @@ static void tahvo_usb_become_host(struct tahvo_usb *tu)
 {
 	struct retu_dev *rdev = dev_get_drvdata(tu->pt_dev->dev.parent);
 
-	extcon_set_cable_state(&tu->extcon, "USB-HOST", true);
+	extcon_set_cable_state(tu->extcon, "USB-HOST", true);
 
 	/* Power up the transceiver in USB host mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_REGOUT | USBR_NSUSPEND |
@@ -146,7 +146,7 @@ static void tahvo_usb_become_peripheral(struct tahvo_usb *tu)
 {
 	struct retu_dev *rdev = dev_get_drvdata(tu->pt_dev->dev.parent);
 
-	extcon_set_cable_state(&tu->extcon, "USB-HOST", false);
+	extcon_set_cable_state(tu->extcon, "USB-HOST", false);
 
 	/* Power up transceiver and set it in USB peripheral mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_SLAVE_CONTROL | USBR_REGOUT |
@@ -360,11 +360,15 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	 */
 	tu->vbus_state = retu_read(rdev, TAHVO_REG_IDSR) & TAHVO_STAT_VBUS;
 
-	tu->extcon.name = DRIVER_NAME;
-	tu->extcon.supported_cable = tahvo_cable;
-	tu->extcon.dev.parent = &pdev->dev;
+	tu->extcon = devm_extcon_dev_allocate(&pdev->dev, tahvo_cable);
+	if (!tu->extcon) {
+		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
+		return -ENOMEM;
+	}
+	tu->extcon->name = DRIVER_NAME;
+	tu->extcon->dev.parent = &pdev->dev;
 
-	ret = extcon_dev_register(&tu->extcon);
+	ret = devm_extcon_dev_register(&pdev->dev, tu->extcon);
 	if (ret) {
 		dev_err(&pdev->dev, "could not register extcon device: %d\n",
 			ret);
@@ -372,9 +376,9 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	}
 
 	/* Set the initial cable state. */
-	extcon_set_cable_state(&tu->extcon, "USB-HOST",
+	extcon_set_cable_state(tu->extcon, "USB-HOST",
 			       tu->tahvo_mode == TAHVO_MODE_HOST);
-	extcon_set_cable_state(&tu->extcon, "USB", tu->vbus_state);
+	extcon_set_cable_state(tu->extcon, "USB", tu->vbus_state);
 
 	/* Create OTG interface */
 	tahvo_usb_power_off(tu);
@@ -391,7 +395,7 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "cannot register USB transceiver: %d\n",
 			ret);
-		goto err_extcon_unreg;
+		goto err_disable_clk;
 	}
 
 	dev_set_drvdata(&pdev->dev, tu);
@@ -418,8 +422,6 @@ err_free_irq:
 	free_irq(tu->irq, tu);
 err_remove_phy:
 	usb_remove_phy(&tu->phy);
-err_extcon_unreg:
-	extcon_dev_unregister(&tu->extcon);
 err_disable_clk:
 	if (!IS_ERR(tu->ick))
 		clk_disable(tu->ick);
@@ -434,7 +436,6 @@ static int tahvo_usb_remove(struct platform_device *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &tahvo_attr_group);
 	free_irq(tu->irq, tu);
 	usb_remove_phy(&tu->phy);
-	extcon_dev_unregister(&tu->extcon);
 	if (!IS_ERR(tu->ick))
 		clk_disable(tu->ick);
 
-- 
1.8.0

