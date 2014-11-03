Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaKCWAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:00:21 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:53976 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaKCV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:59:56 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for devconf1 register
Date: Mon,  3 Nov 2014 22:59:28 +0100
Message-Id: <1415051968-4878-5-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415051968-4878-1-git-send-email-marek@goldelico.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gta04 board need for tvout enabled 2 bits in devconf1 register (tvbypass and acbias).
Add single pinmux entry and enable it.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index e4d05f0..a456d37 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -118,6 +118,17 @@
 			};
 		};
 	};
+
+	/* pinmux for devconf1 */
+	control_devconf1: pinmux@480022d8 {
+		compatible = "pinctrl-single";
+		reg = <0x480022d8 4>;	/* single register */
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-single,bit-per-mux;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xfc0bd5>;
+	};
 };
 
 &omap3_pmx_core {
@@ -497,3 +508,14 @@
 		};
 	};
 };
+
+&control_devconf1 {
+	pinctrl-name = "default";
+	pinctrl-0 = < &tv_acbias_pins>;
+
+	tv_acbias_pins: pinmux_tv_acbias_pins {
+		pinctrl-single,bits = <
+			0 0x40800 0x40800
+		>;
+	};
+};
-- 
1.9.1

