Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaAOVnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:43:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39997 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaAOVnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:43:14 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH v6 4/6] ARM: rockchip: add sram dt nodes and documentation
Date: Wed, 15 Jan 2014 22:42:35 +0100
Message-ID: <2305896.xt7Ek2gLER@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <27256277.YJ687suYy5@phil>
References: <27256277.YJ687suYy5@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dt-nodes for the sram on rk3066 and rk3188 including the reserved section
needed for smp bringup.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   23 ++++++++++++++++++++
 arch/arm/boot/dts/rk3066a.dtsi                     |    6 +++++
 arch/arm/boot/dts/rk3188.dtsi                      |    6 +++++
 3 files changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt b/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
new file mode 100644
index 0000000..80c878e
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
@@ -0,0 +1,23 @@
+Rockchip SRAM for smp bringup:
+------------------------------
+
+Rockchip's smp-capable SoCs use the first part of the sram for the bringup
+of the cores. Once the core gets powered up it executes the code that is
+residing at the very beginning of the sram.
+
+Therefore a reserved section has to be added to the mmio-sram declaration.
+
+Required node properties:
+- compatible : should contain both "rockchip,rk3066-sram", "mmio-sram"
+  so that the smp code can select the correct sram node.
+
+The rest of the properties should follow the generic mmio-sram discription
+found in ../../misc/sram.txt
+
+Example:
+
+	sram: sram@10080000 {
+		compatible = "rockchip,rk3066-sram", "mmio-sram";
+		reg = <0x10080000 0x10000>;
+		mmio-sram-reserved = <0x0 0x50>;
+	};
diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index be5d2b0..0dfb680 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -64,6 +64,12 @@
 			clock-names = "timer", "pclk";
 		};
 
+		sram: sram@10080000 {
+			compatible = "rockchip,rk3066-sram", "mmio-sram";
+			reg = <0x10080000 0x10000>;
+			mmio-sram-reserved = <0x0 0x50>;
+		};
+
 		pinctrl@20008000 {
 			compatible = "rockchip,rk3066a-pinctrl";
 			reg = <0x20008000 0x150>;
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 1a26b03..1fc7eda 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -60,6 +60,12 @@
 			interrupts = <GIC_PPI 13 0xf04>;
 		};
 
+		sram: sram@10080000 {
+			compatible = "rockchip,rk3066-sram", "mmio-sram";
+			reg = <0x10080000 0x8000>;
+			mmio-sram-reserved = <0x0 0x50>;
+		};
+
 		pinctrl@20008000 {
 			compatible = "rockchip,rk3188-pinctrl";
 			reg = <0x20008000 0xa0>,
-- 
1.7.10.4


