Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3CLLo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:44:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39613 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab3CLLoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:21 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 21/24] ARM: dts: OMAP3: Add HS USB Host IP nodes
Date: Tue, 12 Mar 2013 13:43:23 +0200
Message-ID: <1363088606-2692-22-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds device nodes for HS USB Host module, TLL module,
OHCI and EHCI controllers.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3.dtsi |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 1acc261..a14f74b 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -397,5 +397,36 @@
 			ti,timer-alwon;
 			ti,timer-secure;
 		};
+
+		usbhstll: usbhstll@48062000 {
+			compatible = "ti,usbhs-tll";
+			reg = <0x48062000 0x1000>;
+			interrupts = <78>;
+			ti,hwmods = "usb_tll_hs";
+		};
+
+		usbhshost: usbhshost@48064000 {
+			compatible = "ti,usbhs-host";
+			reg = <0x48064000 0x400>;
+			ti,hwmods = "usb_host_hs";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			usbhsohci: ohci@48064400 {
+				compatible = "ti,ohci-omap3", "usb-ohci";
+				reg = <0x48064400 0x400>;
+				interrupt-parent = <&intc>;
+				interrupts = <76>;
+			};
+
+			usbhsehci: ehci@48064800 {
+				compatible = "ti,ehci-omap", "usb-ehci";
+				reg = <0x48064800 0x400>;
+				interrupt-parent = <&intc>;
+				interrupts = <77>;
+			};
+		};
+
 	};
 };
-- 
1.7.4.1

