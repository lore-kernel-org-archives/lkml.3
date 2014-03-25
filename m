Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaCYOu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 10:50:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33063 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaCYOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 10:50:55 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Wolfram Sang <wsa@the-dreams.de>
Date: Tue, 25 Mar 2014 15:50:44 +0100
Message-Id: <1395759044-10700-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH v2] clocksource: efm32: use $vendor,$device scheme for compatible string
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Sang pointed out that "efm32,$device" is non-standard. So use the
common scheme and prefix device with "efm32-". The old compatible string
is left in place until arch/arm/boot/dts/efm32* is fixed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Changes since (implicit) v1, sent with
Message-Id: 1395757522-6431-1-git-send-email-u.kleine-koenig@pengutronix.de:
 - fix binding doc accordingly

 .../bindings/timer/{efm32,timer.txt => energymicro,efm32-timer.txt}   | 4 ++--
 drivers/clocksource/time-efm32.c                                      | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)
 rename Documentation/devicetree/bindings/timer/{efm32,timer.txt => energymicro,efm32-timer.txt} (87%)

diff --git a/Documentation/devicetree/bindings/timer/efm32,timer.txt b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
similarity index 87%
rename from Documentation/devicetree/bindings/timer/efm32,timer.txt
rename to Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
index 97a568f696c9..e502c11b2211 100644
--- a/Documentation/devicetree/bindings/timer/efm32,timer.txt
+++ b/Documentation/devicetree/bindings/timer/energymicro,efm32-timer.txt
@@ -6,7 +6,7 @@ channels and can be used as PWM or Quadrature Decoder. Available clock sources
 are the cpu's HFPERCLK (with a 10-bit prescaler) or an external pin.
 
 Required properties:
-- compatible : Should be efm32,timer
+- compatible : Should be "energymicro,efm32-timer"
 - reg : Address and length of the register set
 - clocks : Should contain a reference to the HFPERCLK
 
@@ -16,7 +16,7 @@ Optional properties:
 Example:
 
 timer@40010c00 {
-	compatible = "efm32,timer";
+	compatible = "energymicro,efm32-timer";
 	reg = <0x40010c00 0x400>;
 	interrupts = <14>;
 	clocks = <&cmu clk_HFPERCLKTIMER3>;
diff --git a/drivers/clocksource/time-efm32.c b/drivers/clocksource/time-efm32.c
index 1a6205b7bed3..bba62f9deefb 100644
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
1.9.1

