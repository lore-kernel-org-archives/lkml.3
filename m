Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3JNFlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:41:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:40698 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3JNFlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:41:06 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 5/5] ARM: at91: add sound support on at91sam9n12ek board
Date: Mon, 14 Oct 2013 13:38:33 +0800
Message-Id: <1381729113-29714-6-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
References: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sound support on at91sam9n12ek board with wm8904 as codec.

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
 arch/arm/boot/dts/at91sam9n12ek.dts |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 391c532..e9487f6 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -91,6 +91,13 @@
 							<AT91_PIOA 2 AT91_PERIPH_GPIO AT91_PINCTRL_PULL_UP_DEGLITCH>;
 					};
 				};
+
+				sound {
+					pinctrl_pck0_as_audio_mck: pck0_as_audio_mck {
+						atmel,pins =
+							<AT91_PIOB 10 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
 			};
 
 			spi0: spi@f0000000 {
@@ -151,4 +158,22 @@
 			gpio-key,wakeup;
 		};
 	};
+
+	sound {
+		compatible = "atmel,asoc-wm8904";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pck0_as_audio_mck>;
+
+		atmel,model = "wm8904 @ AT91SAM9N12";
+		atmel,audio-routing =
+			"Headphone Jack", "HPOUTL",
+			"Headphone Jack", "HPOUTR",
+			"IN2L", "Line In Jack",
+			"IN2R", "Line In Jack",
+			"Mic", "MICBIAS",
+			"IN1L", "Mic";
+
+		atmel,ssc-controller = <&ssc0>;
+		atmel,audio-codec = <&wm8904>;
+	};
 };
-- 
1.7.9.5

