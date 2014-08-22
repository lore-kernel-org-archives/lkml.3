Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaHVQ76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:59:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32899 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901AbaHVQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:59:55 -0400
X-AuditID: cbfee61a-f79e46d00000134f-07-53f77709403a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 2/5] ARM: dts: remove old USB2 PHY node for Exynos5250
Date: Fri, 22 Aug 2014 18:59:02 +0200
Message-id: <1408726745-31135-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jAV3O8u/BBvdumFtsnLGe1eLg/XqL
	Tdevs1q0XTnIbvHj9QU2i94FV9ksLjztYbM42/SG3eLyrjlsFjPO72OyWLSsldmB2+POtT1s
	Hn1bVjF6HL+xncnj8ya5AJYoLpuU1JzMstQifbsErozPRzewFjziqmj5/oitgfEnRxcjJ4eE
	gInE1OZuZghbTOLCvfVsXYxcHEICixglNtxtZYdwupgkZj+9yAJSxSZgJTGxfRUjiC0ioCbR
	s3grI0gRs8B9JonND0+zgiSEBTwlXrz+zwRiswioSszathCsmVfAQ+LzgomsEOsUJbqfTQBa
	x8HBCVR//agOiCkEVHJ5afQERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYID7pnU
	DsaVDRaHGAU4GJV4eA08vgcLsSaWFVfmHmKU4GBWEuGVLgQK8aYkVlalFuXHF5XmpBYfYpTm
	YFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYDQTZJxb3jjf/DrPwmNfl7MZfWLVexw0cdZy
	F80jj0V+GtekzhX92vHEotHV9OQOi3ecHSr3l0ozrvr5O7Bzzq3f+148ueb13t0m5LL55B+h
	52LOav4WNckqMN8q9rIsIYLj0VbDMl/7rrdV9mHngusP2XpemWJZbbj//Mnb69+nHnIwE5U+
	4KHEUpyRaKjFXFScCAAJ4K+RNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb2 driver got replaced by
drivers/phy/phy-samsung-usb2 one.  Remove the leftover
USB2 PHY node (EHCI/OHCI USB nodes are using the new one
already) from Exynos5250 dtsi file.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
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

