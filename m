Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaAFMkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:40:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40402 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaAFMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:40:51 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv2 7/7] arm: dts: add thermal zones info on tmp102 for DRA7-EVM
Date: Mon, 6 Jan 2014 08:36:51 -0400
Message-ID: <1389011811-13004-8-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com>
References: <1389011811-13004-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add simple thermal zone on tmp102.

Cc: Benoît Cousson <bcousson@baylibre.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 36e2c9e..1ea9c3d 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -95,6 +95,21 @@
 	};
 };
 
+&thermal_zones {
+	pcb_thermal: pcb_thermal {
+		polling-delay-passive = <250>; /* milliseconds */
+		polling-delay = <1000>; /* milliseconds */
+		thermal-sensors = <&tmp102>;
+		trips {
+			crit@80000 {
+			temperature = <80000>;
+				hysteresis = <1000>;
+				type = "critical";
+			};
+		};
+	};
+};
+
 &i2c1 {
 	status = "okay";
 	pinctrl-names = "default";
-- 
1.8.2.1.342.gfa7285d

