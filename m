Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbaFQPVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:21:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54921 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755767AbaFQPVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:21:48 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v7 2/2] ARM: vexpress: Add CLCD Device Tree properties
Date: Tue, 17 Jun 2014 16:21:34 +0100
Message-Id: <1403018494-10264-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... for V2M-P1 motherboard CLCD (limited to 640x480 16bpp and using
dedicated video RAM bank) and for V2P-CA9 (up to 1024x768 16bpp).

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi | 34 ++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/vexpress-v2m.dtsi     | 34 ++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts  | 31 ++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
index 756c986..0ac0623 100644
--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -246,9 +246,41 @@
 			clcd@1f0000 {
 				compatible = "arm,pl111", "arm,primecell";
 				reg = <0x1f0000 0x1000>;
+				interrupt-names = "combined";
 				interrupts = <14>;
 				clocks = <&v2m_oscclk1>, <&smbclk>;
 				clock-names = "clcdclk", "apb_pclk";
+				arm,pl11x,framebuffer-base = <0x18000000 0x00800000>;
+				max-memory-bandwidth = <36864000>; /* Bps, 640x480@60 16bpp */
+
+				port {
+					v2m_clcd_pads: endpoint {
+						remote-endpoint = <&v2m_clcd_panel>;
+						arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
+					};
+				};
+
+				panel {
+					compatible = "panel-dpi";
+
+					port {
+						v2m_clcd_panel: endpoint {
+							remote-endpoint = <&v2m_clcd_pads>;
+						};
+					};
+
+					panel-timing {
+						clock-frequency = <25175000>;
+						hactive = <640>;
+						hback-porch = <40>;
+						hfront-porch = <24>;
+						hsync-len = <96>;
+						vactive = <480>;
+						vback-porch = <32>;
+						vfront-porch = <11>;
+						vsync-len = <2>;
+					};
+				};
 			};
 		};
 
@@ -350,7 +382,7 @@
 				/* CLCD clock */
 				compatible = "arm,vexpress-osc";
 				arm,vexpress-sysreg,func = <1 1>;
-				freq-range = <23750000 63500000>;
+				freq-range = <23750000 65000000>;
 				#clock-cells = <0>;
 				clock-output-names = "v2m:oscclk1";
 			};
diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index ba856d6..bbe1858 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -245,9 +245,41 @@
 			clcd@1f000 {
 				compatible = "arm,pl111", "arm,primecell";
 				reg = <0x1f000 0x1000>;
+				interrupt-names = "combined";
 				interrupts = <14>;
 				clocks = <&v2m_oscclk1>, <&smbclk>;
 				clock-names = "clcdclk", "apb_pclk";
+				arm,pl11x,framebuffer-base = <0x4c000000 0x00800000>;
+				max-memory-bandwidth = <36864000>; /* Bps, 640x480@60 16bpp */
+
+				port {
+					v2m_clcd_pads: endpoint {
+						remote-endpoint = <&v2m_clcd_panel>;
+						arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
+					};
+				};
+
+				panel {
+					compatible = "panel-dpi";
+
+					port {
+						v2m_clcd_panel: endpoint {
+							remote-endpoint = <&v2m_clcd_pads>;
+						};
+					};
+
+					panel-timing {
+						clock-frequency = <25175000>;
+						hactive = <640>;
+						hback-porch = <40>;
+						hfront-porch = <24>;
+						hsync-len = <96>;
+						vactive = <480>;
+						vback-porch = <32>;
+						vfront-porch = <11>;
+						vsync-len = <2>;
+					};
+				};
 			};
 		};
 
@@ -349,7 +381,7 @@
 				/* CLCD clock */
 				compatible = "arm,vexpress-osc";
 				arm,vexpress-sysreg,func = <1 1>;
-				freq-range = <23750000 63500000>;
+				freq-range = <23750000 65000000>;
 				#clock-cells = <0>;
 				clock-output-names = "v2m:oscclk1";
 			};
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
index 62d9b22..31107cd 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -70,9 +70,40 @@
 	clcd@10020000 {
 		compatible = "arm,pl111", "arm,primecell";
 		reg = <0x10020000 0x1000>;
+		interrupt-names = "combined";
 		interrupts = <0 44 4>;
 		clocks = <&oscclk1>, <&oscclk2>;
 		clock-names = "clcdclk", "apb_pclk";
+		max-memory-bandwidth = <94371840>; /* Bps, 1024x768@60 16bpp */
+
+		port {
+			clcd_pads: endpoint {
+				remote-endpoint = <&clcd_panel>;
+				arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
+			};
+		};
+
+		panel {
+			compatible = "panel-dpi";
+
+			port {
+				clcd_panel: endpoint {
+					remote-endpoint = <&clcd_pads>;
+				};
+			};
+
+			panel-timing {
+				clock-frequency = <63500127>;
+				hactive = <1024>;
+				hback-porch = <152>;
+				hfront-porch = <48>;
+				hsync-len = <104>;
+				vactive = <768>;
+				vback-porch = <23>;
+				vfront-porch = <3>;
+				vsync-len = <4>;
+			};
+		};
 	};
 
 	memory-controller@100e0000 {
-- 
1.9.1

