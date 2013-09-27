Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3I0DSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:18:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58633 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3I0DSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:18:15 -0400
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
Subject: [PATCHv4 18/18] arm: dts: add cooling properties on omap5 cpu node
Date: Thu, 26 Sep 2013 23:13:25 -0400
Message-ID: <1380251605-3804-19-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP5 devices can reach high temperatures and thus
needs to have cpufreq-cooling on systems running on it.

This patch adds the required cooling device properties
so that cpufreq-cpu0 driver loads the cooling device.

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
 arch/arm/boot/dts/omap5.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 187cb71..a35cd61 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -37,6 +37,9 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a15";
 			reg = <0x0>;
+
+			/* cooling options */
+			#cooling-cells = <2>; /* min followed by max */
 		};
 		cpu@1 {
 			device_type = "cpu";
-- 
1.8.2.1.342.gfa7285d

