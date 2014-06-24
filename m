Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaFXVEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:04:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55332 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaFXVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:03:59 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/2] ARM: dts: msm: Add 8058 PMIC to ssbi bus
Date: Tue, 24 Jun 2014 14:03:54 -0700
Message-Id: <1403643834-4484-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403643834-4484-1-git-send-email-sboyd@codeaurora.org>
References: <1403643834-4484-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the PMIC and the sub-devices that are currently supported in
the kernel to the DT.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8660-surf.dts | 30 +++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8660.dtsi     | 42 +++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
index 45180adfadf1..ff7c53f58a06 100644
--- a/arch/arm/boot/dts/qcom-msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom-msm8660-surf.dts
@@ -1,3 +1,5 @@
+#include <dt-bindings/input/input.h>
+
 #include "qcom-msm8660.dtsi"
 
 / {
@@ -14,3 +16,31 @@
 		};
 	};
 };
+
+&pmicintc {
+	keypad@148 {
+		linux,keymap = <
+			MATRIX_KEY(0, 0, KEY_FN_F1)
+			MATRIX_KEY(0, 1, KEY_UP)
+			MATRIX_KEY(0, 2, KEY_LEFT)
+			MATRIX_KEY(0, 3, KEY_VOLUMEUP)
+			MATRIX_KEY(1, 0, KEY_FN_F2)
+			MATRIX_KEY(1, 1, KEY_RIGHT)
+			MATRIX_KEY(1, 2, KEY_DOWN)
+			MATRIX_KEY(1, 3, KEY_VOLUMEDOWN)
+			MATRIX_KEY(2, 3, KEY_ENTER)
+			MATRIX_KEY(4, 0, KEY_CAMERA_FOCUS)
+			MATRIX_KEY(4, 1, KEY_UP)
+			MATRIX_KEY(4, 2, KEY_LEFT)
+			MATRIX_KEY(4, 3, KEY_HOME)
+			MATRIX_KEY(4, 4, KEY_FN_F3)
+			MATRIX_KEY(5, 0, KEY_CAMERA)
+			MATRIX_KEY(5, 1, KEY_RIGHT)
+			MATRIX_KEY(5, 2, KEY_DOWN)
+			MATRIX_KEY(5, 3, KEY_BACK)
+			MATRIX_KEY(5, 4, KEY_MENU)
+			>;
+		keypad,num-rows = <6>;
+		keypad,num-columns = <5>;
+	};
+};
diff --git a/arch/arm/boot/dts/qcom-msm8660.dtsi b/arch/arm/boot/dts/qcom-msm8660.dtsi
index 53837aaa2f72..a3fd26b8139f 100644
--- a/arch/arm/boot/dts/qcom-msm8660.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8660.dtsi
@@ -103,6 +103,48 @@
 			compatible = "qcom,ssbi";
 			reg = <0x500000 0x1000>;
 			qcom,controller-type = "pmic-arbiter";
+
+			pmicintc: pmic@0 {
+				compatible = "qcom,pm8058";
+				interrupt-parent = <&msmgpio>;
+				interrupts = <88 8>;
+				#interrupt-cells = <2>;
+				interrupt-controller;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				pwrkey@1c {
+					compatible = "qcom,pm8058-pwrkey";
+					reg = <0x1c>;
+					interrupt-parent = <&pmicintc>;
+					interrupts = <50 1>, <51 1>;
+					debounce = <15625>;
+					pull-up;
+				};
+
+				keypad@148 {
+					compatible = "qcom,pm8058-keypad";
+					reg = <0x148>;
+					interrupt-parent = <&pmicintc>;
+					interrupts = <74 1>, <75 1>;
+					debounce = <15>;
+					scan-delay = <32>;
+					row-hold = <91500>;
+				};
+
+				rtc@11d {
+					compatible = "qcom,pm8058-rtc";
+					interrupt-parent = <&pmicintc>;
+					interrupts = <39 1>;
+					reg = <0x11d>;
+					allow-set-time;
+				};
+
+				vibrator@4a {
+					compatible = "qcom,pm8058-vib";
+					reg = <0x4a>;
+				};
+			};
 		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

