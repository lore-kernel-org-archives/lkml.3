Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab3GEMmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:42:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33657 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3GEMmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:42:37 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 4/6] ARM: rockchip: add sram dt nodes and documentation
Date: Fri, 5 Jul 2013 14:42:27 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307051440.19428.heiko@sntech.de>
In-Reply-To: <201307051440.19428.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051442.27482.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip SoCs need a special part of their sram for bringup
of additional cores. Therefore also add a reserved section when adding the
mmio-sram node to keep the sram driver from using this space.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   23 ++++++++++++++++++++
 arch/arm/boot/dts/rk3066a.dtsi                     |    6 +++++
 2 files changed, 29 insertions(+)
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
index 26c4311..24d1941 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -53,6 +53,12 @@
 			reg = <0x1013c000 0x100>;
 		};
 
+		sram: sram@10080000 {
+			compatible = "rockchip,rk3066-sram", "mmio-sram";
+			reg = <0x10080000 0x10000>;
+			mmio-sram-reserved = <0x0 0x50>;
+		};
+
 		gic: interrupt-controller@1013d000 {
 			compatible = "arm,cortex-a9-gic";
 			interrupt-controller;
-- 
1.7.10.4

