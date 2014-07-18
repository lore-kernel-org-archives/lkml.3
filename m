Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965950AbaGRRB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:01:57 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:38383 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965884AbaGRRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:01:54 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 3/6] ARM: dts: vf610: Add usbmisc for non-core registers
Date: Fri, 18 Jul 2014 19:01:39 +0200
Message-Id: <4b3b16a8de1bd916d51c951aca286616f7ec8a9d.1405702442.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405702442.git.stefan@agner.ch>
References: <cover.1405702442.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for usbmisc which controls the non-core USB
registers. This is required to use the property to disable the over-
current detection.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index f6c3f02..b20ce4f 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -334,11 +334,19 @@
 				interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks VF610_CLK_USBC0>;
 				fsl,usbphy = <&usbphy0>;
+				fsl,usbmisc = <&usbmisc 0>;
 				dr_mode = "peripheral";
 				status = "disabled";
 			};
 
-
+			usbmisc: usb@40034800 {
+				#index-cells = <1>;
+				compatible = "fsl,vf610-usbmisc";
+				reg = <0x40034800 0x200>,
+					<0x400b4800 0x200>;
+				clocks = <&clks VF610_CLK_USBC0>,
+					<&clks VF610_CLK_USBC1>;
+			};
 		};
 
 		aips1: aips-bus@40080000 {
@@ -407,6 +415,7 @@
 				interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks VF610_CLK_USBC1>;
 				fsl,usbphy = <&usbphy1>;
+				fsl,usbmisc = <&usbmisc 1>;
 				dr_mode = "host";
 				status = "disabled";
 			};
-- 
2.0.1

