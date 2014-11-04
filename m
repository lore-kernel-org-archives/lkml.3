Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaKDFau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:30:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:35758 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbaKDFaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:30:46 -0500
X-Listener-Flag: 11101
From: Xudong Chen <xudong.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>, <arm@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: [PATCH v2 2/3] ARM: mediatek: Add I2C node for mt8135 and mt8127
Date: Tue, 4 Nov 2014 13:29:36 +0800
Message-ID: <1415078977-18374-3-git-send-email-xudong.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415078977-18374-1-git-send-email-xudong.chen@mediatek.com>
References: <1415078977-18374-1-git-send-email-xudong.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C node to mt8135.dtsi and mt8127.dtsi

Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
---
 arch/arm/boot/dts/mt8127.dtsi | 27 +++++++++++++
 arch/arm/boot/dts/mt8135.dtsi | 90 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/arch/arm/boot/dts/mt8127.dtsi b/arch/arm/boot/dts/mt8127.dtsi
index 25c9f69..60d7685e 100644
--- a/arch/arm/boot/dts/mt8127.dtsi
+++ b/arch/arm/boot/dts/mt8127.dtsi
@@ -89,5 +89,32 @@
 			      <0 0x10214000 0 0x2000>,
 			      <0 0x10216000 0 0x2000>;
 		};
+
+		i2c0: i2c@11007000 {
+			compatible = "mediatek,mt8127-i2c",
+				"mediatek,mt6577-i2c";
+			reg = <0 0x11007000 0 0x70>,
+				<0 0x11000200 0 0x80>;
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_LOW>;
+			mediatek,have-dcm;
+		};
+
+		i2c1: i2c@11008000 {
+			compatible = "mediatek,mt8127-i2c",
+				"mediatek,mt6577-i2c";
+			reg = <0 0x11008000 0 0x70>,
+				<0 0x11000280 0 0x80>;
+			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_LOW>;
+			mediatek,have-dcm;
+		};
+
+		i2c2: i2c@11009000 {
+			compatible = "mediatek,mt8127-i2c",
+				"mediatek,mt6577-i2c";
+			reg = <0 0x11009000 0 0x70>,
+				<0 0x11000300 0 0x80>;
+			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_LOW>;
+			mediatek,have-dcm;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index 221ce09..cb32350 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -119,7 +119,97 @@
 			      <0 0x1020C000 0 0x1000>;
 			gpio-controller;
 			#gpio-cells = <2>;
+
+			i2c0_pins_a: i2c0@0 {
+				mediatek,pins = <MT8135_PIN_100_SDA0__FUNC_SDA0 &pcfg_pull_none>,
+						<MT8135_PIN_101_SCL0__FUNC_SCL0 &pcfg_pull_none>;
+			};
+
+			i2c1_pins_a: i2c1@0 {
+				mediatek,pins = <MT8135_PIN_195_SDA1__FUNC_SDA1 &pcfg_pull_none>,
+						<MT8135_PIN_196_SCL1__FUNC_SCL1 &pcfg_pull_none>;
+			};
+
+			i2c2_pins_a: i2c2@0 {
+				mediatek,pins = <MT8135_PIN_193_SDA2__FUNC_SDA2 &pcfg_pull_none>,
+						<MT8135_PIN_194_SCL2__FUNC_SCL2 &pcfg_pull_none>;
+			};
+
+			i2c3_pins_a: i2c3@0 {
+				mediatek,pins = <MT8135_PIN_35_SCL3__FUNC_SCL3 &pcfg_pull_none>,
+						<MT8135_PIN_36_SDA3__FUNC_SDA3 &pcfg_pull_none>;
+			};
+
+			i2c4_pins_a: i2c4@0 {
+				mediatek,pins = <MT8135_PIN_87_MSDC1_DAT2__FUNC_SCL4 &pcfg_pull_none>,
+						<MT8135_PIN_88_MSDC1_DAT3__FUNC_SDA4 &pcfg_pull_none>;
+			};
+
+			i2c5_pins_a: i2c5@0 {
+				mediatek,pins = <MT8135_PIN_63_MSDC1_INSI__FUNC_SCL5 &pcfg_pull_none>,
+						<MT8135_PIN_64_MSDC1_SDWPI__FUNC_SDA5 &pcfg_pull_none>;
+			};
+
+			i2c6_pins_a: i2c6@0 {
+				mediatek,pins = <MT8135_PIN_197_MSDC3_DAT2__FUNC_SCL6 &pcfg_pull_none>,
+						<MT8135_PIN_198_MSDC3_DAT3__FUNC_SDA6 &pcfg_pull_none>;
+			};
 		};
 
+		i2c0: i2c@1100d000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x1100d000 0 0x70>,
+				<0 0x11000300 0 0x80>;
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c1: i2c@1100e000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x1100e000 0 0x70>,
+				<0 0x11000380 0 0x80>;
+			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c2: i2c@1100f000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x1100f000 0 0x70>,
+				<0 0x11000400 0 0x80>;
+			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c3: i2c@11010000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x11010000 0 0x70>,
+				<0 0x11000480 0 0x80>;
+			interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c4: i2c@11011000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x11011000 0 0x70>,
+				<0 0x11000500 0 0x80>;
+			interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c5: i2c@11012000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x11012000 0 0x70>,
+				<0 0x11000580 0 0x80>;
+			interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_LOW>;
+		};
+
+		i2c6: i2c@11013000 {
+			compatible = "mediatek,mt8135-i2c",
+				"mediatek,mt6589-i2c";
+			reg = <0 0x11013000 0 0x70>,
+				<0 0x11000600 0 0x80>;
+			interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_LOW>;
+		};
 	};
 };
-- 
1.8.1.1.dirty

