Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3JASeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:34:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44479 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3JASel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:34:41 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 5/7] arm: dts: dra7: add thermal data
Date: Tue, 1 Oct 2013 14:32:22 -0400
Message-ID: <1380652344-18819-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds thermal data for DRA7 SoCs. Cpufreq cooling
will be enabled for MPU domain whenever it crosses 100C.
GPU, CORE, DSPEVE, IVA will be exposed and system shall
shutdown when they cross 125C.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 1104d8a..8ba5e1c 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -57,6 +57,15 @@
 		};
 	};
 
+	thermal_zones: thermal-zones {
+		/* SoC thermal zones */
+		#include "omap4-cpu-thermal.dtsi"
+		#include "omap5-gpu-thermal.dtsi"
+		#include "omap5-core-thermal.dtsi"
+		#include "dra7-dspeve-thermal.dtsi"
+		#include "dra7-iva-thermal.dtsi"
+	};
+
 	bandgap: bandgap {
 		reg = <0x4a0021e0 0xc
 			0x4a00232c 0xc
-- 
1.8.2.1.342.gfa7285d

