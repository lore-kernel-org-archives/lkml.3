Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaHYW7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:59:35 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:64415 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652AbaHYW7c (ORCPT
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
Subject: [PATCH v5 3/3] ARM: dts: Enable PWM backlight on rk3288-evb
Date: Mon, 25 Aug 2014 15:59:27 -0700
Message-Id: <1409007567-23523-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409007567-23523-1-git-send-email-dianders@chromium.org>
References: <1409007567-23523-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM0 is the PWM associated with the LCD backlight.  Enable it.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v5: None
Changes in v4: None
Changes in v3:
- Fix space to tab in 2 places in DTS.
- Make sure PWM is upper case in prose.

 arch/arm/boot/dts/rk3288-evb.dtsi | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 2964370..98b69d0 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -10,6 +10,7 @@
  * GNU General Public License for more details.
  */
 
+#include <dt-bindings/pwm/pwm.h>
 #include "rk3288.dtsi"
 
 / {
@@ -17,6 +18,48 @@
 		reg = <0x0 0x80000000>;
 	};
 
+	backlight {
+		compatible = "pwm-backlight";
+		brightness-levels = <
+			  0   1   2   3   4   5   6   7
+			  8   9  10  11  12  13  14  15
+			 16  17  18  19  20  21  22  23
+			 24  25  26  27  28  29  30  31
+			 32  33  34  35  36  37  38  39
+			 40  41  42  43  44  45  46  47
+			 48  49  50  51  52  53  54  55
+			 56  57  58  59  60  61  62  63
+			 64  65  66  67  68  69  70  71
+			 72  73  74  75  76  77  78  79
+			 80  81  82  83  84  85  86  87
+			 88  89  90  91  92  93  94  95
+			 96  97  98  99 100 101 102 103
+			104 105 106 107 108 109 110 111
+			112 113 114 115 116 117 118 119
+			120 121 122 123 124 125 126 127
+			128 129 130 131 132 133 134 135
+			136 137 138 139 140 141 142 143
+			144 145 146 147 148 149 150 151
+			152 153 154 155 156 157 158 159
+			160 161 162 163 164 165 166 167
+			168 169 170 171 172 173 174 175
+			176 177 178 179 180 181 182 183
+			184 185 186 187 188 189 190 191
+			192 193 194 195 196 197 198 199
+			200 201 202 203 204 205 206 207
+			208 209 210 211 212 213 214 215
+			216 217 218 219 220 221 222 223
+			224 225 226 227 228 229 230 231
+			232 233 234 235 236 237 238 239
+			240 241 242 243 244 245 246 247
+			248 249 250 251 252 253 254 255>;
+		default-brightness-level = <128>;
+		enable-gpios = <&gpio7 2 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&bl_en>;
+		pwms = <&pwm0 0 1000000 PWM_POLARITY_INVERTED>;
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 		#address-cells = <1>;
@@ -81,6 +124,10 @@
 	status = "okay";
 };
 
+&pwm0 {
+	status = "okay";
+};
+
 &uart0 {
 	status = "okay";
 };
@@ -102,6 +149,12 @@
 };
 
 &pinctrl {
+	backlight {
+		bl_en: bl-en {
+			rockchip,pins = <7 2 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	buttons {
 		pwrbtn: pwrbtn {
 			rockchip,pins = <0 5 RK_FUNC_GPIO &pcfg_pull_up>;
-- 
2.1.0.rc2.206.gedb03e5

