Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaLICxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:53:05 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:59765 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaLICxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:53:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <afa30ab110be4c5de902b40b7c08ed78>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yunzhi Li <lyz@rock-chips.com>
Subject: [PATCH v4 4/5] ARM: dts: add rk3288 usb PHY
Date: Tue,  9 Dec 2014 10:52:34 +0800
Message-Id: <1418093554-30671-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a device_node for RK3288 SoC usb phy. It also
defines the phy to be used by three usb controllers: usb_host0/1
and usb_otg.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>

---

Changes in v4:
- Add phy subnodes.

Changes in v3: None

 arch/arm/boot/dts/rk3288.dtsi | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..2db2d12 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -329,12 +329,35 @@
 		status = "disabled";
 	};
 
+	usbphy: phy {
+		#phy-cells = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "rockchip,rk3288-usb-phy";
+		rockchip,grf = <&grf>;
+		status = "disabled";
+
+		usb-phy@0 {
+			reg = <0>;
+		};
+
+		usb-phy@1 {
+			reg = <1>;
+		};
+
+		usb-phy@2 {
+			reg = <2>;
+		};
+	};
+
 	usb_host0_ehci: usb@ff500000 {
 		compatible = "generic-ehci";
 		reg = <0xff500000 0x100>;
 		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_USBHOST0>;
 		clock-names = "usbhost";
+		phys = <&usbphy 1>;
+		phy-names = "usb";
 		status = "disabled";
 	};
 
@@ -347,6 +370,8 @@
 		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_USBHOST1>;
 		clock-names = "otg";
+		phys = <&usbphy 2>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
@@ -357,6 +382,8 @@
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_OTG0>;
 		clock-names = "otg";
+		phys = <&usbphy 0>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
-- 
2.0.0


