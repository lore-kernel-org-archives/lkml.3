Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3GAImu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:42:50 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36080 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3GAIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:11 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 06/13] ARM: AT91: DTS: sam9x5ek: add sound configuration
Date: Mon,  1 Jul 2013 10:39:31 +0200
Message-Id: <1372667978-4718-7-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
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
index a81a1a6..77e4073 100644
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

