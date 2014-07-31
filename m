Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaGaUwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:52:10 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:44905 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaGaUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:52:06 -0400
From: Kever Yang <kever.yang@gmail.com>
X-Google-Original-From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, wulf@rock-chips.com, lyz@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] ARM: dts: add rk3288 dwc2 controller support
Date: Thu, 31 Jul 2014 13:51:44 -0700
Message-Id: <1406839906-14633-4-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406839906-14633-1-git-send-email-kever.yang@rock-chips.com>
References: <1406839906-14633-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 has two kind of usb controller, this add the dwc2 controller
for otg and host1.

Controller can works with usb PHY default setting and Vbus on.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v3:
- Moved out of pin control and sort by base address

Changes in v2:
- change the node name from 'dwc2' to 'usb'

 arch/arm/boot/dts/rk3288.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index ab8a611..a5607a1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -205,6 +205,26 @@
 		status = "disabled";
 	};
 
+	usb_host1: usb@ff540000 {
+		compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
+				"snps,dwc2";
+		reg = <0xff540000 0x40000>;
+		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_USBHOST1>;
+		clock-names = "otg";
+		status = "disabled";
+	};
+
+	usb_otg: usb@ff580000 {
+		compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
+				"snps,dwc2";
+		reg = <0xff580000 0x40000>;
+		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_OTG0>;
+		clock-names = "otg";
+		status = "disabled";
+	};
+
 	uart2: serial@ff690000 {
 		compatible = "rockchip,rk3288-uart", "snps,dw-apb-uart";
 		reg = <0xff690000 0x100>;
-- 
1.7.9.5

