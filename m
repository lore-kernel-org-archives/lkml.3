Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaD1OI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:08:29 -0400
Received: from ring0.de ([5.45.105.125]:52081 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbaD1OIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:08:16 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 9/9] DTS: OMAP3-N900: Add sound support
Date: Mon, 28 Apr 2014 16:07:27 +0200
Message-Id: <1398694047-28596-10-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Nokia N900's sound
system.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 6bc8100..5701f91 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -90,6 +90,19 @@
 			};
 		};
 	};
+
+	sound: n900-audio {
+		compatible = "nokia,n900-audio";
+
+		nokia,cpu-dai = <&mcbsp2>;
+		nokia,audio-codec = <&tlv320aic3x>, <&tlv320aic3x_aux>;
+		nokia,headphone-amplifier = <&tpa6130a2>;
+
+		tvout-selection-gpios = <&gpio2 8 GPIO_ACTIVE_HIGH>; /* 40 */
+		jack-detection-gpios = <&gpio6 17 GPIO_ACTIVE_HIGH>; /* 177 */
+		eci-switch-gpios = <&gpio6 22 GPIO_ACTIVE_HIGH>; /* 182 */
+		speaker-amplifier-gpios = <&twl_gpio 7 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &omap3_pmx_core {
@@ -662,3 +675,7 @@
 		};
 	};
 };
+
+&mcbsp2 {
+	status = "ok";
+};
-- 
1.9.2

