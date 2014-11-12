Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaKLWMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:12:06 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43712 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaKLWLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:11:12 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        gta04-owner@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 3/5] arm: dts: omap3-gta04: Add handling for tv output
Date: Wed, 12 Nov 2014 23:10:45 +0100
Message-Id: <1415830247-31633-4-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415830247-31633-1-git-send-email-marek@goldelico.com>
References: <1415830247-31633-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add handling for gta04 tv out chain:
venc -> opa362 -> svideo

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 48 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index fd34f91..b50dc10 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -83,6 +83,41 @@
 		compatible = "usb-nop-xceiv";
 		reset-gpios = <&gpio6 14 GPIO_ACTIVE_LOW>;
 	};
+
+	tv0: connector@1 {
+		compatible = "svideo-connector";
+		label = "tv";
+
+		port {
+			tv_connector_in: endpoint {
+				remote-endpoint = <&opa_out>;
+			};
+		};
+	};
+
+	tv_amp: opa362 {
+		compatible = "ti,opa362";
+		gpios = <&gpio1 23 0>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				opa_in: endpoint@0 {
+					remote-endpoint = <&venc_out>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				opa_out: endpoint@0 {
+					remote-endpoint = <&tv_connector_in>;
+				};
+			};
+		};
+	};
 };
 
 &omap3_pmx_core {
@@ -396,6 +431,19 @@
 	};
 };
 
+&venc {
+	status = "okay";
+
+	vdda-supply = <&vdac>;
+
+	port {
+		venc_out: endpoint {
+			remote-endpoint = <&opa_in>;
+			ti,channels = <2>;
+		};
+	};
+};
+
 &gpmc {
 	ranges = <0 0 0x30000000 0x04>; /* CS0: NAND */
 
-- 
1.9.1

