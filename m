Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaAOVno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:43:44 -0500
Received: from gloria.sntech.de ([95.129.55.99]:40029 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaAOVnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:43:40 -0500
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
Subject: [PATCH v6 5/6] ARM: rockchip: add power-management-unit
Date: Wed, 15 Jan 2014 22:43:11 +0100
Message-ID: <2033803.ve2pEnCxjZ@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <27256277.YJ687suYy5@phil>
References: <27256277.YJ687suYy5@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu is needed to bring up the cores during smp operations and later
also other system parts. Therefore add a node and documentation for it.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 Documentation/devicetree/bindings/arm/rockchip/pmu.txt |   16 ++++++++++++++++
 arch/arm/boot/dts/rk3xxx.dtsi                          |    5 +++++
 2 files changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/pmu.txt b/Documentation/devicetree/bindings/arm/rockchip/pmu.txt
new file mode 100644
index 0000000..3ee9b42
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/pmu.txt
@@ -0,0 +1,16 @@
+Rockchip power-management-unit:
+-------------------------------
+
+The pmu is used to turn off and on different power domains of the SoCs
+This includes the power to the CPU cores.
+
+Required node properties:
+- compatible value : = "rockchip,rk3066-pmu";
+- reg : physical base address and the size of the registers window
+
+Example:
+
+	pmu@20004000 {
+		compatible = "rockchip,rk3066-pmu";
+		reg = <0x20004000 0x100>;
+	};
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 0a3d5b1..26e5a96 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -31,6 +31,11 @@
 			reg = <0x1013c000 0x100>;
 		};
 
+		pmu@20004000 {
+			compatible = "rockchip,rk3066-pmu";
+			reg = <0x20004000 0x100>;
+		};
+
 		gic: interrupt-controller@1013d000 {
 			compatible = "arm,cortex-a9-gic";
 			interrupt-controller;
-- 
1.7.10.4


