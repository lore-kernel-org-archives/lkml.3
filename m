Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3HWXTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:19:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58194 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3HWXTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:19:07 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>
CC: <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 08/14] arm: dts: add omap4460 thermal data
Date: Fri, 23 Aug 2013 19:15:49 -0400
Message-ID: <1377299755-5134-9-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
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

Cc: "Benoît Cousson" <b-cousson@linaro.org>
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
 arch/arm/boot/dts/omap4460.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index c2f0f39..9855f29 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -30,6 +30,10 @@
 		ti,hwmods = "debugss";
 	};
 
+	thermal_zones{
+		#include "omap4-cpu-thermal.dtsi"
+	};
+
 	bandgap {
 		reg = <0x4a002260 0x4
 		       0x4a00232C 0x4
@@ -37,5 +41,6 @@
 		compatible = "ti,omap4460-bandgap";
 		interrupts = <0 126 IRQ_TYPE_LEVEL_HIGH>; /* talert */
 		gpios = <&gpio3 22 0>; /* tshut */
+		monitored-zones = <&cpu_thermal 0>;
 	};
 };
-- 
1.8.2.1.342.gfa7285d

