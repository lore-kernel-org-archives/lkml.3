Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3FFQ1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:27:43 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:54549 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3FFQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:27:38 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] ARM: dove: move device tree nodes to DT irqchip and clocksource
Date: Thu,  6 Jun 2013 18:27:11 +0200
Message-Id: <1370536034-23956-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent support for true irqchip and clocksource drivers for Orion
SoCs, now make use of it on DT enabled Dove boards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 8612658..8d5be1e8 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -30,11 +30,28 @@
 			marvell,tauros2-cache-features = <0>;
 		};
 
-		intc: interrupt-controller {
+		timer: timer@20300 {
+			compatible = "marvell,orion-timer";
+			reg = <0x20300 0x20>;
+			interrupt-parent = <&bridge_intc>;
+			interrupts = <1>, <2>;
+			clocks = <&core_clk 0>;
+		};
+
+		intc: main-interrupt-ctrl@20200 {
 			compatible = "marvell,orion-intc";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-			reg = <0x20204 0x04>, <0x20214 0x04>;
+			reg = <0x20200 0x10>, <0x20210 0x10>;
+		};
+
+		bridge_intc: bridge-interrupt-ctrl@20110 {
+			compatible = "marvell,orion-bridge-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x20110 0x8>;
+			interrupts = <0>;
+			marvell,#interrupts = <5>;
 		};
 
 		core_clk: core-clocks@d0214 {
-- 
1.7.2.5

