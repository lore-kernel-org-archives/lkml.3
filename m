Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaEWKiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:38:17 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40235 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaEWKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:48 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 57/71] clocksource: efm32: use $vendor,$device scheme for compatible string
Date: Fri, 23 May 2014 12:31:37 +0200
Message-Id: <1400841111-6683-57-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Wolfram Sang pointed out that "efm32,$device" is non-standard. So use the
common scheme and prefix device with "efm32-". The old compatible string
is left in place until arch/arm/boot/dts/efm32* is fixed.

Acked-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 .../devicetree/bindings/timer/efm32,timer.txt      |   23 --------------------
 .../bindings/timer/energymicro,efm32-timer.txt     |   23 ++++++++++++++++++++
 drivers/clocksource/time-efm32.c                   |    3 ++-
 3 files changed, 25 insertions(+), 24 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/timer/efm32,timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/efm32,timer.txt b/Documentation/devicetree/bindings/timer/efm32,timer.txt
deleted file mode 100644
index 97a568f..0000000
--- a/Documentation/devicetree/bindings/timer/efm32,timer.txt
+++ /dev/null
@@ -1,23 +0,0 @@
-* EFM32 timer hardware
-
-The efm32 Giant Gecko SoCs come with four 16 bit timers. Two counters can be
-connected to form a 32 bit counter. Each timer has three Compare/Capture
-channels and can be used as PWM or Quadrature Decoder. Available clock sources
-are the cpu's HFPERCLK (with a 10-bit prescaler) or an external pin.
-
-Required properties:
-- compatible : Should be efm32,timer
-- reg : Address and length of the register set
-- clocks : Should contain a reference to the HFPERCLK
-
-Optional properties:
-- interrupts : Reference to the timer interrupt
-
-Example:
-
-timer@40010c00 {
-	compatible = "efm32,timer";
-	reg = <0x40010c00 0x400>;
-	interrupts = <14>;
-	clocks = <&cmu clk_HFPERCLKTIMER3>;
-};
diff --git a/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
new file mode 100644
index 0000000..e502c11
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
@@ -0,0 +1,23 @@
+* EFM32 timer hardware
+
+The efm32 Giant Gecko SoCs come with four 16 bit timers. Two counters can be
+connected to form a 32 bit counter. Each timer has three Compare/Capture
+channels and can be used as PWM or Quadrature Decoder. Available clock sources
+are the cpu's HFPERCLK (with a 10-bit prescaler) or an external pin.
+
+Required properties:
+- compatible : Should be "energymicro,efm32-timer"
+- reg : Address and length of the register set
+- clocks : Should contain a reference to the HFPERCLK
+
+Optional properties:
+- interrupts : Reference to the timer interrupt
+
+Example:
+
+timer@40010c00 {
+	compatible = "energymicro,efm32-timer";
+	reg = <0x40010c00 0x400>;
+	interrupts = <14>;
+	clocks = <&cmu clk_HFPERCLKTIMER3>;
+};
diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
index 1a6205b..bba62f9 100644
--- a/drivers/clocksource/time-efm32.c
+++ b/drivers/clocksource/time-efm32.c
@@ -272,4 +272,5 @@ static void __init efm32_timer_init(struct device_node *np)
 		}
 	}
 }
-CLOCKSOURCE_OF_DECLARE(efm32, "efm32,timer", efm32_timer_init);
+CLOCKSOURCE_OF_DECLARE(efm32compat, "efm32,timer", efm32_timer_init);
+CLOCKSOURCE_OF_DECLARE(efm32, "energymicro,efm32-timer", efm32_timer_init);
-- 
1.7.9.5

