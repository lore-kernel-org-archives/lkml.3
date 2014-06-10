Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFJLPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:15:42 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51666 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaFJLOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:14:52 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] ARM: tegra: tegra124: Add XUSB pad controller
Date: Tue, 10 Jun 2014 13:11:47 +0200
Message-Id: <1402398708-10722-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The device tree node in the SoC file contains only the resources (such
as registers, resets, ...) but none of the lane assignment information
since that's board specific and belongs in the board file.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- include dt-bindings/pinctrl/pinctrl-tegra-xusb.h so that board files
  don't have to include it explicitly
- remove unneeded #address-cells/#size-cells = <0>
- add padctl label for XUSB pad controller node

 arch/arm/boot/dts/tegra124.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 6e6bc4e8185c..b7cb944b2faa 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -1,6 +1,7 @@
 #include <dt-bindings/clock/tegra124-car.h>
 #include <dt-bindings/gpio/tegra-gpio.h>
 #include <dt-bindings/pinctrl/pinctrl-tegra.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra-xusb.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
@@ -449,6 +450,15 @@
 		clock-names = "pclk", "clk32k_in";
 	};
 
+	padctl: padctl@0,7009f000 {
+		compatible = "nvidia,tegra124-xusb-padctl";
+		reg = <0x0 0x7009f000 0x0 0x1000>;
+		resets = <&tegra_car 142>;
+		reset-names = "padctl";
+
+		#phy-cells = <1>;
+	};
+
 	sdhci@0,700b0000 {
 		compatible = "nvidia,tegra124-sdhci";
 		reg = <0x0 0x700b0000 0x0 0x200>;
-- 
1.9.2

