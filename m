Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIXQUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:20:22 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40443 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaIXQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:20:19 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, daniel.lezcano@linaro.org,
        tglx@linutronix.de
Cc: festevam@gmail.com, jingchang.lu@freescale.com, bpringlemeir@nbsps.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 2/3] ARM: dts: vf610: Add ARM Global Timer
Date: Wed, 24 Sep 2014 18:20:09 +0200
Message-Id: <1411575610-20895-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411575610-20895-1-git-send-email-stefan@agner.ch>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Global Timer support which is part of the private peripherals
of the Cortex-A5 processor. This Global Timer is compatible with the
Cortex-A9 implementation. It's a 64-bit timer and is clocked by the
peripheral clock, which is typically 133 or 166MHz on Vybrid.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 4d2ec32..3232b9a 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -11,6 +11,7 @@
 #include "vf610-pinfunc.h"
 #include <dt-bindings/clock/vf610-clock.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/arm-gic.h>
 
 / {
 	aliases {
@@ -83,6 +84,13 @@
 				      <0x40002100 0x100>;
 			};
 
+			timer: global-timer@40002200 {
+				compatible = "arm,cortex-a9-global-timer";
+				reg = <0x40002200 0x20>;
+				interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_PLATFORM_BUS>;
+			};
+
 			L2: l2-cache@40006000 {
 				compatible = "arm,pl310-cache";
 				reg = <0x40006000 0x1000>;
-- 
2.1.0

