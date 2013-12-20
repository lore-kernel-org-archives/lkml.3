Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab3LTNZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:25:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:60244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3LTNZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:25:05 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-d6-52b445306af5
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v5 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver with
 the generic phy framework
Date: Fri, 20 Dec 2013 14:24:11 +0100
Message-id: <1387545857-9472-6-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQV0D1y1BBjf2a1os2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4MpY8n0OW8F1iYpb
	r26zNzCuFeli5OSQEDCR2DLjDiOELSZx4d56ti5GLg4hgemMEjc+bGSGcDqYJKbd/QrkcHCw
	CWhKrLrnAdIgIlAjMeXWFXaQGmaBLmaJCdtOs4EkhAWyJDoXP2MGsVkEVCX+b1gAtoFXwFmi
	7dZVFpA5EgIKEnMm2YCEOQVcJGYuXgTWKgRU8vvsI9YJjLwLGBlWMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSH/DOpHYwrGywOMQpwMCrx8DbYbg4SYk0sK67MPcQowcGsJMLbr70lSIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVANj9I/b+XvNX3xd
	NutXeM/9xeudTybE/U1RU2E+6MCZMvP7wmVvmG/r9P5fWDSPZ95v+fVmh4o0DwTWmzy48lxa
	8+yCu1yqKTErVV//0dnvyT3t7LF6k40zrgdM4mk/ZqqqLXNJ41Fvy0I95eNTkhXcezNYPtz2
	3fFk+vRj72wNZJZ/Stb9XWD6RomlOCPRUIu5qDgRABddYtF1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the used phy driver to the new Exynos USB phy driver that uses the
generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
 drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
index b83d428..75edb9d 100644
--- a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
@@ -24,6 +24,8 @@ Required properties:
     - first entry: must be "otg"
 - vusb_d-supply: phandle to voltage regulator of digital section,
 - vusb_a-supply: phandle to voltage regulator of analog section.
+- phys: from general PHY binding: phandle to the PHY device
+- phy-names: from general PHY binding: should be "usb2-phy"
 
 Example
 -----
@@ -36,5 +38,7 @@ Example
 		clock-names = "otg";
 		vusb_d-supply = <&vusb_reg>;
 		vusb_a-supply = <&vusbdac_reg>;
+		phys = <&usb2phy 0>;
+		phy-names = "usb2-phy";
 	};
 
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 7aedaaf..a05c2f9 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -162,7 +163,7 @@ struct s3c_hsotg_ep {
 struct s3c_hsotg {
 	struct device		 *dev;
 	struct usb_gadget_driver *driver;
-	struct usb_phy		*phy;
+	struct phy		 *phy;
 	struct s3c_hsotg_plat	 *plat;
 
 	spinlock_t              lock;
@@ -2910,7 +2911,7 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
 	if (hsotg->phy)
-		usb_phy_init(hsotg->phy);
+		phy_power_on(hsotg->phy);
 	else if (hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 }
@@ -2927,7 +2928,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
 	if (hsotg->phy)
-		usb_phy_shutdown(hsotg->phy);
+		phy_power_off(hsotg->phy);
 	else if (hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 }
@@ -3534,7 +3535,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
 static int s3c_hsotg_probe(struct platform_device *pdev)
 {
 	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
-	struct usb_phy *phy;
+	struct phy *phy;
 	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
 	struct s3c_hsotg *hsotg;
@@ -3549,7 +3550,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	phy = devm_phy_get(&pdev->dev, "usb2-phy");
 	if (IS_ERR(phy)) {
 		/* Fallback for pdata */
 		plat = dev_get_platdata(&pdev->dev);
-- 
1.7.9.5

