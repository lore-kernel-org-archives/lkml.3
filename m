Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaCGNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:09:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaCGNJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:09:56 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 6/8] ARM: dts: omap4+: Add clocks to USB2 PHY node
Date: Fri, 7 Mar 2014 15:09:09 +0200
Message-ID: <1394197751-28984-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB2 PHY driver expects named clocks for wakeup clock
and reference clock. Provide this information for USB2 PHY
nodes in OMAP4 and OMAP5 SoC DTS.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi | 2 ++
 arch/arm/boot/dts/omap5.dtsi | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 4e15be5..2f6cfa6 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -608,6 +608,8 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a0ad080 0x58>;
 				ctrl-module = <&omap_control_usb2phy>;
+				clocks = <&usb_phy_cm_clk32k>;
+				clock-names = "wkupclk";
 				#phy-cells = <0>;
 			};
 		};
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 521caab..bf629bb 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -769,6 +769,8 @@
 				compatible = "ti,omap-usb2";
 				reg = <0x4a084000 0x7c>;
 				ctrl-module = <&omap_control_usb2phy>;
+				clocks = <&usb_phy_cm_clk32k>, <&usb_otg_ss_refclk960m>;
+				clock-names = "wkupclk", "refclk";
 				#phy-cells = <0>;
 			};
 
-- 
1.8.3.2

