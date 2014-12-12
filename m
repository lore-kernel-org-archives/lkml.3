Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbaLLPMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:12:52 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:51461 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbaLLPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:12:51 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <ca5c859e38bcddf6c7f02f823df3a990>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, jwerner@chromium.org,
        dianders@chromium.org, olof@lixom.net, huangtao@rock-chips.com,
        zyw@rock-chips.com, cf@rock-chips.com
Cc: Yunzhi Li <lyz@rock-chips.com>
Subject: [PATCH v7 4/5] ARM: dts: rockchip: add rk3288 usb PHY
Date: Fri, 12 Dec 2014 23:12:21 +0800
Message-Id: <1418397141-1079-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a device_node for RK3288 SoC usb phy. It also
defines the phy to be used by three usb controllers: usb_host0/1
and usb_otg.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>

---

Changes in v7:
- Update dtsi for new usb phy driver.

Changes in v6: None
Changes in v5:
- reorder the phy dt node to a correct position.

Changes in v4:
- Add phy subnodes.

Changes in v3: None

 arch/arm/boot/dts/rk3288.dtsi | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..2a9a029 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -335,6 +335,8 @@
 		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_USBHOST0>;
 		clock-names = "usbhost";
+		phys = <&usbphy1>;
+		phy-names = "usb";
 		status = "disabled";
 	};
 
@@ -347,6 +349,8 @@
 		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_USBHOST1>;
 		clock-names = "otg";
+		phys = <&usbphy2>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
@@ -357,6 +361,8 @@
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_OTG0>;
 		clock-names = "otg";
+		phys = <&usbphy0>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
@@ -497,6 +503,35 @@
 		interrupts = <GIC_PPI 9 0xf04>;
 	};
 
+	usbphy: phy {
+		compatible = "rockchip,rk3288-usb-phy";
+		rockchip,grf = <&grf>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "disabled";
+
+		usbphy0: usb-phy0 {
+			#phy-cells = <0>;
+			reg = <0x320>;
+			clocks = <&cru SCLK_OTGPHY0>;
+			clock-names = "phyclk";
+		};
+
+		usbphy1: usb-phy1 {
+			#phy-cells = <0>;
+			reg = <0x334>;
+			clocks = <&cru SCLK_OTGPHY1>;
+			clock-names = "phyclk";
+		};
+
+		usbphy2: usb-phy2 {
+			#phy-cells = <0>;
+			reg = <0x348>;
+			clocks = <&cru SCLK_OTGPHY2>;
+			clock-names = "phyclk";
+		};
+	};
+
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3288-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.0.0


