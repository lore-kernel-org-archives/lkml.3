Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3JASeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:34:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33579 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3JASeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:34:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 4/7] arm: dts: add cooling properties on dra7 cpu node
Date: Tue, 1 Oct 2013 14:32:21 -0400
Message-ID: <1380652344-18819-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRA7 devices can reach high temperatures and thus
needs to have cpufreq-cooling on systems running on it.

This patch adds the required cooling device properties
so that cpufreq-cpu0 driver loads the cooling device.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 4e9b159..1104d8a 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -25,8 +25,12 @@
 	};
 
 	cpus {
-		cpu@0 {
+		cpu0: cpu@0 {
 			compatible = "arm,cortex-a15";
+
+			/* cooling properties */
+			#cooling-cells = <2>; /* min and max */
+
 			timer {
 				compatible = "arm,armv7-timer";
 				/*
-- 
1.8.2.1.342.gfa7285d

