Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbbATKgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:36:01 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60499 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbATKf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:35:59 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tobias Jakobi <liquid.acid@gmx.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/2] ARM: dts: Add DISP1 power domain for exynos5420
Date: Tue, 20 Jan 2015 11:35:27 +0100
Message-Id: <1421750127-22536-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DISP1 power domain on Exynos5420 SoC includes the FIMD1, MIXER
and HDMI modules. Add a device node for this power domain and mark
these modules as consumer of the DISP1 power domain.

When a power domain is powered on and off, the input clocks of the
devices attached to it are reparented. So a reference to the input
and parent clocks of the devices are needed to manage that.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e5cb74d2b9f5..9dc2e9773b30 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -274,6 +274,20 @@
 		#power-domain-cells = <0>;
 	};
 
+	disp_pd: power-domain@100440C0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x100440C0 0x20>;
+		#power-domain-cells = <0>;
+		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK200>,
+			 <&clock CLK_MOUT_USER_ACLK200_DISP1>,
+			 <&clock CLK_MOUT_SW_ACLK300>,
+			 <&clock CLK_MOUT_USER_ACLK300_DISP1>,
+			 <&clock CLK_MOUT_SW_ACLK400>,
+			 <&clock CLK_MOUT_USER_ACLK400_DISP1>;
+		clock-names = "oscclk", "pclk0", "clk0",
+			      "pclk1", "clk1", "pclk2", "clk2";
+	};
+
 	pinctrl_0: pinctrl@13400000 {
 		compatible = "samsung,exynos5420-pinctrl";
 		reg = <0x13400000 0x1000>;
@@ -541,6 +555,7 @@
 	fimd: fimd@14400000 {
 		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
 		clock-names = "sclk_fimd", "fimd";
+		power-domains = <&disp_pd>;
 	};
 
 	adc: adc@12D10000 {
@@ -714,6 +729,7 @@
 		phy = <&hdmiphy>;
 		samsung,syscon-phandle = <&pmu_system_controller>;
 		status = "disabled";
+		power-domains = <&disp_pd>;
 	};
 
 	hdmiphy: hdmiphy@145D0000 {
@@ -726,6 +742,7 @@
 		interrupts = <0 94 0>;
 		clocks = <&clock CLK_MIXER>, <&clock CLK_SCLK_HDMI>;
 		clock-names = "mixer", "sclk_hdmi";
+		power-domains = <&disp_pd>;
 	};
 
 	gsc_0: video-scaler@13e00000 {
-- 
2.1.3

