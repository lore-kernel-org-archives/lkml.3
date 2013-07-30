Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3G3KdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:33:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46591 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721Ab3G3Kcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:32:45 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v6 7/8] ARM: AT91: DTS: sam9x5ek: add sound configuration
Date: Tue, 30 Jul 2013 12:32:08 +0200
Message-Id: <1375180329-4860-8-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sam9x5ek board has 2 jacks:
headphone wired on RHPOUT/LHPOUT of the wm8731
line in wired on LLINEIN/RLINEIN of the wm8731

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index f3e83f7..9afe15b 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -113,4 +113,19 @@
 			status = "okay";
 		};
 	};
+
+	sound {
+		compatible = "atmel,sam9x5-wm8731-audio";
+
+		atmel,model = "wm8731 @ AT91SAM9X5EK";
+
+		atmel,audio-routing =
+			"Headphone Jack", "RHPOUT",
+			"Headphone Jack", "LHPOUT",
+			"LLINEIN", "Line In Jack",
+			"RLINEIN", "Line In Jack";
+
+		atmel,ssc-controller = <&ssc0>;
+		atmel,audio-codec = <&wm8731>;
+	};
 };
-- 
1.7.10.4

