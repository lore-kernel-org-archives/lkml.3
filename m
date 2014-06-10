Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbaFJB21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:28:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47539 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537AbaFJB2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:23 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] arm: mmp: support clock device tree for mmp platforms
Date: Tue, 10 Jun 2014 09:27:48 +0800
Message-ID: <1402363668-25806-13-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
References: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_01:2014-06-09,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406100017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

The platforms including pxa168/pxa910/mmp2.

After add clock device tree support. There is no need
to maintain mmp2-dt.c because it is same as mmp-dt.c now.
The file will be removed.

Compiling test for pxa168 because of lacking of platform.
The platform is too old.

Functonality test for pxa910 and mmp2.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/boot/dts/mmp2-clock.dtsi   | 575 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mmp2.dtsi         |  11 +
 arch/arm/boot/dts/pxa168-clock.dtsi | 443 +++++++++++++++++++++++++++
 arch/arm/boot/dts/pxa168.dtsi       |  10 +
 arch/arm/boot/dts/pxa910-clock.dtsi | 388 ++++++++++++++++++++++++
 arch/arm/boot/dts/pxa910.dtsi       |  10 +
 arch/arm/mach-mmp/Kconfig           |   7 +-
 arch/arm/mach-mmp/Makefile          |   2 +-
 arch/arm/mach-mmp/common.h          |   1 +
 arch/arm/mach-mmp/mmp-dt.c          |  57 ++--
 arch/arm/mach-mmp/mmp2-dt.c         |  50 ----
 11 files changed, 1462 insertions(+), 92 deletions(-)
 create mode 100644 arch/arm/boot/dts/mmp2-clock.dtsi
 create mode 100644 arch/arm/boot/dts/pxa168-clock.dtsi
 create mode 100644 arch/arm/boot/dts/pxa910-clock.dtsi
 delete mode 100644 arch/arm/mach-mmp/mmp2-dt.c

diff --git a/arch/arm/boot/dts/mmp2-clock.dtsi b/arch/arm/boot/dts/mmp2-clock.dtsi
new file mode 100644
index 0000000..89f2279
--- /dev/null
+++ b/arch/arm/boot/dts/mmp2-clock.dtsi
@@ -0,0 +1,575 @@
+&soc_clocks {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	fixed_clocks: fixed_clocks {
+		compatible = "marvell,mmp-clk-master";
+		clk32: clk32 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+		vctcxo: vctcxo {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+		};
+		vctcxo_2: vctcxo_2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&vctcxo>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		vctcxo_4: vctcxo_4 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&vctcxo_2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		usb_pll: usb_pll {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <480000000>;
+		};
+		pll1: pll1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <624000000>;
+		};
+		pll1_2: pll1_2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_4: pll1_4 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_8: pll1_8 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_4>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_16: pll1_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_8>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_20: pll1_20 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_4>;
+			clock-div = <5>;
+			clock-mult = <1>;
+		};
+		pll1_3: pll1_3 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll1_6: pll1_6 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_3>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll1_12: pll1_12 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_6>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll2: pll2 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <960000000>;
+		};
+		pll2_2: pll2_2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll2_4: pll2_4 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll2_8: pll2_8 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_4>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll2_16: pll2_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_8>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll2_20: pll2_20 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_4>;
+			clock-div = <5>;
+			clock-mult = <1>;
+		};
+		pll2_3: pll2_3 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll2_6: pll2_6 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_3>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll2_12: pll2_12 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll2_6>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+	};
+	mpmu_clocks: mpmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4050000 0x1000>;
+		uart_pll: uart_pll {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-factor";
+			clocks = <&pll1_4>;
+			marvell,reg-offset = <0 0x14>;
+			marvell,mmp-clk-factor-factor = <2>;
+			marvell,mmp-clk-factor-bits-den = <13 0>;
+			marvell,mmp-clk-factor-bits-num = <13 16>;
+			marvell,mmp-clk-factor-table = <14634 2165>,
+						       <3521 689>,
+						       <9679 5728>,
+						       <15859 9451>;
+		};
+	};
+	apbc_clocks: apbc_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4015000 0x1000>;
+		twsi0_clock: twsi0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x4>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi1_clock: twsi1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x8>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi2_clock: twsi2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0xc>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi3_clock: twsi3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x10>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi4_clock: twsi4_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x7c>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi5_clock: twsi5_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x80>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		gpio_clock: gpio_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x38>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		kpc_clock: kpc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x18>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		rtc_clock: rtc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x0>;
+			marvell,mmp-clk-mask = <0x87 0x83 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		pwm0_clock: pwm0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x3c>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm1_clock: pwm1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x40>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm2_clock: pwm2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x44>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm3_clock: pwm3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x48>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		uart0_clock: uart0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart0_mux: uart0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&uart_pll &vctcxo>;
+				marvell,reg-offset = <0 0x2c>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart0_gate: uart0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x2c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart1_clock: uart1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart1_mux: uart1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&uart_pll &vctcxo>;
+				marvell,reg-offset = <0 0x30>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart1_gate: uart1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x30>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart2_clock: uart2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart2_mux: uart2_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&uart_pll &vctcxo>;
+				marvell,reg-offset = <0 0x34>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart2_gate: uart2_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x34>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart3_clock: uart3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart3_mux: uart3_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&uart_pll &vctcxo>;
+				marvell,reg-offset = <0 0x88>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart3_gate: uart3_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x88>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+
+		ssp0_clock: ssp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp0_mux: ssp0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&vctcxo_4 &vctcxo_2 &vctcxo &pll1_16>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp0_gate: ssp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp1_clock: ssp1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp1_mux: ssp1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&vctcxo_4 &vctcxo_2 &vctcxo &pll1_16>;
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp1_gate: ssp1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp2_clock: ssp2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp2_mux: ssp2_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&vctcxo_4 &vctcxo_2 &vctcxo &pll1_16>;
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp2_gate: ssp2_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp3_clock: ssp3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp3_mux: ssp3_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&vctcxo_4 &vctcxo_2 &vctcxo &pll1_16>;
+				marvell,reg-offset = <0 0x5c>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp3_gate: ssp3_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x5c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+	};
+	apmu_clocks: apmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4282800 0x1000>;
+		sdh_mix: sdh_mix {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mix";
+			clocks = <&pll1_4 &pll2 &usb_pll &pll1>;
+			marvell,reg-offset = <0 0x54>;
+			marvell,mmp-clk-bits-mux = <2 8>;
+			marvell,mmp-clk-bits-div = <4 10>;
+			marvell,mmp-clk-div-one-based;
+		};
+		sdh0_clock: sdh0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&sdh_mix>;
+			marvell,reg-offset = <0 0x54>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		sdh1_clock: sdh1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&sdh_mix>;
+			marvell,reg-offset = <0 0x58>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		sdh2_clock: sdh2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&sdh_mix>;
+			marvell,reg-offset = <0 0xe8>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		sdh3_clock: sdh3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&sdh_mix>;
+			marvell,reg-offset = <0 0xec>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		usb_clock: usb_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x5c>;
+			marvell,mmp-clk-mask = <0x9 0x9 0x0>;
+		};
+		disp0_mux: disp0_mux {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mux";
+			marvell,reg-offset = <0 0x4c>;
+			clocks = <&pll1 &pll1_16 &pll2 &vctcxo>;
+			marvell,mmp-clk-bits-mux = <2 6>;
+		};
+		disp0_clock: disp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			disp0_div: disp0_div {
+				compatible = "marvell,mmp-clk-div";
+				marvell,reg-offset = <0 0x4c>;
+				clocks = <&disp0_mux>;
+				marvell,mmp-clk-bits-div = <4 8>;
+				marvell,mmp-clk-div-one-based;
+			};
+			disp0_gate: disp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4c>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		disp1_clock: disp1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			disp1_mix: disp1_mix {
+				compatible = "marvell,mmp-clk-mix";
+				marvell,reg-offset = <0 0x110>;
+				clocks = <&pll1 &pll1_16 &pll2 &vctcxo>;
+				marvell,mmp-clk-bits-mux = <2 6>;
+				marvell,mmp-clk-bits-div = <4 8>;
+				marvell,mmp-clk-div-one-based;
+			};
+			disp1_gate: disp1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x110>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		ccic_arbiter: ccic_arbiter {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-mask = <0x1800 0x1800 0x0>;
+		};
+		ccic0_mix: ccic0_mix {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mux";
+			clocks = <&pll1_2 &pll1_16 &vctcxo>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-bits-mux = <2 6>;
+			marvell,mmp-clk-bits-div = <4 17>;
+			marvell,mmp-clk-div-one-based;
+		};
+		ccic0_clock: ccic0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic0_mix>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		ccic0_phy_clock: ccic0_phy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic0_mix>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-mask = <0x24 0x24 0x0>;
+		};
+		ccic0_sphy_clock: ccic0_sphy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ccic0_sphy_div: ccic0_sphy_div {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-div";
+				clocks = <&ccic0_mix>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-div = <5 10>;
+			};
+			ccic0_sphy_gate: ccic0_sphy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x300 0x300 0x0>;
+			};
+		};
+		ccic1_mix: ccic1_mix {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mux";
+			clocks = <&pll1_2 &pll1_16 &vctcxo>;
+			marvell,reg-offset = <0 0xf4>;
+			marvell,mmp-clk-bits-mux = <2 6>;
+			marvell,mmp-clk-bits-div = <4 16>;
+			marvell,mmp-clk-div-one-based;
+		};
+		ccic1_clock: ccic1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic1_mix>;
+			marvell,reg-offset = <0 0xf4>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		ccic1_phy_clock: ccic1_phy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic1_mix>;
+			marvell,reg-offset = <0 0xf4>;
+			marvell,mmp-clk-mask = <0x24 0x24 0x0>;
+		};
+		ccic1_sphy_clock: ccic1_sphy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ccic1_sphy_div: ccic1_sphy_div {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-div";
+				clocks = <&ccic1_mix>;
+				marvell,reg-offset = <0 0xf4>;
+				marvell,mmp-clk-bits-div = <5 10>;
+			};
+			ccic1_sphy_gate: ccic1_sphy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0xf4>;
+				marvell,mmp-clk-mask = <0x300 0x300 0x0>;
+			};
+		};
+
+	};
+};
diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 4e8b08c..66bc8db 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -135,6 +135,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4030000 0x1000>;
 				interrupts = <27>;
+				clocks = <&uart0_clock>;
 				status = "disabled";
 			};
 
@@ -142,6 +143,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <28>;
+				clocks = <&uart1_clock>;
 				status = "disabled";
 			};
 
@@ -149,6 +151,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <24>;
+				clocks = <&uart2_clock>;
 				status = "disabled";
 			};
 
@@ -156,6 +159,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4016000 0x1000>;
 				interrupts = <46>;
+				clocks = <&uart3_clock>;
 				status = "disabled";
 			};
 
@@ -164,6 +168,7 @@
 				#address-cells = <1>;
 				#size-cells = <1>;
 				reg = <0xd4019000 0x1000>;
+				clocks = <&gpio_clock>;
 				gpio-controller;
 				#gpio-cells = <2>;
 				interrupts = <49>;
@@ -201,6 +206,7 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&twsi0_clock>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				mrvl,i2c-fast-mode;
@@ -211,6 +217,7 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
+				clocks = <&twsi1_clock>;
 				status = "disabled";
 			};
 
@@ -220,8 +227,12 @@
 				interrupts = <1 0>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
 				interrupt-parent = <&intcmux5>;
+				clocks = <&rtc_clock>;
 				status = "disabled";
 			};
 		};
+		soc_clocks: clocks{
+		};
 	};
 };
+/include/ "mmp2-clock.dtsi"
diff --git a/arch/arm/boot/dts/pxa168-clock.dtsi b/arch/arm/boot/dts/pxa168-clock.dtsi
new file mode 100644
index 0000000..8bd331e
--- /dev/null
+++ b/arch/arm/boot/dts/pxa168-clock.dtsi
@@ -0,0 +1,443 @@
+&soc_clocks {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	fixed_clocks: fixed_clocks {
+		compatible = "marvell,mmp-clk-master";
+		clk32: clk32 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+		vctcxo: vctcxo {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+		};
+		pll1: pll1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <624000000>;
+		};
+		pll1_2: pll1_2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_4: pll1_4 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_8: pll1_8 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_4>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_16: pll1_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_8>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_6: pll1_6 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_2>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll1_12: pll1_12 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_6>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_24: pll1_24 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_12>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_48: pll1_48 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_24>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_96: pll1_96 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_48>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_13: pll1_13 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <13>;
+			clock-mult = <1>;
+		};
+		pll1_13_1_5: pll1_13_1_5 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_13>;
+			clock-div = <3>;
+			clock-mult = <2>;
+		};
+		pll1_2_1_5: pll1_2_1_5 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <3>;
+			clock-mult = <2>;
+		};
+		pll1_3_16: pll1_3_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <16>;
+			clock-mult = <3>;
+		};
+	};
+	mpmu_clocks: mpmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4050000 0x1000>;
+		uart_pll: uart_pll {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-factor";
+			clocks = <&pll1_4>;
+			marvell,reg-offset = <0 0x14>;
+			marvell,mmp-clk-factor-factor = <2>;
+			marvell,mmp-clk-factor-bits-den = <13 0>;
+			marvell,mmp-clk-factor-bits-num = <13 16>;
+			marvell,mmp-clk-factor-table = <8125 1536>;
+		};
+	};
+	apbc_clocks: apbc_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4015000 0x1000>;
+		twsi0_clock: twsi0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_13_1_5>;
+			marvell,reg-offset = <0 0x2c>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		twsi1_clock: twsi1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_13_1_5>;
+			marvell,reg-offset = <0 0x6c>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		gpio_clock: gpio_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x8>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		kpc_clock: kpc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x30>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		rtc_clock: rtc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x28>;
+			marvell,mmp-clk-mask = <0x87 0x83 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		pwm0_clock: pwm0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0xc>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm1_clock: pwm1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x10>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm2_clock: pwm2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x14>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm3_clock: pwm3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x18>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		uart0_clock: uart0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart0_mux: uart0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x0>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart0_gate: uart0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x0>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart1_clock: uart1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart1_mux: uart1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart1_gate: uart1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart2_clock: uart2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart2_mux: uart2_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x70>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart2_gate: uart2_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		ssp0_clock: ssp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp0_mux: ssp0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x81c>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp0_gate: ssp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x81c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp1_clock: ssp1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp1_mux: ssp1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x820>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp1_gate: ssp1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x820>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp2_clock: ssp2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp2_mux: ssp2_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x84c>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp2_gate: ssp2_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x84c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp3_clock: ssp3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp3_mux: ssp3_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x858>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp3_gate: ssp3_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x858>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp4_clock: ssp4_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp4_mux: ssp4_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x85c>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp4_gate: ssp4_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x85c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+	};
+	apmu_clocks: apmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4282800 0x1000>;
+		dfc_clock: dfc_clock {
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_4>;
+			marvell,reg-offset = <0 0x60>;
+			marvell,mmp-clk-mask = <0x19b 0x19b 0x0>;
+		};
+		sdh0_clock: sdh0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			sdh0_mux: sdh0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_12 &pll1_13>;
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			sdh0_gate: sdh0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		sdh1_clock: sdh1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			sdh1_mux: sdh1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_12 &pll1_13>;
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			sdh1_gate: sdh1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		usb_clock: usb_clock {
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x5c>;
+			marvell,mmp-clk-mask = <0x9 0x9 0x0>;
+		};
+		sph_clock: sph_clock {
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x5c>;
+			marvell,mmp-clk-mask = <0x12 0x12 0x0>;
+		};
+		disp0_clock: disp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			disp0_mux: disp0_mux {
+				compatible = "marvell,mmp-clk-mux";
+				marvell,reg-offset = <0 0x4c>;
+				clocks = <&pll1_2 &pll1_12>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			disp0_gate: disp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4c>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		disp0_h_clock: disp0_h_clock {
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x4c>;
+			marvell,mmp-clk-mask = <0x24 0x24 0x0>;
+		};
+		ccic0_mux: ccic0_mux {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mux";
+			clocks = <&pll1_2 &pll1_12>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-bits-mux = <1 6>;
+		};
+		ccic0_clock: ccic0_clock {
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic0_mux>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		ccic0_phy_clock: ccic0_phy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-composite";
+			ccic0_phy_mux: ccic0_phy_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_2 &pll1_12>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-mux = <1 7>;
+			};
+			ccic0_phy_gate: ccic0_phy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x24 0x24 0x0>;
+			};
+		};
+		ccic0_sphy_clock: ccic0_sphy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-composite";
+			ccic0_sphy_div: ccic0_sphy_div {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-div";
+				clocks = <&ccic0_mux>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-div = <5 10>;
+			};
+			ccic0_sphy_gate: ccic0_sphy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x300 0x300 0x0>;
+			};
+		};
+
+	};
+};
diff --git a/arch/arm/boot/dts/pxa168.dtsi b/arch/arm/boot/dts/pxa168.dtsi
index 975dad2..d16aa1b 100644
--- a/arch/arm/boot/dts/pxa168.dtsi
+++ b/arch/arm/boot/dts/pxa168.dtsi
@@ -59,6 +59,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
+				clocks = <&uart0_clock>;
 				status = "disabled";
 			};
 
@@ -66,6 +67,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
+				clocks = <&uart1_clock>;
 				status = "disabled";
 			};
 
@@ -73,6 +75,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4026000 0x1000>;
 				interrupts = <29>;
+				clocks = <&uart2_clock>;
 				status = "disabled";
 			};
 
@@ -81,6 +84,7 @@
 				#address-cells = <1>;
 				#size-cells = <1>;
 				reg = <0xd4019000 0x1000>;
+				clocks = <&gpio_clock>;
 				gpio-controller;
 				#gpio-cells = <2>;
 				interrupts = <49>;
@@ -110,6 +114,7 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&twsi0_clock>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
@@ -118,6 +123,7 @@
 				compatible = "mrvl,mmp-twsi";
 				reg = <0xd4025000 0x1000>;
 				interrupts = <58>;
+				clocks = <&twsi1_clock>;
 				status = "disabled";
 			};
 
@@ -126,8 +132,12 @@
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
+				clocks = <&rtc_clock>;
 				status = "disabled";
 			};
 		};
+		soc_clocks: clocks{
+		};
 	};
 };
+/include/ "pxa168-clock.dtsi"
diff --git a/arch/arm/boot/dts/pxa910-clock.dtsi b/arch/arm/boot/dts/pxa910-clock.dtsi
new file mode 100644
index 0000000..e9c58e2
--- /dev/null
+++ b/arch/arm/boot/dts/pxa910-clock.dtsi
@@ -0,0 +1,388 @@
+&soc_clocks {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	fixed_clocks: fixed_clocks {
+		compatible = "marvell,mmp-clk-master";
+		clk32: clk32 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+		vctcxo: vctcxo {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <26000000>;
+		};
+		pll1: pll1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <624000000>;
+		};
+		pll1_2: pll1_2 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_4: pll1_4 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_2>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_8: pll1_8 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_4>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_16: pll1_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_8>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_6: pll1_6 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_2>;
+			clock-div = <3>;
+			clock-mult = <1>;
+		};
+		pll1_12: pll1_12 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_6>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_24: pll1_24 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_12>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_48: pll1_48 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_24>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_96: pll1_96 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_48>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+		pll1_13: pll1_13 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <13>;
+			clock-mult = <1>;
+		};
+		pll1_13_1_5: pll1_13_1_5 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1_13>;
+			clock-div = <3>;
+			clock-mult = <2>;
+		};
+		pll1_2_1_5: pll1_2_1_5 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <3>;
+			clock-mult = <2>;
+		};
+		pll1_3_16: pll1_3_16 {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&pll1>;
+			clock-div = <16>;
+			clock-mult = <3>;
+		};
+	};
+	mpmu_clocks: mpmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4050000 0x1000>;
+		uart_pll: uart_pll {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-factor";
+			clocks = <&pll1_4>;
+			marvell,reg-offset = <0 0x14>;
+			marvell,mmp-clk-factor-factor = <2>;
+			marvell,mmp-clk-factor-bits-den = <13 0>;
+			marvell,mmp-clk-factor-bits-num = <13 16>;
+			marvell,mmp-clk-factor-table = <8125 1536>;
+		};
+	};
+	apbc_clocks: apbc_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4015000 0x1000>;
+		twsi0_clock: twsi0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_13_1_5>;
+			marvell,reg-offset = <0 0x2c>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		gpio_clock: gpio_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&vctcxo>;
+			marvell,reg-offset = <0 0x8>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		kpc_clock: kpc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x30>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		rtc_clock: rtc_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&clk32>;
+			marvell,reg-offset = <0 0x28>;
+			marvell,mmp-clk-mask = <0x87 0x83 0x4>;
+			marvell,mmp-clk-gate-need-delay;
+		};
+		pwm0_clock: pwm0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0xc>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm1_clock: pwm1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x10>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm2_clock: pwm2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x14>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		pwm3_clock: pwm3_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_48>;
+			marvell,reg-offset = <0 0x18>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+		uart0_clock: uart0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart0_mux: uart0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x0>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart0_gate: uart0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x0>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		uart1_clock: uart1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart1_mux: uart1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart1_gate: uart1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		ssp0_clock: ssp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp0_mux: ssp0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x81c>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp0_gate: ssp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x81c>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+		ssp1_clock: ssp1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ssp1_mux: ssp1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_96 &pll1_48 &pll1_24 &pll1_12>;
+				marvell,reg-offset = <0 0x820>;
+				marvell,mmp-clk-bits-mux = <3 4>;
+			};
+			ssp1_gate: ssp1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x820>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+			};
+		};
+	};
+	apbcp_clock: apbcp_clock {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd403b000 0x1000>;
+		uart2_clock: uart2_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			uart2_mux: uart2_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_3_16 &uart_pll>;
+				marvell,reg-offset = <0 0x70>;
+				marvell,mmp-clk-bits-mux = <1 4>;
+			};
+			uart2_gate: uart2_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4>;
+				marvell,mmp-clk-mask = <0x7 0x3 0x0>;
+			};
+		};
+		twsi1_clock: twsi1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&pll1_13_1_5>;
+			marvell,reg-offset = <0 0x28>;
+			marvell,mmp-clk-mask = <0x7 0x3 0x4>;
+		};
+	};
+	apmu_clocks: apmu_clocks {
+		compatible = "marvell,mmp-clk-master";
+		reg = <0xd4282800 0x1000>;
+		sdh0_clock: sdh0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			sdh0_mux: sdh0_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_12 &pll1_13>;
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			sdh0_gate: sdh0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x54>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		sdh1_clock: sdh1_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			sdh1_mux: sdh1_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_12 &pll1_13>;
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			sdh1_gate: sdh1_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x58>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		usb_clock: usb_clock {
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x5c>;
+			marvell,mmp-clk-mask = <0x9 0x9 0x0>;
+		};
+		sph_clock: sph_clock {
+			compatible = "marvell,mmp-clk-gate";
+			marvell,reg-offset = <0 0x5c>;
+			marvell,mmp-clk-mask = <0x12 0x12 0x0>;
+		};
+		disp0_clock: disp0_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			disp0_mux: disp0_mux {
+				compatible = "marvell,mmp-clk-mux";
+				marvell,reg-offset = <0 0x4c>;
+				clocks = <&pll1_2 &pll1_12>;
+				marvell,mmp-clk-bits-mux = <1 6>;
+			};
+			disp0_gate: disp0_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x4c>;
+				marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+			};
+		};
+		ccic0_mux: ccic0_mux {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-mux";
+			clocks = <&pll1_2 &pll1_12>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-bits-mux = <1 6>;
+		};
+		ccic0_clock: ccic0_clock {
+			compatible = "marvell,mmp-clk-gate";
+			clocks = <&ccic0_mux>;
+			marvell,reg-offset = <0 0x50>;
+			marvell,mmp-clk-mask = <0x1b 0x1b 0x0>;
+		};
+		ccic0_phy_clock: ccic0_phy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ccic0_phy_mux: ccic0_phy_mux {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-mux";
+				clocks = <&pll1_2 &pll1_12>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-mux = <1 7>;
+			};
+			ccic0_phy_gate: ccic0_phy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x24 0x24 0x0>;
+			};
+		};
+		ccic0_sphy_clock: ccic0_sphy_clock {
+			#clock-cells = <0>;
+			compatible = "marvell,mmp-clk-general-composite";
+			ccic0_sphy_div: ccic0_sphy_div {
+				#clock-cells = <0>;
+				compatible = "marvell,mmp-clk-div";
+				clocks = <&ccic0_mux>;
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-bits-div = <5 10>;
+			};
+			ccic0_sphy_gate: ccic0_sphy_gate {
+				compatible = "marvell,mmp-clk-gate";
+				marvell,reg-offset = <0 0x50>;
+				marvell,mmp-clk-mask = <0x300 0x300 0x0>;
+			};
+		};
+
+	};
+};
diff --git a/arch/arm/boot/dts/pxa910.dtsi b/arch/arm/boot/dts/pxa910.dtsi
index 0247c62..cc06c5d 100644
--- a/arch/arm/boot/dts/pxa910.dtsi
+++ b/arch/arm/boot/dts/pxa910.dtsi
@@ -71,6 +71,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4017000 0x1000>;
 				interrupts = <27>;
+				clocks = <&uart0_clock>;
 				status = "disabled";
 			};
 
@@ -78,6 +79,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4018000 0x1000>;
 				interrupts = <28>;
+				clocks = <&uart1_clock>;
 				status = "disabled";
 			};
 
@@ -85,6 +87,7 @@
 				compatible = "mrvl,mmp-uart";
 				reg = <0xd4036000 0x1000>;
 				interrupts = <59>;
+				clocks = <&uart2_clock>;
 				status = "disabled";
 			};
 
@@ -93,6 +96,7 @@
 				#address-cells = <1>;
 				#size-cells = <1>;
 				reg = <0xd4019000 0x1000>;
+				clocks = <&gpio_clock>;
 				gpio-controller;
 				#gpio-cells = <2>;
 				interrupts = <49>;
@@ -124,6 +128,7 @@
 				#size-cells = <0>;
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
+				clocks = <&twsi0_clock>;
 				mrvl,i2c-fast-mode;
 				status = "disabled";
 			};
@@ -134,6 +139,7 @@
 				#size-cells = <0>;
 				reg = <0xd4037000 0x1000>;
 				interrupts = <54>;
+				clocks = <&twsi1_clock>;
 				status = "disabled";
 			};
 
@@ -142,8 +148,12 @@
 				reg = <0xd4010000 0x1000>;
 				interrupts = <5 6>;
 				interrupt-names = "rtc 1Hz", "rtc alarm";
+				clocks = <&rtc_clock>;
 				status = "disabled";
 			};
 		};
+		soc_clocks: clocks{
+		};
 	};
 };
+/include/ "pxa910-clock.dtsi"
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index ebdba87..ce15826 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -86,8 +86,8 @@ config MACH_GPLUGD
 
 config MACH_MMP_DT
 	bool "Support MMP (ARMv5) platforms from device tree"
-	select CPU_PXA168
-	select CPU_PXA910
+	select COMMON_CLK
+	select CPU_MOHAWK
 	select USE_OF
 	select PINCTRL
 	select PINCTRL_SINGLE
@@ -99,7 +99,8 @@ config MACH_MMP_DT
 config MACH_MMP2_DT
 	bool "Support MMP2 (ARMv7) platforms from device tree"
 	depends on !CPU_MOHAWK
-	select CPU_MMP2
+	select COMMON_CLK
+	select CPU_PJ4
 	select USE_OF
 	select PINCTRL
 	select PINCTRL_SINGLE
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 98f0f63..ab54ff3 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -31,6 +31,6 @@ obj-$(CONFIG_MACH_BROWNSTONE)	+= brownstone.o
 obj-$(CONFIG_MACH_FLINT)	+= flint.o
 obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
 obj-$(CONFIG_MACH_MMP_DT)	+= mmp-dt.o
-obj-$(CONFIG_MACH_MMP2_DT)	+= mmp2-dt.o
+obj-$(CONFIG_MACH_MMP2_DT)	+= mmp-dt.o
 obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
 obj-$(CONFIG_MACH_GPLUGD)	+= gplugd.o
diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
index cf445ba..9dcf19c 100644
--- a/arch/arm/mach-mmp/common.h
+++ b/arch/arm/mach-mmp/common.h
@@ -8,3 +8,4 @@ extern void mmp_restart(enum reboot_mode, const char *);
 extern void __init pxa168_clk_init(void);
 extern void __init pxa910_clk_init(void);
 extern void __init mmp2_clk_init(void);
+extern void mmp_clk_of_init(void);
diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index cca529c..714735e 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -13,61 +13,42 @@
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
+#include <asm/hardware/cache-tauros2.h>
 
 #include "common.h"
 
 extern void __init mmp_dt_init_timer(void);
 
-static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4026000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
-};
-
-static const struct of_dev_auxdata pxa910_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
-};
-
-static void __init pxa168_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     pxa168_auxdata_lookup, NULL);
-}
-
-static void __init pxa910_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     pxa910_auxdata_lookup, NULL);
-}
-
 static const char *mmp_dt_board_compat[] __initdata = {
 	"mrvl,pxa168-aspenite",
 	"mrvl,pxa910-dkb",
+	"mrvl,mmp2-brownstone",
 	NULL,
 };
 
+void __init mmp_init_timer(void)
+{
+#ifdef CONFIG_CACHE_TAUROS2
+	tauros2_init(0);
+#endif
+	mmp_clk_of_init();
+	mmp_dt_init_timer();
+}
+
 DT_MACHINE_START(PXA168_DT, "Marvell PXA168 (Device Tree Support)")
 	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= pxa168_dt_init,
+	.init_time	= mmp_init_timer,
 	.dt_compat	= mmp_dt_board_compat,
 MACHINE_END
 
 DT_MACHINE_START(PXA910_DT, "Marvell PXA910 (Device Tree Support)")
 	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= pxa910_dt_init,
+	.init_time	= mmp_init_timer,
+	.dt_compat	= mmp_dt_board_compat,
+MACHINE_END
+
+DT_MACHINE_START(MMP2_DT, "Marvell MMP2 (Device Tree Support)")
+	.map_io		= mmp_map_io,
+	.init_time	= mmp_init_timer,
 	.dt_compat	= mmp_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
deleted file mode 100644
index 023cb45..0000000
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- *  linux/arch/arm/mach-mmp/mmp2-dt.c
- *
- *  Copyright (C) 2012 Marvell Technology Group Ltd.
- *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  publishhed by the Free Software Foundation.
- */
-
-#include <linux/io.h>
-#include <linux/irqchip.h>
-#include <linux/of_platform.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-#include "common.h"
-
-extern void __init mmp_dt_init_timer(void);
-
-static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.2", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4016000, "pxa2xx-uart.3", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4025000, "pxa2xx-i2c.1", NULL),
-	OF_DEV_AUXDATA("marvell,mmp-gpio", 0xd4019000, "mmp2-gpio", NULL),
-	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
-	{}
-};
-
-static void __init mmp2_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table,
-			     mmp2_auxdata_lookup, NULL);
-}
-
-static const char *mmp2_dt_board_compat[] __initdata = {
-	"mrvl,mmp2-brownstone",
-	NULL,
-};
-
-DT_MACHINE_START(MMP2_DT, "Marvell MMP2 (Device Tree Support)")
-	.map_io		= mmp_map_io,
-	.init_time	= mmp_dt_init_timer,
-	.init_machine	= mmp2_dt_init,
-	.dt_compat	= mmp2_dt_board_compat,
-MACHINE_END
-- 
1.8.3.2

