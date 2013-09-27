Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3I0DRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:17:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3I0DQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:16:56 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv4 12/18] arm: dts: add omap4460 thermal data
Date: Thu, 26 Sep 2013 23:13:19 -0400
Message-ID: <1380251605-3804-13-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the dtsi entry on omap4460 to contain
the thermal data. This data will enable the passive
cooling with CPUfreq cooling device at 100C and the
system will do a thermal shutdown at 125C.

Cc: "Benoît Cousson" <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/omap4460.dtsi | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index c2f0f39..4d93aba 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -12,7 +12,7 @@
 / {
 	cpus {
 		/* OMAP446x 'standard device' variants OPP50 to OPPTurbo */
-		cpu@0 {
+		cpu0: cpu@0 {
 			operating-points = <
 				/* kHz    uV */
 				350000  1025000
@@ -30,12 +30,18 @@
 		ti,hwmods = "debugss";
 	};
 
-	bandgap {
+	thermal-zones{
+		#include "omap4-cpu-thermal.dtsi"
+	};
+
+	bandgap: bandgap {
 		reg = <0x4a002260 0x4
 		       0x4a00232C 0x4
 		       0x4a002378 0x18>;
 		compatible = "ti,omap4460-bandgap";
 		interrupts = <0 126 IRQ_TYPE_LEVEL_HIGH>; /* talert */
 		gpios = <&gpio3 22 0>; /* tshut */
+
+		#thermal-sensor-cells = <0>;
 	};
 };
-- 
1.8.2.1.342.gfa7285d

