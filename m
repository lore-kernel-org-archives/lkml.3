Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3CBNZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30685 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3CBNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:50 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-61-5131fddd9da6
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 09/10] usb: phy: samsung: Add support for PHY ref_clk gpio
Date: Sat, 02 Mar 2013 18:53:10 +0530
Message-id: <1362230590-20960-10-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkWvfuX8NAg8P3RC0O3q+3aF68ns2i
	d8FVNosLT3vYLC7vmsNmMXtJP4vFjPP7mCwWLWtltmg+cYrZgdNj3slAj/1z17B79G1Zxehx
	/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4Mt5NNS54L1vx484mxgbG8xJdjJwcEgImEncPP2GD
	sMUkLtxbD2RzcQgJLGWU2DT1M2sXIwdY0e4ptiA1QgLTGSU+rNGBqJnCJLH+4XwmkASbgK5E
	09tdjCC2iICsxOErv5lBipgFLjFKrFixhQVkkLCAr8TDyXwgNSwCqhLr121gBrF5BTwlVrX+
	ZIc4QkHize1nYHFOoPj065tZIRZ7SPy5d5wdZKaEwCp2iUOHZ7NBDBKQ+Db5EAvEobISmw4w
	Q8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECQ/70v2d9OxhvHrA+
	xJgMNG4is5Rocj4wZvJK4g2NTcxNjU3NjCwtLU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgXFjlanE2ajFxjeiHHKd7T9OP6uQ2KfDXqK2jf2U95pmqc+rpTy0alfLHswS
	ef0qddXjzvKVE6w4Ok3PTS1OafZsmsSlMWMF/4UlLxdMuymiY13J/2XCe58/MlOzRbsdOHRL
	n/7Mfnf27I0PJjOq1n1iVfXWunf8ZuJ2ptxrZfcvcexO0LSLEVZiKc5INNRiLipOBAAHqV6b
	jwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd27fw0DDdbu4rE4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxbqpxwXvZ
	ih93NjE2MJ6X6GLk4JAQMJHYPcW2i5ETyBSTuHBvPRuILSQwnVHiwxqdLkYuIHsKk8T6h/OZ
	QBJsAroSTW93MYLYIgKyEoev/GYGKWIWuMQosWLFFhaQocICvhIPJ/OB1LAIqEqsX7eBGcTm
	FfCUWNX6kx1imYLEm9vPwOKcQPHp1zezQiz2kPhz7zj7BEbeBYwMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCI+qZ9A7GVQ0WhxgFOBiVeHgDPhoECrEmlhVX5h5ilOBgVhLhPX/VMFCI
	NyWxsiq1KD++qDQntfgQYzLQVROZpUST84HRnlcSb2hsYm5qbGppYmFiZkmasJI4L+OpJwFC
	AumJJanZqakFqUUwW5g4OKUaGP39OJYcLSoL6X8kc+eWS5LFxkPH02NbF9Udmv7l85+pIWnf
	H158lHWdO2Ji+8HL4XWiV0zids8wvc98YGqVve2saROTt8p83rSC7WdCZSuvfeFyQ61pIoFz
	vuyzndAZ6bCca3Ncp/adNX2OX2RZWTYVScZxWn279azOJuFdC9+n1fW7lduNLJVYijMSDbWY
	i4oTAWlarBrsAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5250 has external PLL (XusbXTI) for USB 3.0 PHY's
ref_pad_clk. So use this clock based on availability of
gpio to power control this PLL, otherwise use internal
clock only from XXTI.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/samsung-usb3phy.c |   14 ++++++++++----
 drivers/usb/phy/samsung-usbphy.c  |   26 ++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.h  |    1 +
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/phy/samsung-usb3phy.c b/drivers/usb/phy/samsung-usb3phy.c
index 46dd97c..16b024e 100644
--- a/drivers/usb/phy/samsung-usb3phy.c
+++ b/drivers/usb/phy/samsung-usb3phy.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/gpio.h>
 #include <linux/pm_runtime.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
@@ -224,12 +225,17 @@ static int samsung_exynos5_usb3phy_init(struct usb_phy *phy, bool use_ext_clk)
  */
 static int samsung_usb3phy_init(struct usb_phy *phy)
 {
+	struct samsung_usbphy *sphy = phy_to_sphy(phy);
+
 	/*
-	 * We start with using PHY refclk from external PLL,
-	 * once runtime suspend for the device is called this
-	 * will change to internal core clock
+	 * We check if we have a PHY ref_clk gpio available, then only
+	 * use XusbXTI (external PLL); otherwise use internal core clock
+	 * from XXTI.
 	 */
-	return samsung_exynos5_usb3phy_init(phy, true);
+	if (gpio_is_valid(sphy->phyclk_gpio))
+		return samsung_exynos5_usb3phy_init(phy, true);
+	else
+		return samsung_exynos5_usb3phy_init(phy, false);
 }
 
 /*
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index ab4fa11..6968d12 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_gpio.h>
 #include <linux/usb/samsung_usb_phy.h>
 
 #include "samsung-usbphy.h"
@@ -34,6 +35,7 @@
 int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 {
 	struct device_node *usbphy_sys;
+	int ret;
 
 	/* Getting node for system controller interface for usb-phy */
 	usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
@@ -58,6 +60,30 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 	if (sphy->sysreg == NULL)
 		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
 
+	/* Getting PHY clk gpio here to enable/disable PHY clock PLL, if any */
+	sphy->phyclk_gpio = of_get_named_gpio(sphy->dev->of_node,
+						"samsung,phyclk-gpio", 0);
+	/*
+	 * We don't want to return error code here in case we don't get the
+	 * PHY clock gpio, some PHYs may not have it.
+	 */
+	if (gpio_is_valid(sphy->phyclk_gpio)) {
+		ret = gpio_request_one(sphy->phyclk_gpio, GPIOF_INIT_HIGH,
+						"samsung_usb_phy_clock_en");
+		if (ret) {
+			/*
+			 * We don't want to return error code here,
+			 * sometimes either of usb2 phy or usb3 phy may not
+			 * have the PHY clock gpio.
+			 */
+			dev_err(sphy->dev, "can't request phyclk gpio %d\n",
+						sphy->phyclk_gpio);
+			sphy->phyclk_gpio = -EINVAL;
+		}
+	} else {
+		dev_warn(sphy->dev, "Can't get usb-phy clock gpio\n");
+	}
+
 	of_node_put(usbphy_sys);
 
 	return 0;
diff --git a/drivers/usb/phy/samsung-usbphy.h b/drivers/usb/phy/samsung-usbphy.h
index f7e657d..1921ab0 100644
--- a/drivers/usb/phy/samsung-usbphy.h
+++ b/drivers/usb/phy/samsung-usbphy.h
@@ -300,6 +300,7 @@ struct samsung_usbphy {
 	enum samsung_usb_phy_type phy_type;
 	atomic_t	phy_usage;
 	spinlock_t	lock;
+	int		phyclk_gpio;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
-- 
1.7.6.5

