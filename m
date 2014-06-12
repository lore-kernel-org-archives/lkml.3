Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaFLPMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:12:48 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55787 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaFLPMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:12:45 -0400
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
Subject: [PATCH 2/2] ARM: tegra: tamonten: add the display to the Medcom Wide
Date: Thu, 12 Jun 2014 17:11:25 +0200
Message-Id: <1402585885-28247-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402585885-28247-1-git-send-email-alban.bedel@avionic-design.de>
References: <1402585885-28247-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:T4t+vnDvpQNXq27R5+4lOSQXo8Ti4hNgEuvknDWZHJx
 hFlNRJxD68xzX+BxUK5VG1/oH76JK+4NC+7EjLb+ciTC71+Zvc
 42BHcQ+whmo2BctvHv0I5WvFJeCSxN8mpauAIFHsteu7QNXp1h
 EspoeGmBaHjhJTxlQLhFC3B/wLDHFMbYvQ1iX1SzDCPfPWz7/a
 5hTDmqB3wHxdtuOUJ7+gXjZXkZ7+lSpuSeGA9r7J+khntlBDUF
 l0TcFwLHhcIrDVWAbBtSCRtOL8Z20HMS9kSa4kRSWDRlI7IgLp
 aM7muDfNQocCt1uIDZscwwZivKf4/Mgnoiw/0uMOh2C0qmQzZk
 2TXc/32O5tKPnrT1Jl//c/zuhiRzX9DC6JHxVeH5qLpNstydF/
 8B9+3xhprQBNQpBOFWEFffy8roYylllqa3bGkqKCx3lQ4hgd/x
 xdp1b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the RGB output and add the panel definition to the Medcom Wide
DTS. Also add a label to the backlight defintion to reference it in
the panel definition.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-medcom-wide.dts | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 0cd05f7..97a9101 100644
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

