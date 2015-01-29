Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbbA2H2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:28:20 -0500
Received: from fallback7.mail.ru ([94.100.181.128]:45114 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbbA2H2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:28:18 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 02:28:17 EST
From: Andrey Danin <danindrey@mail.ru>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        ac100@lists.launchpad.net
Cc: Andrey Danin <danindrey@mail.ru>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Marc Dietrich <marvin24@gmx.de>
Subject: [PATCH 3/3] dt: paz00: define nvec as child of i2c bus
Date: Thu, 29 Jan 2015 10:20:22 +0300
Message-Id: <1422516022-27161-4-git-send-email-danindrey@mail.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
References: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVEC driver was reimplemented to use tegra i2c. Use common i2c bindings
for NVEC node.

Signed-off-by: Andrey Danin <danindrey@mail.ru>
---
 .../devicetree/bindings/nvec/nvidia,nvec.txt       | 19 ++-----------------
 arch/arm/boot/dts/tegra20-paz00.dts                | 22 +++++++++-------------
 2 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt b/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
index 5ae601e..d82c125 100644
--- a/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
+++ b/Documentation/devicetree/bindings/nvec/nvidia,nvec.txt
@@ -2,20 +2,5 @@ NVIDIA compliant embedded controller
 
 Required properties:
 - compatible : should be "nvidia,nvec".
-- reg : the iomem of the i2c slave controller
-- interrupts : the interrupt line of the i2c slave controller
-- clock-frequency : the frequency of the i2c bus
-- gpios : the gpio used for ec request
-- slave-addr: the i2c address of the slave controller
-- clocks : Must contain an entry for each entry in clock-names.
-  See ../clocks/clock-bindings.txt for details.
-- clock-names : Must include the following entries:
-  Tegra20/Tegra30:
-  - div-clk
-  - fast-clk
-  Tegra114:
-  - div-clk
-- resets : Must contain an entry for each entry in reset-names.
-  See ../reset/reset.txt for details.
-- reset-names : Must include the following entries:
-  - i2c
+- request-gpios : the gpio used for ec request
+- reg: the i2c address of the slave controller
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index ed7e100..65e247b 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -288,20 +288,16 @@
 		clock-frequency = <100000>;
 	};
 
-	nvec@7000c500 {
-		compatible = "nvidia,nvec";
-		reg = <0x7000c500 0x100>;
-		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
-		#address-cells = <1>;
-		#size-cells = <0>;
+	i2c@7000c500 {
+		status = "okay";
 		clock-frequency = <80000>;
-		request-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
-		slave-addr = <138>;
-		clocks = <&tegra_car TEGRA20_CLK_I2C3>,
-		         <&tegra_car TEGRA20_CLK_PLL_P_OUT3>;
-		clock-names = "div-clk", "fast-clk";
-		resets = <&tegra_car 67>;
-		reset-names = "i2c";
+
+		nvec: nvec@45 {
+			compatible = "nvidia,nvec";
+			request-gpios = <&gpio TEGRA_GPIO(V, 2)
+				GPIO_ACTIVE_HIGH>;
+			reg = <0x45>;
+		};
 	};
 
 	i2c@7000d000 {
-- 
1.9.1

