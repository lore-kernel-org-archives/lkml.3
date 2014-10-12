Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaJLUEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:04:37 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47204 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaJLUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:04:19 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 3/3] ARM: dts: meson: add dts nodes for IR receiver
Date: Sun, 12 Oct 2014 22:01:55 +0200
Message-Id: <1413144115-23188-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413144115-23188-1-git-send-email-b.galvani@gmail.com>
References: <1413144115-23188-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson.dtsi           | 7 +++++++
 arch/arm/boot/dts/meson8-vega-s89e.dts | 6 ++++++
 arch/arm/boot/dts/meson8.dtsi          | 7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index 7d27f12..a14461c 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -108,5 +108,12 @@
 			clocks = <&clk81>;
 			status = "disabled";
 		};
+
+		ir_receiver: ir-receiver@c8100480 {
+			compatible= "amlogic,meson6-ir";
+			reg = <0xc8100480 0x20>;
+			interrupts = <0 15 1>;
+			status = "disabled";
+		};
 	};
 }; /* end of / */
diff --git a/arch/arm/boot/dts/meson8-vega-s89e.dts b/arch/arm/boot/dts/meson8-vega-s89e.dts
index 70a05c1..5ea54c8 100644
--- a/arch/arm/boot/dts/meson8-vega-s89e.dts
+++ b/arch/arm/boot/dts/meson8-vega-s89e.dts
@@ -77,3 +77,9 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart_ao_a>;
 };
+
+&ir_receiver {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&ir_pins>;
+};
diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
index 59c3af0..ea98ed3 100644
--- a/arch/arm/boot/dts/meson8.dtsi
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -122,6 +122,13 @@
 				function = "uart_ao";
 			};
 		};
+
+		ir_pins: ir_pins {
+			ir_pins {
+				pins = "remote_input";
+				function = "remote";
+			};
+		};
 	};
 
 }; /* end of / */
-- 
1.9.1

