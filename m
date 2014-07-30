Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaG3BfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:35:14 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:59261 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaG3BfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:35:09 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <87d1d6be48b92bb07edd083f51e2cc7e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        paulz@synopsys.com, gregkh@linuxfoundation.org, mporter@linaro.org,
        kishon@ti.com, balbi@ti.com
Cc: swarren@wwwdotorg.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kever.yang@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        cf@rock-chips.com, lyz@rock-chips.com, wulf@rock-chips.com,
        dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org
Subject: [PATCH 2/4] ARM: dts: add rk3288 dwc2 controller support
Date: Tue, 29 Jul 2014 18:34:35 -0700
Message-Id: <1406684075-18271-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
References: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 has two kind of usb controller, this add the dwc2 controller
for otg and host1.

Controller can works with usb PHY default setting and Vbus on.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index abc51f5..4309c4f 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -646,5 +646,25 @@
 			clock-names = "baudclk", "apb_pclk";
 			status = "disabled";
 		};
+
+		usb_otg: dwc2@ff580000 {
+			compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
+					"snps,dwc2";
+			reg = <0xff580000 0x40000>;
+			interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cru HCLK_OTG0>;
+			clock-names = "otg";
+			status = "disabled";
+		};
+
+		usb_host1: dwc2@ff540000 {
+			compatible = "rockchip,rk3288-usb", "rockchip,rk3066-usb",
+					"snps,dwc2";
+			reg = <0xff540000 0x40000>;
+			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cru HCLK_USBHOST1>;
+			clock-names = "otg";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5


