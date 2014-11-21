Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbaKUNr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:47:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbaKUNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:47:23 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-c2-546f42688a52
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 04/11] dwc3: exynos: Add provision for AXI UpScaler clock on
 exynos7
Date: Fri, 21 Nov 2014 19:05:47 +0530
Message-id: <1416576954-11997-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSp5vhlB9i8OO6icXB+/UW84+cY7Vo
	u3KQ3aJ58Xo2i94FV9ksLjztYbO4vGsOm8XsJf0sFjPO72OyWLSsldmide8RdovDb9pZLSb8
	vsBmsWrXH0YHPo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALYo7hsUlJz
	MstSi/TtErgy9vwuK1gjU7Fo0n3GBsaT4l2MnBwSAiYSd+cfZ4OwxSQu3FsPZHNxCAksZZRY
	+OAwI0zRuwdzWSAS0xkl5jxrg3ImMEnMWb6fHaSKTUBXountLrAOEYHZjBJtB4VAipgF7jFK
	fH7/HaiDg0NYIEzi5hRjkBoWAVWJqfuWsoLYvAIeEqdeH2IEKZEQUJCYM8kGJMwp4CnRsv4y
	E4gtBFSyZtduRpCREgL32CVebmpigpgjIPFt8iEWiF5ZiU0HmCGOlpQ4uOIGywRG4QWMDKsY
	RVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAqPn9L9nE3Yw3jtgfYhRgINRiYf3w/S8ECHWxLLi
	ytxDjKZAGyYyS4km5wNjNK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYwKM7gixH9PSN42JeDAw8uTjjn97EnvTbq8+Wd//+yqo4ovAi5ouU3L4dtu
	ZeV/R3f5993nTWaXf251Fjv6bPX80xIKMv4//xZ5lE08cOaMysGDsUZiknOCE+dq/j5sf+OU
	D3Pvn4VhT5+lzZyfFbTvcIqqrUaqXupKtuxj1UdzKhy+n517TnG1EktxRqKhFnNRcSIA22QK
	kJkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd0Mp/wQg84rWhYH79dbzD9yjtWi
	7cpBdovmxevZLHoXXGWzuPC0h83i8q45bBazl/SzWMw4v4/JYtGyVmaL1r1H2C0Ov2lntZjw
	+wKbxapdfxgd+Dx2zrrL7rFpVSebx/65a9g9Zt/9wejRt2UVo8fxG9uZPD5vkgtgj2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBullJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLHnd1nBGpmKRZPuMzYwnhTvYuTkkBAw
	kXj3YC4LhC0mceHeerYuRi4OIYHpjBJznrWxQDgTmCTmLN/PDlLFJqAr0fR2FyOILSIwm1Gi
	7aAQSBGzwD1Gic/vvwN1cHAIC4RJ3JxiDFLDIqAqMXXfUlYQm1fAQ+LU60OMICUSAgoScybZ
	gIQ5BTwlWtZfZgKxhYBK1uzazTiBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODY
	fCa1g3Flg8UhRgEORiUe3g/T80KEWBPLiitzDzFKcDArifCWC+eHCPGmJFZWpRblxxeV5qQW
	H2I0BTpqIrOUaHI+MG3klcQbGpuYmxqbWppYmJhZKonz3riZGyIkkJ5YkpqdmlqQWgTTx8TB
	KdXA6HHPmLu6VfaH8cMg3gkBL9bPPhZY9rnaLHNZ0Wz3jiVfeauWTkn5ZfSi/ptblXfiSmU+
	I5k55sWrLVoFPErdZhnLrJGcfToz51JDJZNB3cQ5tQwzIyquaPPo/53xwnvD7tzXOs5Vd63X
	NksafVm+5XDmQ9OLx34fOM3Iov+e+26sXlZoj+ZSJZbijERDLeai4kQAzVV+N+MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 controller on Exynos7 SoC has separate control for
AXI UpScaler which connects DWC3 DRD controller to AXI bus.
Get the gate clock for the same to control it across power
cycles.

Suggested-by: Anton Tikhomirov <av.tikhomirov@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 Documentation/devicetree/bindings/usb/exynos-usb.txt |    6 ++++--
 drivers/usb/dwc3/dwc3-exynos.c                       |   17 +++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index a3b5990..9b4dbe3 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -82,8 +82,10 @@ Example:
 
 DWC3
 Required properties:
- - compatible: should be "samsung,exynos5250-dwusb3" for USB 3.0 DWC3
-	       controller.
+ - compatible: should be one of the following -
+	       "samsung,exynos5250-dwusb3": for USB 3.0 DWC3 controller on
+					    Exynos5250/5420.
+	       "samsung,exynos7-dwusb3": for USB 3.0 DWC3 controller on Exynos7.
  - #address-cells, #size-cells : should be '1' if the device has sub-nodes
 				 with 'reg' property.
  - ranges: allows valid 1:1 translation between child's address space and
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index af15ab3..6ae8fe5 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -36,6 +36,7 @@ struct dwc3_exynos {
 
 	struct clk		*clk;
 	struct clk		*susp_clk;
+	struct clk		*axius_clk;
 
 	struct regulator	*vdd33;
 	struct regulator	*vdd10;
@@ -150,6 +151,17 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(exynos->susp_clk);
 
+	if (of_device_is_compatible(node, "samsung,exynos7-dwusb3")) {
+		exynos->axius_clk = devm_clk_get(dev, "usbdrd30_axius_clk");
+		if (IS_ERR(exynos->axius_clk)) {
+			dev_err(dev, "no AXI UpScaler clk specified\n");
+			return -ENODEV;
+		}
+		clk_prepare_enable(exynos->axius_clk);
+	} else {
+		exynos->axius_clk = NULL;
+	}
+
 	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
 	if (IS_ERR(exynos->vdd33)) {
 		ret = PTR_ERR(exynos->vdd33);
@@ -191,6 +203,7 @@ err4:
 err3:
 	regulator_disable(exynos->vdd33);
 err2:
+	clk_disable_unprepare(exynos->axius_clk);
 	clk_disable_unprepare(exynos->susp_clk);
 	clk_disable_unprepare(exynos->clk);
 	return ret;
@@ -204,6 +217,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
+	clk_disable_unprepare(exynos->axius_clk);
 	clk_disable_unprepare(exynos->susp_clk);
 	clk_disable_unprepare(exynos->clk);
 
@@ -216,6 +230,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_dwc3_match[] = {
 	{ .compatible = "samsung,exynos5250-dwusb3" },
+	{ .compatible = "samsung,exynos7-dwusb3" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_dwc3_match);
@@ -226,6 +241,7 @@ static int dwc3_exynos_suspend(struct device *dev)
 {
 	struct dwc3_exynos *exynos = dev_get_drvdata(dev);
 
+	clk_disable(exynos->axius_clk);
 	clk_disable(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
@@ -251,6 +267,7 @@ static int dwc3_exynos_resume(struct device *dev)
 	}
 
 	clk_enable(exynos->clk);
+	clk_enable(exynos->axius_clk);
 
 	/* runtime set active to reflect active state. */
 	pm_runtime_disable(dev);
-- 
1.7.10.4

