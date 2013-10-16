Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876Ab3JPPjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:39:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60718 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760829Ab3JPPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:39:47 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V7 6/8] ARM: dts: OMAP5: Add CPU OPP table
Date: Wed, 16 Oct 2013 10:39:06 -0500
Message-ID: <1381937948-27057-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381937948-27057-1-git-send-email-nm@ti.com>
References: <1381937948-27057-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

Add DT OPP table for OMAP54xx family of devices. This data is
decoded by OF with of_init_opp_table() helper function.

The data is based on OMAP543x ES2.0 DM Operating Condition Addendum
Version 0.6(April 2013)

NOTE: The voltage and frequency values work well only on NOM samples
and are supposed to work properly only with ABB/AVS for ALL OPPs.

TODO: Add SPEED BIN OPP after ABB and AVS support so the cpufreq works
on all samples seamlessly. Clock node is pending alignment for clock
dts conversion

[nm@ti.com: sync to latest and fixes]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 40aac32..69874de 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -37,6 +37,13 @@
 			device_type = "cpu";
 			compatible = "arm,cortex-a15";
 			reg = <0x0>;
+
+			operating-points = <
+				/* kHz    uV */
+				500000  880000
+				1000000 1060000
+				1500000 1250000
+			>;
 		};
 		cpu@1 {
 			device_type = "cpu";
-- 
1.7.9.5

