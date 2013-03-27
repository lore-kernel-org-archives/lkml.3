Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3C0HoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:44:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60885 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3C0HoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:44:13 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 3/3] ARM: davinci: da850 evm: Add da850-evm LCD panel support
Date: Wed, 27 Mar 2013 13:13:59 +0530
Message-ID: <1364370239-18390-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
References: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update LCDC node with panel timings for da850-evm along pin-mux info.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index cae024b..33d024e 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -50,6 +50,28 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&ehrpwm1_pins>;
 		};
+
+		lcdc: lcdc@01e13000 {
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&lcdc_pins>;
+
+			display-timings {
+				480x272p62 {
+					clock-frequency = <7833600>;
+					hactive = <480>;
+					vactive = <272>;
+					hfront-porch = <2>;
+					hback-porch = <2>;
+					hsync-len = <41>;
+					vback-porch = <2>;
+					vfront-porch = <2>;
+					vsync-len = <10>;
+					hsync-active = <1>;
+					vsync-active = <1>;
+				};
+			};
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
-- 
1.7.9.5

