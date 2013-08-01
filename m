Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3HAO7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:59:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44653 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab3HAO7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:59:08 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <rnayak@ti.com>
CC: <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 3/4] dts: dra7-evm: add USB support
Date: Thu, 1 Aug 2013 17:58:53 +0300
Message-ID: <1375369134-26398-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375369134-26398-1-git-send-email-rogerq@ti.com>
References: <1375369134-26398-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB drv_vbus pinctrl information and USB mode
for the USB controller.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index cb0703c..acd3c09 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -18,3 +18,25 @@
 		reg = <0x80000000 0x60000000>; /* 1536 MB */
 	};
 };
+
+&dra7_pmx_core {
+        pinctrl-names = "default";
+        pinctrl-0 = <
+		&usb_pins
+	>;
+
+	usb_pins: pinmux_usb_pins {
+                pinctrl-single,pins = <
+			0x280	0xc0000	/* usb1_drvvbus, SLOW_SLEW | PULLUPEN | MODE0 */
+			0x284	0xc0000 /* usb2_drvvbus, SLOW_SLEW | PULLUPEN | MODE0 */
+                >;
+        };
+};
+
+&dwc3_1 {
+	dr_mode = "otg";
+};
+
+&dwc3_2 {
+	dr_mode = "host";
+};
-- 
1.7.4.1

