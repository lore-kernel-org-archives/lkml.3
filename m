Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaFSN03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:26:29 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:62502 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaFSN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:26:26 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCHv2 2/2] ARM: tegra: tamonten: add the display to the Medcom Wide
Date: Thu, 19 Jun 2014 15:25:50 +0200
Message-Id: <1403184350-25403-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
References: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:abUL9vxUPDmXmDU1dDqTXCH+KgqabyGVGVV9TuUc+Lv
 tPF3Ufdr7BOcIRbciu8vFONc2BlgWVhYUB4USTiEPMD9AdICc8
 dttEtNAsZ8NFK1vF/Q+07hvisvDRj0XK2PkMuUDxu8nXVlpAd8
 apB/wAFjqlWzRAT1bPdx2EEs7cfmiB9NE/FyMrL6+hQP7e79WZ
 ZLRgFUl8De9HTf9x85IX/GYlJt7I36rl9c8IembqNiNUzEAgM7
 c8OwYK4oH5DieoqqwPOR4Foi88mTv2XDxtO4LLzLUczTLq1+vV
 W1nWbJnFamdhPRWN08J9rO5Rulf4Rfr2ykvROmwv69b2CmxXGG
 eNngDkRW5eJV1dSMMHWWKe2BCOTreuIMfsujSpJmAupSYZ9d4H
 F4lv3ILtnbRlgc3MzXgNwZNIANQxVSzRsX39w8B3bMaGRhtSpd
 /pHJ/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the RGB output and add the panel definition to the Medcom Wide
DTS. Also add a label to the backlight defintion to reference it in
the panel definition.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
v2: * no changes since v1
---
 arch/arm/boot/dts/tegra20-medcom-wide.dts | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 0318b84..1b7c56b 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -10,6 +10,15 @@
 		status = "okay";
 	};
 
+	host1x@50000000 {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,panel = <&panel>;
+			};
+		};
+	};
+
 	i2c@7000c000 {
 		wm8903: wm8903@1a {
 			compatible = "wlf,wm8903";
@@ -30,7 +39,7 @@
 		};
 	};
 
-	backlight {
+	backlight: backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 5000000>;
 
@@ -38,6 +47,15 @@
 		default-brightness-level = <6>;
 	};
 
+	panel: panel {
+		compatible = "innolux,n156bge-l21", "simple-panel";
+
+		power-supply =  <&vdd_1v8_reg>, <&vdd_3v3_reg>;
+		enable-gpios = <&gpio TEGRA_GPIO(B, 2) GPIO_ACTIVE_HIGH>;
+
+		backlight = <&backlight>;
+	};
+
 	sound {
 		compatible = "ad,tegra-audio-wm8903-medcom-wide",
 			     "nvidia,tegra-audio-wm8903";
-- 
2.0.0

