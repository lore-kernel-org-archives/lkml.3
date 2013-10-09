Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3JIXe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:34:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab3JIXan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:30:43 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V6 08/15] ARM: dts: dra7-evm: add smps123 supply for CPU
Date: Wed, 9 Oct 2013 18:30:08 -0500
Message-ID: <1381361414-8851-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381361414-8851-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
 <1381361414-8851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

regulator smps123 supply from Palmas PMIC powers CPU0 on DRA7 EVM.

[nm@ti.com: rebase to latest]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |    4 ++++
 arch/arm/boot/dts/dra7.dtsi    |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 3abf5f4..5babba0 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -269,3 +269,7 @@
 	vmmc-supply = <&mmc2_3v3>;
 	bus-width = <8>;
 };
+
+&cpu0 {
+	cpu0-supply = <&smps123_reg>;
+};
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index c98997b..02e430b 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -32,7 +32,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		cpu@0 {
+		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a15";
 			reg = <0>;
-- 
1.7.9.5

