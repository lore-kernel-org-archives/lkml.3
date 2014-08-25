Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaHYW7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:59:49 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53715 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaHYW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:59:32 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] ARM: dts: Add main PWM info to rk3288
Date: Mon, 25 Aug 2014 15:59:26 -0700
Message-Id: <1409007567-23523-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409007567-23523-1-git-send-email-dianders@chromium.org>
References: <1409007567-23523-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the PWM info (other than the VOP PWM) to the main rk3288
dtsi file.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v5:
- Back to version 3 (no rockchip,grf).

Changes in v4:
- Add rockchip,grf to pwm nodes.

Changes in v3: None

 arch/arm/boot/dts/rk3288.dtsi | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..9c9d9c5 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -261,6 +261,50 @@
 		status = "disabled";
 	};
 
+	pwm0: pwm@ff680000 {
+		compatible = "rockchip,rk3288-pwm";
+		reg = <0xff680000 0x10>;
+		#pwm-cells = <3>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pwm0_pin>;
+		clocks = <&cru PCLK_PWM>;
+		clock-names = "pwm";
+		status = "disabled";
+	};
+
+	pwm1: pwm@ff680010 {
+		compatible = "rockchip,rk3288-pwm";
+		reg = <0xff680010 0x10>;
+		#pwm-cells = <3>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pwm1_pin>;
+		clocks = <&cru PCLK_PWM>;
+		clock-names = "pwm";
+		status = "disabled";
+	};
+
+	pwm2: pwm@ff680020 {
+		compatible = "rockchip,rk3288-pwm";
+		reg = <0xff680020 0x10>;
+		#pwm-cells = <3>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pwm2_pin>;
+		clocks = <&cru PCLK_PWM>;
+		clock-names = "pwm";
+		status = "disabled";
+	};
+
+	pwm3: pwm@ff680030 {
+		compatible = "rockchip,rk3288-pwm";
+		reg = <0xff680030 0x10>;
+		#pwm-cells = <2>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pwm3_pin>;
+		clocks = <&cru PCLK_PWM>;
+		clock-names = "pwm";
+		status = "disabled";
+	};
+
 	pmu: power-management@ff730000 {
 		compatible = "rockchip,rk3288-pmu", "syscon";
 		reg = <0xff730000 0x100>;
@@ -611,5 +655,29 @@
 				rockchip,pins = <5 15 3 &pcfg_pull_none>;
 			};
 		};
+
+		pwm0 {
+			pwm0_pin: pwm0-pin {
+				rockchip,pins = <7 0 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
+		pwm1 {
+			pwm1_pin: pwm1-pin {
+				rockchip,pins = <7 1 RK_FUNC_1 &pcfg_pull_none>;
+			};
+		};
+
+		pwm2 {
+			pwm2_pin: pwm2-pin {
+				rockchip,pins = <7 22 RK_FUNC_3 &pcfg_pull_none>;
+			};
+		};
+
+		pwm3 {
+			pwm3_pin: pwm3-pin {
+				rockchip,pins = <7 23 RK_FUNC_3 &pcfg_pull_none>;
+			};
+		};
 	};
 };
-- 
2.1.0.rc2.206.gedb03e5

