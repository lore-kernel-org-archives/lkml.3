Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaG3UBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:01:05 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:46485 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaG3UAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:00:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ARM: dts: add rk3288 ehci usb devices
Date: Wed, 30 Jul 2014 13:00:11 -0700
Message-Id: <1406750412-15592-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406750412-15592-1-git-send-email-dianders@chromium.org>
References: <1406750412-15592-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kever Yang <kever.yang@rock-chips.com>

rk3288 has two kind of usb controller; this adds the ehci variant for
host0 and hsic.

At the moment we don't add any phys for these controllers, but the
default settings seem to work OK.

There is a hardware problem in ohci controller which make it
unavailable and host0 controller can only support high-speed devices.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Kever is now the author
- Node is now named usb

 arch/arm/boot/dts/rk3288.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 3ef8951..e7cb008 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -251,6 +251,26 @@
 		status = "disabled";
 	};
 
+	usb_host0_ehci: usb@ff500000 {
+		compatible = "generic-ehci";
+		reg = <0xff500000 0x100>;
+		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_USBHOST0>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
+	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
+
+	usb_hsic: usb@ff5c0000 {
+		compatible = "generic-ehci";
+		reg = <0xff5c0000 0x100>;
+		interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_HSIC>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
 	gic: interrupt-controller@ffc01000 {
 		compatible = "arm,gic-400";
 		interrupt-controller;
-- 
2.0.0.526.g5318336

