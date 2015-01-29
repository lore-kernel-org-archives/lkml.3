Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbbA2NKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:10:20 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53633 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbA2NIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:08:38 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, baruch@tkos.co.il, linux@rempel-privat.de,
        rob.herring@linaro.org, thierry.reding@gmail.com
Subject: [PATCH 5/9] clocksource: devicetree: Document Conexant Digicolor timer binding
Date: Thu, 29 Jan 2015 14:08:15 +0100
Message-Id: <1422536899-16609-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
References: <54CA3044.6070501@linaro.org>
 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

The Conexant CX92755 SoC provides 8 32-bit timers as part of its so called
"Agent Communication" block. Timers can be configures either as free running or
one shot. Each timer has a dedicated interrupt source in the CX92755 interrupts
controller. The first timer (Timer A) can also be configured as watchdog.

This commit adds devicetree binding definition of this hardware module. The
binding defined here should be reusable for other SoCs in the Digicolor series.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/timer/digicolor-timer.txt      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/digicolor-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/digicolor-timer.txt b/Documentation/devicetree/bindings/timer/digicolor-timer.txt
new file mode 100644
index 0000000..d1b659b
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/digicolor-timer.txt
@@ -0,0 +1,18 @@
+Conexant Digicolor SoCs Timer Controller
+
+Required properties:
+
+- compatible : should be "cnxt,cx92755-timer"
+- reg : Specifies base physical address and size of the "Agent Communication"
+  timer registers
+- interrupts : Contains 8 interrupts, one for each timer
+- clocks: phandle to the main clock
+
+Example:
+
+	timer@f0000fc0 {
+		compatible = "cnxt,cx92755-timer";
+		reg = <0xf0000fc0 0x40>;
+		interrupts = <19>, <31>, <34>, <35>, <52>, <53>, <54>, <55>;
+		clocks = <&main_clk>;
+	};
-- 
1.9.1

