Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaDQSBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:01:40 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:51028 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaDQSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:00:20 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: abrestic@chromium.org, dgreid@chromium.org,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
Date: Thu, 17 Apr 2014 10:59:30 -0700
Message-Id: <1397757570-19750-8-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397757570-19750-1-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the EC i2c tunnel (and devices under it) to the
tegra124-venice2 device tree.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/tegra124-venice2.dts | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index c17283c..df97d15 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -8,6 +8,7 @@
 	compatible = "nvidia,venice2", "nvidia,tegra124";
 
 	aliases {
+		i2c20 = "/spi@0,7000d400/cros-ec@0/i2c-tunnel";
 		rtc0 = "/i2c@0,7000d000/pmic@40";
 		rtc1 = "/rtc@0,7000e000";
 	};
@@ -813,6 +814,32 @@
 
 			google,cros-ec-spi-msg-delay = <2000>;
 
+			i2c-tunnel {
+				compatible = "google,cros-ec-i2c-tunnel";
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				google,remote-bus = <0>;
+
+				charger: bq24735@9 {
+					compatible = "ti,bq24735";
+					reg = <0x9>;
+					interrupt-parent = <&gpio>;
+					interrupts = <TEGRA_GPIO(J, 0)
+							GPIO_ACTIVE_HIGH>;
+					ti,ac-detect-gpios = <&gpio
+							TEGRA_GPIO(J, 0)
+							GPIO_ACTIVE_HIGH>;
+				};
+
+				battery: sbs-battery@b {
+					compatible = "sbs,sbs-battery";
+					reg = <0xb>;
+					sbs,i2c-retry-count = <2>;
+					sbs,poll-retry-count = <1>;
+				};
+			};
+
 			cros-ec-keyb {
 				compatible = "google,cros-ec-keyb";
 				keypad,num-rows = <8>;
-- 
1.9.1.423.g4596e3a

