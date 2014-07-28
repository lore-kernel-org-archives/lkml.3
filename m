Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaG1PAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:00:06 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51068 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaG1O5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:55 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 4/7] ARM: dts: vf610: Add usbmisc for non-core registers
Date: Mon, 28 Jul 2014 16:57:30 +0200
Message-Id: <53d894f3fcacd7eddd2ec11d9a67bb9ebafa201a.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for usbmisc which controls the non-core USB
registers. This is required to use the property to disable the over-
current detection.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index f36acb5..a49d739 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -334,11 +334,17 @@
 				interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks VF610_CLK_USBC0>;
 				fsl,usbphy = <&usbphy0>;
+				fsl,usbmisc = <&usbmisc0 0>;
 				dr_mode = "peripheral";
 				status = "disabled";
 			};
 
-
+			usbmisc0: usb@40034800 {
+				#index-cells = <1>;
+				compatible = "fsl,vf610-usbmisc";
+				reg = <0x40034800 0x200>;
+				clocks = <&clks VF610_CLK_USBC0>;
+			};
 		};
 
 		aips1: aips-bus@40080000 {
@@ -407,10 +413,18 @@
 				interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks VF610_CLK_USBC1>;
 				fsl,usbphy = <&usbphy1>;
+				fsl,usbmisc = <&usbmisc1 0>;
 				dr_mode = "host";
 				status = "disabled";
 			};
 
+			usbmisc1: usb@400b4800 {
+				#index-cells = <1>;
+				compatible = "fsl,vf610-usbmisc";
+				reg = <0x400b4800 0x200>;
+				clocks = <&clks VF610_CLK_USBC1>;
+			};
+
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
 				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
-- 
2.0.2

