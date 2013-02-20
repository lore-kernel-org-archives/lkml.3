Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab3BTGMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:12:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17298 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224Ab3BTGMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:12:12 -0500
X-AuditID: cbfee68f-b7f656d000000d78-d7-5124693b0424
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 06/11] mfd: omap-usb-host: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 15:12:11 +0900
Message-id: <002b01ce0f31$3873cb50$a95b61f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAE9wg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY13rTJVAgxntJhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj2st1bAW7BSqeXbrJ3sB4nreLkZNDQsBE4sP5l4wQtpjEhXvr
	2UBsIYFljBILL1nB1Mze28bSxcgFFJ/OKDGtaT87hDObSeLupSPMIFVsAmoSX74cZgexRQS0
	JLqPnQeaxMHBLOAicXSaCMRQW4nva/+xgticAnYSux6dB7OFBdwkzm3eDjaGRUBV4uzFDUwg
	Ni9Q/ZxHU5khbEGJH5PvsYDYzEDj1+88zgRhy0tsXvOWGWSVhIC6xKO/uhAXGEl8OXeAEaJE
	RGLfi3dQPy5jl7i0vBpilYDEt8mHWCBaZSU2HWCGKJGUOLjiBssERolZSBbPQrJ4FpLFs5Bs
	WMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJKr6dzDePWB9iDEZaP1EZinR5HxgVOaV
	xBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PqIx85
	J70QfsfzO8EwJdmZ+9qdPX+uPFS7copB09kgk3fJ9fzy/9/nXy3+t6vgwPHjnw46Wmt/+fTO
	dnH9bdVN8tJZnaIr9rYpzXK6t39v87WwfVFX5rvs9mw4Z+D+OfxirpStjs2ihiKf+8zq98we
	TSpwnRlyyOhJV6KJ7RpWucL2S4nvry5UYinOSDTUYi4qTgQAgpbuH8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoK51pkqgQfsOA4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMe3lOraC3QIVzy7dZG9g
	PM/bxcjJISFgIjF7bxsLhC0mceHeerYuRi4OIYHpjBLTmvazQzizmSTuXjrCDFLFJqAm8eXL
	YXYQW0RAS6L72HmgDg4OZgEXiaPTREDCQgK2Et/X/mMFsTkF7CR2PToPZgsLuEmc27wdbAyL
	gKrE2YsbmEBsXqD6OY+mMkPYghI/Jt8DO4gZaPz6nceZIGx5ic1r3jKDrJIQUJd49FcX4gIj
	iS/nDjBClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjttn0jsYVzVYHGIU4GBU4uFtWKgcKMSaWFZcmXuIUYKDWUmEt9lJJVCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MG6KM0usz2K/NSk8d4X9BkG9xCe3ftWvmL5vPWvzA+GH98Iep97JnfJ8
	Lc+Dkvi9p4XThQv1RbPnf8/rOHPjgPO/G/d2Om5sebHgQcLRG38ydjhvP9oksfDvYaMe71+e
	T860s7gVp9ucYl7Nq3pZ8MjE4g33/x6MmPfqUOtX4aZMr+9ab08n9c1XYinOSDTUYi4qTgQA
	6vV4cB8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/omap-usb-host.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 6b5edf6..2104d66 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -437,11 +437,11 @@ static void omap_usbhs_init(struct device *dev)
 
 	if (pdata->phy_reset) {
 		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_request_one(pdata->reset_gpio_port[0],
+			devm_gpio_request_one(dev, pdata->reset_gpio_port[0],
 					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
 
 		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_request_one(pdata->reset_gpio_port[1],
+			devm_gpio_request_one(dev, pdata->reset_gpio_port[1],
 					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
 
 		/* Hold the PHY in RESET for enough time till DIR is high */
@@ -492,21 +492,6 @@ static void omap_usbhs_init(struct device *dev)
 	}
 }
 
-static void omap_usbhs_deinit(struct device *dev)
-{
-	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_free(pdata->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_free(pdata->reset_gpio_port[1]);
-	}
-}
-
-
 /**
  * usbhs_omap_probe - initialize TI-based HCDs
  *
@@ -709,8 +694,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_alloc:
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
@@ -755,8 +738,6 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 	int i;
 
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
-- 
1.7.2.5


