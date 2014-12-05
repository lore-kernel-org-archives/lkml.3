Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaLEEMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:12:17 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45520 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933637AbaLEEMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:12:13 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>
Subject: [PATCH v3 5/8] dt-bindings: Add document for MT6397 MFD
Date: Fri, 5 Dec 2014 12:07:56 +0800
Message-ID: <1417752479-4749-6-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 Documentation/devicetree/bindings/mfd/mt6397.txt | 75 ++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/mt6397.txt

diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt
new file mode 100644
index 0000000..64ef408
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/mt6397.txt
@@ -0,0 +1,75 @@
+MediaTek MT6397 Multifunction Device Driver
+
+MT6397 is a multifunction device with the following sub modules:
+- Regulator
+- RTC
+- Audio codec
+- GPIO
+- Clock
+
+It is interfaced to host controller using SPI interface by a proprietary hardware
+called PMIC wrapper or pwrap. MT6397 MFD is a child device of pwrap.
+See the following for pwarp node definitions:
+Documentation/devicetree/bindings/soc/mediatek,mt8135-pwrap.txt
+
+This document describes the binding for mfd device and its sub module.
+
+Required properties:
+compatible: "mediatek,mt6397"
+
+Optional properties:
+- codec: Audio codec
+- pinctrl: GPIO in mt6397
+- rtc: RTC
+- clock: clocks in mt6397
+- regulators: regulators in mt6397
+
+Example:
+	pwrap: pwrap@1000f000 {
+		compatible = "mediatek,mt8135-pwrap";
+		reg = <0 0x1000f000 0 0x1000>,
+			<0 0x11017000 0 0x1000>;
+		reg-names = "pwrap-base", "pwrap-bridge-base";
+		interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>;
+		resets = <&infrarst MT8135_INFRA_PMIC_WRAP_RST>,
+				<&perirst MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
+		reset-names = "infra-pwrap-rst",
+				"peri-pwrap-bridge-rst";
+		clocks = <&pmicspi_sel>, <&clk26m>;
+		clock-names = "pmicspi-sel", "pmicspi-parent";
+
+		pmic {
+			compatible = "mediatek,mt6397";
+
+			codec: mt6397codec {
+				compatible = "mediatek,mt6397-codec";
+			};
+
+			pinctrl@0x0000C000 {
+				compatible = "mediatek,mt6397-pinctrl";
+				reg = <0 0x0000C000 0 0x0108>;
+				gpio-controller;
+			};
+
+			mt6397regulator: mt6397regulator {
+				compatible = "mediatek,mt6397-regulator";
+
+				mt6397_vpca15_reg: buck_vpca15 {
+					regulator-compatible = "buck_vpca15";
+					regulator-name = "vpca15";
+					regulator-min-microvolt = < 850000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-ramp-delay = <12500>;
+					regulator-always-on;
+				};
+
+				mt6397_vgp4_reg: ldo_vgp4 {
+					regulator-compatible = "ldo_vgp4";
+					regulator-name = "vgp4";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-enable-ramp-delay = <218>;
+				};
+			};
+		};
+	};
-- 
1.8.1.1.dirty

