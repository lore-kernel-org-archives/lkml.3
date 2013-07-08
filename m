Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3GHNba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:31:30 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55852 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3GHNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:30:28 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v2 4/5] ARM: AT91: DTS: sam9x5ek: add sound configuration
Date: Mon,  8 Jul 2013 15:29:52 +0200
Message-Id: <1373290193-25300-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sam9x5ek board has 2 jacks:
headphone wired on RHPOUT/LHPOUT of the wm8731
line in wired on LLINEIN/RLINEIN of the wm8731

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index e6fb309..bd0f7b8 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -109,4 +109,22 @@
 			status = "okay";
 		};
 	};
+
+	sound {
+		compatible = "atmel,sam9x5-audio-wm8731";
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
+		atmel,format = "i2s";
+		atmel,bitclock-master;
+		atmel,frame-master;
+	};
 };
-- 
1.7.10.4

