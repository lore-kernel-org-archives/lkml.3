Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaGWK4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:56:36 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37408 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbaGWKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:31 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] clocksource: clps711x: Add DT bindings documentation
Date: Wed, 23 Jul 2014 12:54:01 +0200
Message-Id: <1406112847-26275-19-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

This patch adds DT binding documentation for the Cirrus Logic
CLPS711X-based CPUs clocksource subsystem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../bindings/timer/cirrus,clps711x-timer.txt       |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt b/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
new file mode 100644
index 0000000..cd55b52
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
@@ -0,0 +1,29 @@
+* Cirrus Logic CLPS711X Timer Counter
+
+Required properties:
+- compatible: Shall contain "cirrus,clps711x-timer".
+- reg       : Address and length of the register set.
+- interrupts: The interrupt number of the timer.
+- clocks    : phandle of timer reference clock.
+
+Note: Each timer should have an alias correctly numbered in "aliases" node.
+
+Example:
+	aliases {
+		timer0 = &timer1;
+		timer1 = &timer2;
+	};
+
+	timer1: timer@80000300 {
+		compatible = "cirrus,ep7312-timer", "cirrus,clps711x-timer";
+		reg = <0x80000300 0x4>;
+		interrupts = <8>;
+		clocks = <&clks 5>;
+	};
+
+	timer2: timer@80000340 {
+		compatible = "cirrus,ep7312-timer", "cirrus,clps711x-timer";
+		reg = <0x80000340 0x4>;
+		interrupts = <9>;
+		clocks = <&clks 6>;
+	};
-- 
1.7.9.5

