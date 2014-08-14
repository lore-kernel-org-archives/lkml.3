Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaHNO0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:26:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55880 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaHNO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:26:31 -0400
X-AuditID: cbfee61b-f79f86d00000144c-fe-53ecc6f341f5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 2/5] ARM: dts: remove old USB2 PHY node for Exynos5250
Date: Thu, 14 Aug 2014 16:25:24 +0200
Message-id: <1408026327-31437-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd3Px94EG3xZZmmxccZ6VouD9+st
	Nl2/zmrRduUgu8WP1xfYLHoXXGWzuPC0h83ibNMbdovLu+awWcw4v4/JYtGyVmYHbo871/aw
	efRtWcXocfzGdiaPz5vkAliiuGxSUnMyy1KL9O0SuDJa539hLfjBWfFu5nLWBsbZHF2MnBwS
	AiYSy66fZ4SwxSQu3FvP1sXIxSEkMJ1R4vH/fiini0ni6vouVpAqNgEriYntq8A6RATUJHoW
	b2UEKWIWuM8ksfnhabAiYQE3iS9nG1hAbBYBVYn3y3vBbF4BD4kLV49CrVOU6H42gQ3E5hTw
	lDg8ZxkziC0EVHPw8C72CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB90z6R2M
	qxosDjEKcDAq8fA2bH8TLMSaWFZcmXuIUYKDWUmEd/puoBBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQZGE4YHCzoO+P+ZMbu510ObM9MyKTaMUXGaO+ui
	/daSL6aKvbyzu28j+/dzs4PT9qpn8Px9HlHH6lD+54JOwatttgstRA12yhlN7FZ2vq354GW9
	T9VN+8k7hNwmbl+7+tSzI3wSnFyn9iZ1H30il35IeE6TwDev6tjKmx9kr7IeUF/xJZb9e5+M
	EktxRqKhFnNRcSIAVvoVoDYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb2 driver got replaced by
drivers/phy/phy-samsung-usb2 one.  Remove the leftover
USB2 PHY node (EHCI/OHCI USB nodes are using the new one
already) from Exynos5250 dtsi file.

Cc: Mark Brown <broonie@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 492e1ef..f21b9aa 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -603,21 +603,6 @@
 		};
 	};
 
-	usb2_phy: usbphy@12130000 {
-		compatible = "samsung,exynos5250-usb2phy";
-		reg = <0x12130000 0x100>;
-		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_USB2>;
-		clock-names = "ext_xtal", "usbhost";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		usbphy-sys {
-			reg = <0x10040704 0x8>,
-			      <0x10050230 0x4>;
-		};
-	};
-
 	usb2_phy_gen: phy@12130000 {
 		compatible = "samsung,exynos5250-usb2-phy";
 		reg = <0x12130000 0x100>;
-- 
1.8.2.3

