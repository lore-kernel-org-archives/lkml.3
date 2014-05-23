Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaEWKil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:38:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35517 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaEWKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:45 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 55/71] dts: ca5: add the global timer for the A5
Date: Fri, 23 May 2014 12:31:35 +0200
Message-Id: <1400841111-6683-55-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew.leach@arm.com>

The Cortex A5 contains a global timer: add the appropriate device tree
node.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/boot/dts/vexpress-v2p-ca5s.dts |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca5s.dts b/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
index c544a55..d2709b7 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca5s.dts
@@ -88,6 +88,14 @@
 		interrupts = <1 13 0x304>;
 	};
 
+	timer@2c000200 {
+		compatible = "arm,cortex-a5-global-timer",
+		             "arm,cortex-a9-global-timer";
+		reg = <0x2c000200 0x20>;
+		interrupts = <1 11 0x304>;
+		clocks = <&oscclk0>;
+	};
+
 	watchdog@2c000620 {
 		compatible = "arm,cortex-a5-twd-wdt";
 		reg = <0x2c000620 0x20>;
@@ -120,7 +128,7 @@
 		compatible = "arm,vexpress,config-bus";
 		arm,vexpress,config-bridge = <&v2m_sysreg>;
 
-		osc@0 {
+		oscclk0: osc@0 {
 			/* CPU and internal AXI reference clock */
 			compatible = "arm,vexpress-osc";
 			arm,vexpress-sysreg,func = <1 0>;
-- 
1.7.9.5

