Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3COPRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:17:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50696 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3COPRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:17:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>, =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>
Subject: [PATCH v2 20/23] ARM: dts: OMAP4: Add HS USB Host IP nodes
Date: Fri, 15 Mar 2013 17:16:41 +0200
Message-ID: <1363360604-21368-21-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds device nodes for HS USB Host module, TLL module,
OHCI and EHCI controllers.

CC: Benoît Cousson <b-cousson@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 739bb79..b7db1a2 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -529,5 +529,35 @@
 			ti,hwmods = "timer11";
 			ti,timer-pwm;
 		};
+
+		usbhstll: usbhstll@4a062000 {
+			compatible = "ti,usbhs-tll";
+			reg = <0x4a062000 0x1000>;
+			interrupts = <0 78 0x4>;
+			ti,hwmods = "usb_tll_hs";
+		};
+
+		usbhshost: usbhshost@4a064000 {
+			compatible = "ti,usbhs-host";
+			reg = <0x4a064000 0x800>;
+			ti,hwmods = "usb_host_hs";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			usbhsohci: ohci@4a064800 {
+				compatible = "ti,ohci-omap3", "usb-ohci";
+				reg = <0x4a064800 0x400>;
+				interrupt-parent = <&gic>;
+				interrupts = <0 76 0x4>;
+			};
+
+			usbhsehci: ehci@4a064c00 {
+				compatible = "ti,ehci-omap", "usb-ehci";
+				reg = <0x4a064c00 0x400>;
+				interrupt-parent = <&gic>;
+				interrupts = <0 77 0x4>;
+			};
+		};
 	};
 };
-- 
1.7.4.1

