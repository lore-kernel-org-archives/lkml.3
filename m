Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaLHJrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:47:12 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:33717 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaLHJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:47:08 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <9e9158ef67259e1b1a6d2dc1e693c794>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Yunzhi Li <lyz@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, romain.perier@gmail.com
Cc: olof@lixom.net, huangtao@rock-chips.com, zyw@rock-chips.com,
        cf@rock-chips.com, linux-rockchip@lists.infradead.org,
        Yunzhi Li <lyz@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] ARM: dts: add rk3288 usb PHY
Date: Mon,  8 Dec 2014 17:46:27 +0800
Message-Id: <1418031988-2700-5-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
References: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a device_node for RK3288 SoC usb phy. It also
defines the phy to be used by three usb controllers: usb_host0/1
and usb_otg.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>

---

Changes in v3:
- Add more context about the changes in the long description.

 arch/arm/boot/dts/rk3288.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..a663c4c 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -329,12 +329,21 @@
 		status = "disabled";
 	};
 
+	usbphy: phy {
+		#phy-cells = <1>;
+		compatible = "rockchip,rk3288-usb-phy";
+		rockchip,grf = <&grf>;
+		status = "disabled";
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
 
@@ -347,6 +356,8 @@
 		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_USBHOST1>;
 		clock-names = "otg";
+		phys = <&usbphy 2>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
@@ -357,6 +368,8 @@
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_OTG0>;
 		clock-names = "otg";
+		phys = <&usbphy 0>;
+		phy-names = "usb2-phy";
 		status = "disabled";
 	};
 
-- 
2.0.0


