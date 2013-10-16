Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803Ab3JPPjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:39:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35216 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760774Ab3JPPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:39:38 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V7 5/8] ARM: dts: dra7-evm: add smps123 supply for CPU
Date: Wed, 16 Oct 2013 10:39:05 -0500
Message-ID: <1381937948-27057-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381937948-27057-1-git-send-email-nm@ti.com>
References: <1381937948-27057-1-git-send-email-nm@ti.com>
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

