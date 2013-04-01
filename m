Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab3DAJoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:44:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3DAJoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:44:13 -0400
X-AuditID: cbfee68e-b7f946d000001e37-33-515956eb264f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 06/27] rtc: rtc-ds1286: use devm_*() functions
Date: Mon, 01 Apr 2013 18:44:11 +0900
Message-id: <001101ce2ebd$768075f0$638161d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAEF/Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ93XYZGBBovea1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcejJG+aCBUIV+88GNzD+5Oti5OSQEDCRuPP3IjuELSZx4d56NhBbSGAZo8TWJg+Y
	mjlfOoDiXEDxRYwSLasnQDm/GCVu3Z7BCFLFJqAm8eXLYaBJHBwiAvoSbS0aIDXMAr2MEmd6
	d7NDTLWV+HH2OzOIzSlgJ/Fm4TywXmEg+92XCWCbWQRUJfaubgSr4QWqf/F8NROELSjxY/I9
	FhCbWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwkuhff5sVokREYt+Ld4wQz9xjl7j5
	WxNilYDEt8mHWCBaZSU2HWCGKJGUOLjiBssERolZSBbPQrJ4FpLFs5BsWMDIsopRNLUguaA4
	Kb3ISK84Mbe4NC9dLzk/dxMjJEr7djDePGB9iDEZaP1EZinR5HxglOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFlofZdu8y+kHPNer/X/rIW
	4s4tft819+vrubHM4hki2+4Xvedb/oP/uta8gm8VfxJjVzhNE7ixedouiwmLNvwQv1l1ddrR
	zRdSz975M9fWvyx/flnwA75nhxiCdk8O/btd5qHo/lzhOUe1j4l/nLqmsLmkztYxvcHYTUzD
	r17hY9ocqTsC4cVKLMUZiYZazEXFiQBTsk9U6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd3XYZGBBl3PVCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDj05A1zwQKhiv1ngxsYf/J1MXJySAiYSMz5
	0sEGYYtJXLi3Hsjm4hASWMQo0bJ6ApTzi1Hi1u0ZjCBVbAJqEl++HGbvYuTgEBHQl2hr0QCp
	YRboZZQ407ubHaRGSMBW4sfZ78wgNqeAncSbhfPAeoWB7HdfJoBtYxFQldi7uhGshheo/sXz
	1UwQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASKJ//W1WiBIRiX0v
	3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWngmdQO
	xpUNFocYBTgYlXh4Iy5EBAqxJpYVV+YeYpTgYFYS4fX5BhTiTUmsrEotyo8vKs1JLT7EmAz0
	6ERmKdHkfGCKyiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	xrPLnesOLo5mTPxz/+ZNfaY5QZM/VBx8tGTStlDvn5JJSbM0Zgv6NH79Y3V+75vVqTc4NaS3
	fJm05lkXZ/zRrtneQhHRle91LCqtYri3dzf2WfdMKo9qXsNmuOXDMtFF1+4veVJ6Oc2j85AE
	L4vCobviMyQ2Oe1fvDr7+mU50b/vKz6cdi89u1GJpTgj0VCLuag4EQCSofYGRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1286.c |   46 +++++++++-------------------------------------
 1 files changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index d120cb8..398c96a 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -25,8 +25,6 @@
 struct ds1286_priv {
 	struct rtc_device *rtc;
 	u32 __iomem *rtcregs;
-	size_t size;
-	unsigned long baseaddr;
 	spinlock_t lock;
 };
 
@@ -333,56 +331,30 @@ static int ds1286_probe(struct platform_device *pdev)
 	struct rtc_device *rtc;
 	struct resource *res;
 	struct ds1286_priv *priv;
-	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	priv = kzalloc(sizeof(struct ds1286_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct ds1286_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->size = resource_size(res);
-	if (!request_mem_region(res->start, priv->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	priv->baseaddr = res->start;
-	priv->rtcregs = ioremap(priv->baseaddr, priv->size);
-	if (!priv->rtcregs) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv->rtcregs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->rtcregs))
+		return PTR_ERR(priv->rtcregs);
+
 	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
-	rtc = rtc_device_register("ds1286", &pdev->dev,
-				  &ds1286_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	rtc = devm_rtc_device_register(&pdev->dev, "ds1286", &ds1286_ops,
+					THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	priv->rtc = rtc;
 	return 0;
-
-out:
-	if (priv->rtc)
-		rtc_device_unregister(priv->rtc);
-	if (priv->rtcregs)
-		iounmap(priv->rtcregs);
-	if (priv->baseaddr)
-		release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
-	return ret;
 }
 
 static int ds1286_remove(struct platform_device *pdev)
 {
-	struct ds1286_priv *priv = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->rtcregs);
-	release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.2.5


