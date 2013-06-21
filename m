Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946086Ab3FUV0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:26:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946061Ab3FUV0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:26:32 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Mark Brown <broonie@kernel.org>, Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH V2 5/8] ARM: dts: OMAP4: add voltage processor nodes
Date: Fri, 21 Jun 2013 16:25:46 -0500
Message-ID: <1371849949-12649-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371849949-12649-1-git-send-email-nm@ti.com>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP443x, OMAP446x SoC use same offsets for voltage processor,
however their voltage characteristics differ a little.

Introduce the voltage processor nodes for the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap4.dtsi    |   43 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap443x.dtsi |   15 ++++++++++++++
 arch/arm/boot/dts/omap4460.dtsi |   15 ++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index a153e8d..3c75b23 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -689,5 +689,48 @@
 				compatible = "ti,omap4-vc-channel-core";
 			};
 		};
+
+		vp_mpu: vp@0x4A307B58 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4A307b58 0x18>, <0x4A306014 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x20>;
+
+			clocks = <&sysclk_in>;
+
+			ti,vc-channel = <&vc_mpu>;
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+		};
+
+		vp_iva: vp@0x4A307B70 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4A307B70 0x18>, <0x4A306010 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x20000000>;
+
+			clocks = <&sysclk_in>;
+
+			ti,vc-channel = <&vc_iva>;
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+		};
+
+		vp_core: vp@0x4A307B40 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4A307b40 0x18>, <0x4A306010 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x200000>;
+
+			clocks = <&sysclk_in>;
+
+			regulator_name = "vdd_core";
+			ti,vc-channel = <&vc_core>;
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index 2b0deb5..e759937 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -46,3 +46,18 @@
 	ti,retention-micro-volts = <750000>;
 	ti,off-micro-volts = <0>;
 };
+
+&vp_mpu {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1388000>;
+};
+
+&vp_iva {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1291000>;
+};
+
+&vp_core {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1127000>;
+};
diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 16210a1..8320865 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -55,3 +55,18 @@
 	ti,retention-micro-volts = <750000>;
 	ti,off-micro-volts = <0>;
 };
+
+&vp_mpu {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1380000>;
+};
+
+&vp_iva {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1375000>;
+};
+
+&vp_core {
+	ti,min-micro-volts = <750000>;
+	ti,max-micro-volts = <1250000>;
+};
-- 
1.7.9.5

