Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3HLMba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:31:30 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48124 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab3HLMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:31:27 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/4] ARM: AT91: DTS: sam9x5ek: add sound configuration
Date: Mon, 12 Aug 2013 14:31:02 +0200
Message-Id: <1376310662-20003-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
References: <1376310662-20003-1-git-send-email-richard.genoud@gmail.com>
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

