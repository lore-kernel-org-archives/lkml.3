Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3JVP1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:27:35 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37686 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3JVP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:27:34 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH RESEND v5 3/5] ARM: rockchip: add sram dt nodes and documentation
Date: Tue, 22 Oct 2013 17:27:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>,
        Matt Sealey <neko@bakuhatsu.net>, Fabio Estevam <festevam@gmail.com>
References: <201310221724.21550.heiko@sntech.de>
In-Reply-To: <201310221724.21550.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201310221727.12357.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip SoCs need a special part of their sram for bringup
of additional cores. Therefore also limit the public area when adding the
mmio-sram node to keep the sram driver from using this space.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   24 ++++++++++++++++++++
 arch/arm/boot/dts/rk3066a.dtsi                     |    6 +++++
 arch/arm/boot/dts/rk3188.dtsi                      |    6 +++++
 3 files changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt b/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
new file mode 100644
index 0000000..0c88d06
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
@@ -0,0 +1,24 @@
+Rockchip SRAM for smp bringup:
+------------------------------
+
+Rockchip's smp-capable SoCs use the first part of the sram for the bringup
+of the cores. Once the core gets powered up it executes the code that is
+residing at the very beginning of the sram.
+
+Therefore the available space has to be limited to exclude this area using
+the available property of the sram node.
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
+		available = <0x50 0xffb0>;
+	};
diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index 2218c64..e91048b 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -64,6 +64,12 @@
 			clock-names = "timer", "pclk";
 		};
 
+		sram: sram@10080000 {
+			compatible = "rockchip,rk3066-sram", "mmio-sram";
+			reg = <0x10080000 0x10000>;
+			available = <0x50 0xffb0>;
+		};
+
 		pinctrl@20008000 {
 			compatible = "rockchip,rk3066a-pinctrl";
 			reg = <0x20008000 0x150>;
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index 1a26b03..a9885df 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -60,6 +60,12 @@
 			interrupts = <GIC_PPI 13 0xf04>;
 		};
 
+		sram: sram@10080000 {
+			compatible = "rockchip,rk3066-sram", "mmio-sram";
+			reg = <0x10080000 0x8000>;
+			available = <0x50 0x7fb0>;
+		};
+
 		pinctrl@20008000 {
 			compatible = "rockchip,rk3188-pinctrl";
 			reg = <0x20008000 0xa0>,
-- 
1.7.10.4

