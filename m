Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaEOAdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:33:41 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52035 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaEOAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:20 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 10/10] ARM: tegra124: Enable XHCI on Venice2
Date: Wed, 14 May 2014 17:33:06 -0700
Message-Id: <1400113986-339-11-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the XHCI host controller and XUSB PHY on Venice2.  All three
USB2.0 ports are owned by the XHCI controller and the two SuperSpeed
ports are mapped to the external USB2.0 ports.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/arm/boot/dts/tegra124-venice2.dts | 46 ++++++++++++++--------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index f0bb842..dcfc0c7 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -940,6 +940,25 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	usb@0,70090000 {
+		status = "okay";
+		s1p05v-supply = <&vdd_1v05_run>;
+		s3p3v-supply = <&vdd_3v3_lp0>;
+		s1p8v-supply = <&vddio_1v8>;
+	};
+
+	phy@0,7009f000 {
+		status = "okay";
+		nvidia,ss-pads = <0x3>;
+		nvidia,hsic-pads = <0x0>;
+		nvidia,utmi-pads = <0x7>;
+		nvidia,ss-port0-map = <0>;
+		nvidia,ss-port1-map = <2>;
+		vbus1-supply = <&vdd_usb1_vbus>;
+		vbus2-supply = <&vdd_run_cam>;
+		vbus3-supply = <&vdd_usb3_vbus>;
+	};
+
 	sdhci@0,700b0400 {
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
@@ -960,33 +979,6 @@
 		};
 	};
 
-	usb@0,7d000000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d000000 {
-		status = "okay";
-		vbus-supply = <&vdd_usb1_vbus>;
-	};
-
-	usb@0,7d004000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d004000 {
-		status = "okay";
-		vbus-supply = <&vdd_run_cam>;
-	};
-
-	usb@0,7d008000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d008000 {
-		status = "okay";
-		vbus-supply = <&vdd_usb3_vbus>;
-	};
-
 	backlight: backlight {
 		compatible = "pwm-backlight";
 
-- 
1.9.1.423.g4596e3a

