Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaANQKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:10:20 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:43699 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751578AbaANQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:10:16 -0500
From: =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
	<sebastien.szymanski@armadeus.com>
To: linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
	<sebastien.szymanski@armadeus.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Julien Boibessot <julien.boibessot@armadeus.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] ARM: dts: imx28-apf28dev: add user button
Date: Tue, 14 Jan 2014 15:21:27 +0100
Message-Id: <1389709287-25742-1-git-send-email-sebastien.szymanski@armadeus.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5172102697572259069
X-Ovh-Remote: 83.141.254.164 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
---
 arch/arm/boot/dts/imx28-apf28dev.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-apf28dev.dts b/arch/arm/boot/dts/imx28-apf28dev.dts
index 334dea5..221cac4 100644
--- a/arch/arm/boot/dts/imx28-apf28dev.dts
+++ b/arch/arm/boot/dts/imx28-apf28dev.dts
@@ -48,6 +48,7 @@
 						MX28_PAD_LCD_D20__GPIO_1_20
 						MX28_PAD_LCD_D21__GPIO_1_21
 						MX28_PAD_LCD_D22__GPIO_1_22
+						MX28_PAD_GPMI_CE1N__GPIO_0_17
 					>;
 					fsl,drive-strength = <MXS_DRIVE_4mA>;
 					fsl,voltage = <MXS_VOLTAGE_HIGH>;
@@ -193,4 +194,14 @@
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		user-button {
+			label = "User button";
+			gpios = <&gpio0 17 0>;
+			linux,code = <0x100>;
+		};
+	};
 };
-- 
1.8.3.2

