Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaHHD6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:58:45 -0400
Received: from mail-pd0-f196.google.com ([209.85.192.196]:54694 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaHHD6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:58:42 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, heiko@sntech.de
Cc: dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        wulf@rock-chips.com, lyz@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] ARM: dts: add rk3288 dwc2 controller support
Date: Fri,  8 Aug 2014 11:55:58 +0800
Message-Id: <1407470159-14722-4-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
References: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk3288 has two kind of usb controller, this add the dwc2 controller
for otg and host1.

Controller can works with usb PHY default setting and Vbus on.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---

Changes in v5:
- change the sort order of dwc2 in rk3288.dtsi

Changes in v4: None
Changes in v3:
- EHCI and HSIC move new for version 3.

Changes in v2: None

 arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5950b0a..58167f1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -206,6 +206,26 @@
 
 	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
 
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
 	usb_hsic: usb@ff5c0000 {
 		compatible = "generic-ehci";
 		reg = <0xff5c0000 0x100>;
-- 
1.9.1

