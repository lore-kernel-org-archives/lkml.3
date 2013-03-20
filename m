Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab3CTPp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:45:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50604 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317Ab3CTPp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:45:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>
Subject: [PATCH v4 20/21] ARM: dts: OMAP3: Add HS USB Host IP nodes
Date: Wed, 20 Mar 2013 17:44:59 +0200
Message-ID: <1363794300-31526-21-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363794300-31526-1-git-send-email-rogerq@ti.com>
References: <1363794300-31526-1-git-send-email-rogerq@ti.com>
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

