Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaFUOYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 10:24:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44213 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaFUOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:23:48 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 3/3] ARM: dts: rk3xxx: add PWM nodes
Date: Sat, 21 Jun 2014 16:22:08 +0200
Message-Id: <1403360528-12757-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
References: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds PWM nodes to the Rockchip device trees.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/rk3188.dtsi |   40 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/rk3xxx.dtsi |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index a50a462..a91e205 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -114,6 +114,22 @@
 			clock-names = "biu", "ciu";
 		};
 
+		pwm0: pwm@20030000 {
+			clocks = <&cru PCLK_PWM01>;
+		};
+
+		pwm1: pwm@20030010 {
+			clocks = <&cru PCLK_PWM01>;
+		};
+
+		pwm2: pwm@20050020 {
+			clocks = <&cru PCLK_PWM23>;
+		};
+
+		pwm3: pwm@20050030 {
+			clocks = <&cru PCLK_PWM23>;
+		};
+
 		cru: cru@20000000 {
 			compatible = "rockchip,rk3188-cru";
 			reg = <0x20000000 0x1000>;
@@ -310,6 +326,30 @@
 							<RK_GPIO3 20 RK_FUNC_1 &pcfg_pull_none>;
 				};
 			};
+
+			pwm0 {
+				pwm0_pins: pwm0-pins {
+					rockchip,pins = <RK_GPIO3 27 RK_FUNC_1 &pcfg_pull_none>;
+				};
+			};
+
+			pwm1 {
+				pwm1_pins: pwm1-pins {
+					rockchip,pins = <RK_GPIO3 28 RK_FUNC_1 &pcfg_pull_none>;
+				};
+			};
+
+			pwm2 {
+				pwm2_pins: pwm2-pins {
+					rockchip,pins = <RK_GPIO3 29 RK_FUNC_1 &pcfg_pull_none>;
+				};
+			};
+
+			pwm3 {
+				pwm3_pins: pwm3-pins {
+					rockchip,pins = <RK_GPIO3 30 RK_FUNC_1 &pcfg_pull_none>;
+				};
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 2adf1cc9e..80811bb 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -135,5 +135,37 @@
 
 			status = "disabled";
 		};
+
+		pwm0: pwm@20030000 {
+			compatible = "rockchip,rk2928-pwm";
+			reg = <0x20030000 0x10>;
+			#pwm-cells = <2>;
+			clocks = <&clk_gates7 10>;
+			status = "disabled";
+		};
+
+		pwm1: pwm@20030010 {
+			compatible = "rockchip,rk2928-pwm";
+			reg = <0x20030010 0x10>;
+			#pwm-cells = <2>;
+			clocks = <&clk_gates7 10>;
+			status = "disabled";
+		};
+
+		pwm2: pwm@20050020 {
+			compatible = "rockchip,rk2928-pwm";
+			reg = <0x20050020 0x10>;
+			#pwm-cells = <2>;
+			clocks = <&clk_gates7 11>;
+			status = "disabled";
+		};
+
+		pwm3: pwm@20050030 {
+			compatible = "rockchip,rk2928-pwm";
+			reg = <0x20050030 0x10>;
+			#pwm-cells = <2>;
+			clocks = <&clk_gates7 11>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.10.4

