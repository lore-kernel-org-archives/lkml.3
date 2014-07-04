Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaGDGLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:11:36 -0400
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:53538 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbaGDGLd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:11:33 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2014 02:11:32 EDT
Date: Fri, 4 Jul 2014 11:35:46 +0530 (IST)
Subject: RE: [PATCH v3 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT binding
From: "Pramod Gurav" <pramod.gurav@smartplayin.com>
To: "Bjorn Andersson" <bjorn.andersson@sonymobile.com>
Cc: "Rob Herring" <robh+dt@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        "Mark Brown" <broonie@kernel.org>, "Kumar Gala" <galak@codeaurora.org>,
        "Lee Jones" <lee.jones@linaro.org>,
        "Josh Cartwright" <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <1402944372-31901-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com> 
 <1402944372-31901-2-git-send-email-bjorn.andersson@sonymobile.com>
Message-ID: <1404453946.73649442@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjorn,

-----Original Message-----
From: "Bjorn Andersson" <bjorn.andersson@sonymobile.com>
Sent: Tuesday, 17 June, 2014 12:16am
To: "Rob Herring" <robh+dt@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Liam Girdwood" <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>, "Kumar Gala" <galak@codeaurora.org>
Cc: "Lee Jones" <lee.jones@linaro.org>, "Josh Cartwright" <joshc@codeaurora.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v3 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT binding

Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
8960 and 8064 based devices. The binding currently describes the rpm
itself and the regulator subnodes.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 .../devicetree/bindings/soc/qcom/qcom,rpm.txt      | 260 +++++++++++++++++++++
 include/dt-bindings/soc/qcom,rpm.h                 | 142 +++++++++++
 2 files changed, 402 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
 create mode 100644 include/dt-bindings/soc/qcom,rpm.h

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
new file mode 100644
index 0000000..0366533
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
@@ -0,0 +1,260 @@
+Qualcomm Resource Power Manager (RPM)
+
+This driver is used to interface with the Resource Power Manager (RPM) found in
+various Qualcomm platforms. The RPM allows each component in the system to vote
+for state of the system resources, such as clocks, regulators and bus
+frequencies.
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-apq8064"
+		    "qcom,rpm-msm8660"
+		    "qcom,rpm-msm8960"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: two entries specifying the RPM's message ram and ipc register
+
+- reg-names:
+	Usage: required
+	Value type: <string-array>
+	Definition: must contain the following, in order:
+		    "msg_ram"
+		    "ipc"
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: three entries specifying the RPM's:
+		    1. acknowledgement interrupt
+		    2. error interrupt
+		    3. wakeup interrupt
+
+- interrupt-names:
+	Usage: required
+	Value type: <string-array>
+	Definition: must be the three strings "ack", "err" and "wakeup", in order
+
+- #address-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: must be 1
+
+- #size-cells:
+	Usage: required
+	Value type: <u32>
+	Definition: must be 0
+
+
+= SUBDEVICES
+
+The RPM exposes resources to its subnodes. The below bindings specify the set
+of valid subnodes that can operate on these resources.
+
+== Switch-mode Power Supply regulator
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-pm8058-smps"
+		    "qcom,rpm-pm8901-ftsmps"
+		    "qcom,rpm-pm8921-smps"
+		    "qcom,rpm-pm8921-ftsmps"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/soc/qcom,rpm.h>
+
+- bias-pull-down:
+	Usage: optional
+	Value type: <empty>
+	Definition: enable pull down of the regulator when inactive
+
+- qcom,switch-mode-frequency:
+	Usage: required
+	Value type: <u32>
+	Definition: Frequency (Hz) of the switch-mode power supply;
+		    must be one of:
+		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
+		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
+		    1480000, 1370000, 1280000, 1200000
+
+- qcom,force-mode-none:
+	Usage: optional (default if no other qcom,force-mode is specified)
+	Value type: <empty>
+	Defintion: indicates that the regulator should not be forced to any
+	           particular mode
+
+- qcom,force-mode-lpm:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            low-power-mode
+
+- qcom,force-mode-auto:
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be automatically pick
+	            operating mode
+
+- qcom,force-mode-hpm:
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            high-power-mode
+
+- qcom,force-mode-bypass: (only for 8960/8064)
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            bypass mode
+
+- qcom,power-mode-hysteretic:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the power supply should operate in hysteretic
+		    mode (defaults to qcom,power-mode-pwm if not specified)
+
+- qcom,power-mode-pwm:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the power supply should operate in pwm mode
+
+Standard regulator bindings are used inside switch mode power supply subnodes.
+Check Documentation/devicetree/bindings/regulator/regulator.txt for more
+details.
+
+== Low-dropout regulator
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-pm8058-pldo"
+		    "qcom,rpm-pm8058-nldo"
+		    "qcom,rpm-pm8901-pldo"
+		    "qcom,rpm-pm8901-nldo"
+		    "qcom,rpm-pm8921-pldo"
+		    "qcom,rpm-pm8921-nldo"
+		    "qcom,rpm-pm8921-nldo1200"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/soc/qcom,rpm.h>
+
+- bias-pull-down:
+	Usage: optional
+	Value type: <empty>
+	Definition: enable pull down of the regulator when inactive
+
+- qcom,force-mode-none:
+	Usage: optional (default if no other qcom,force-mode is specified)
+	Value type: <empty>
+	Defintion: indicates that the regulator should not be forced to any
+	           particular mode
+
+- qcom,force-mode-lpm:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            low-power-mode
+
+- qcom,force-mode-auto:
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be automatically pick
+	            operating mode
+
+- qcom,force-mode-hpm:
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            high-power-mode
+
+- qcom,force-mode-bypass: (only for 8960/8064)
+	Usage: optional (only available for 8960/8064)
+	Value type: <empty>
+	Definition: indicates that the regulator should be forced to operate in
+	            bypass mode
+
+Standard regulator bindings are used inside switch low-dropout regulator
+subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
+more details.
+
+== Negative Charge Pump
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-pm8058-ncp"
+		    "qcom,rpm-pm8921-ncp"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/soc/qcom,rpm.h>
+
+- qcom,switch-mode-frequency:
+	Usage: required
+	Value type: <u32>
+	Definition: Frequency (Hz) of the swith mode power supply;
+		    must be one of:
+		    19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
+		    2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
+		    1480000, 1370000, 1280000, 1200000
+
+Standard regulator bindings are used inside negative charge pump regulator
+subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
+more details.
+
+== Switch
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-pm8058-switch"
+		    "qcom,rpm-pm8901-switch"
+		    "qcom,rpm-pm8921-switch"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/soc/qcom/qcom,rpm.h>
+
+
+= EXAMPLE
+
+	#include <dt-bindings/soc/qcom,rpm.h>
+
+	rpm@108000 {
+		compatible = "qcom,rpm-msm8960";
+		reg = <0x108000 0x1000 0x2011008 0x4>;
+
+		interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
+		interrupt-names = "ack", "err", "wakeup";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pm8921_s1: pm8921-s1 {
+			compatible = "qcom,rpm-pm8921-smps";
+			reg = <QCOM_RPM_PM8921_S1>;
+
+			regulator-min-microvolt = <1225000>;
+			regulator-max-microvolt = <1225000>;
+			regulator-always-on;
+
+			bias-pull-down;
+
+			qcom,switch-mode-frequency = <3200000>;
+		};
+	};
+

I may be late here to comment, but came across this extra line at EOF when  I was applying these patches on my kernel just now.

diff --git a/include/dt-bindings/soc/qcom,rpm.h b/include/dt-bindings/soc/qcom,rpm.h
new file mode 100644
index 0000000..d9d840b
--- /dev/null
+++ b/include/dt-bindings/soc/qcom,rpm.h
@@ -0,0 +1,142 @@
+/*
+ * This header provides constants for the Qualcomm RPM bindings.
+ */
+
+#ifndef _DT_BINDINGS_SOC_QCOM_RPM_H
+#define _DT_BINDINGS_SOC_QCOM_RPM_H
+
+#define QCOM_RPM_APPS_FABRIC_ARB		1
+#define QCOM_RPM_APPS_FABRIC_CLK		2
+#define QCOM_RPM_APPS_FABRIC_HALT		3
+#define QCOM_RPM_APPS_FABRIC_IOCTL		4
+#define QCOM_RPM_APPS_FABRIC_MODE		5
+#define QCOM_RPM_APPS_L2_CACHE_CTL		6
+#define QCOM_RPM_CFPB_CLK			7
+#define QCOM_RPM_CXO_BUFFERS			8
+#define QCOM_RPM_CXO_CLK			9
+#define QCOM_RPM_DAYTONA_FABRIC_CLK		10
+#define QCOM_RPM_DDR_DMM			11
+#define QCOM_RPM_EBI1_CLK			12
+#define QCOM_RPM_HDMI_SWITCH			13
+#define QCOM_RPM_MMFPB_CLK			14
+#define QCOM_RPM_MM_FABRIC_ARB			15
+#define QCOM_RPM_MM_FABRIC_CLK			16
+#define QCOM_RPM_MM_FABRIC_HALT			17
+#define QCOM_RPM_MM_FABRIC_IOCTL		18
+#define QCOM_RPM_MM_FABRIC_MODE			19
+#define QCOM_RPM_PLL_4				20
+#define QCOM_RPM_PM8058_LDO0			21
+#define QCOM_RPM_PM8058_LDO1			22
+#define QCOM_RPM_PM8058_LDO2			23
+#define QCOM_RPM_PM8058_LDO3			24
+#define QCOM_RPM_PM8058_LDO4			25
+#define QCOM_RPM_PM8058_LDO5			26
+#define QCOM_RPM_PM8058_LDO6			27
+#define QCOM_RPM_PM8058_LDO7			28
+#define QCOM_RPM_PM8058_LDO8			29
+#define QCOM_RPM_PM8058_LDO9			30
+#define QCOM_RPM_PM8058_LDO10			31
+#define QCOM_RPM_PM8058_LDO11			32
+#define QCOM_RPM_PM8058_LDO12			33
+#define QCOM_RPM_PM8058_LDO13			34
+#define QCOM_RPM_PM8058_LDO14			35
+#define QCOM_RPM_PM8058_LDO15			36
+#define QCOM_RPM_PM8058_LDO16			37
+#define QCOM_RPM_PM8058_LDO17			38
+#define QCOM_RPM_PM8058_LDO18			39
+#define QCOM_RPM_PM8058_LDO19			40
+#define QCOM_RPM_PM8058_LDO20			41
+#define QCOM_RPM_PM8058_LDO21			42
+#define QCOM_RPM_PM8058_LDO22			43
+#define QCOM_RPM_PM8058_LDO23			44
+#define QCOM_RPM_PM8058_LDO24			45
+#define QCOM_RPM_PM8058_LDO25			46
+#define QCOM_RPM_PM8058_LVS0			47
+#define QCOM_RPM_PM8058_LVS1			48
+#define QCOM_RPM_PM8058_NCP			49
+#define QCOM_RPM_PM8058_SMPS0			50
+#define QCOM_RPM_PM8058_SMPS1			51
+#define QCOM_RPM_PM8058_SMPS2			52
+#define QCOM_RPM_PM8058_SMPS3			53
+#define QCOM_RPM_PM8058_SMPS4			54
+#define QCOM_RPM_PM8821_L1			55
+#define QCOM_RPM_PM8821_S1			56
+#define QCOM_RPM_PM8821_S2			57
+#define QCOM_RPM_PM8901_LDO0			58
+#define QCOM_RPM_PM8901_LDO1			59
+#define QCOM_RPM_PM8901_LDO2			60
+#define QCOM_RPM_PM8901_LDO3			61
+#define QCOM_RPM_PM8901_LDO4			62
+#define QCOM_RPM_PM8901_LDO5			63
+#define QCOM_RPM_PM8901_LDO6			64
+#define QCOM_RPM_PM8901_LVS0			65
+#define QCOM_RPM_PM8901_LVS1			66
+#define QCOM_RPM_PM8901_LVS2			67
+#define QCOM_RPM_PM8901_LVS3			68
+#define QCOM_RPM_PM8901_MVS			69
+#define QCOM_RPM_PM8901_SMPS0			70
+#define QCOM_RPM_PM8901_SMPS1			71
+#define QCOM_RPM_PM8901_SMPS2			72
+#define QCOM_RPM_PM8901_SMPS3			73
+#define QCOM_RPM_PM8901_SMPS4			74
+#define QCOM_RPM_PM8921_CLK1			75
+#define QCOM_RPM_PM8921_CLK2			76
+#define QCOM_RPM_PM8921_L1			77
+#define QCOM_RPM_PM8921_L2			78
+#define QCOM_RPM_PM8921_L3			79
+#define QCOM_RPM_PM8921_L4			80
+#define QCOM_RPM_PM8921_L5			81
+#define QCOM_RPM_PM8921_L6			82
+#define QCOM_RPM_PM8921_L7			83
+#define QCOM_RPM_PM8921_L8			84
+#define QCOM_RPM_PM8921_L9			85
+#define QCOM_RPM_PM8921_L10			86
+#define QCOM_RPM_PM8921_L11			87
+#define QCOM_RPM_PM8921_L12			88
+#define QCOM_RPM_PM8921_L13			89
+#define QCOM_RPM_PM8921_L14			90
+#define QCOM_RPM_PM8921_L15			91
+#define QCOM_RPM_PM8921_L16			92
+#define QCOM_RPM_PM8921_L17			93
+#define QCOM_RPM_PM8921_L18			94
+#define QCOM_RPM_PM8921_L19			95
+#define QCOM_RPM_PM8921_L20			96
+#define QCOM_RPM_PM8921_L21			97
+#define QCOM_RPM_PM8921_L22			98
+#define QCOM_RPM_PM8921_L23			99
+#define QCOM_RPM_PM8921_L24			100
+#define QCOM_RPM_PM8921_L25			101
+#define QCOM_RPM_PM8921_L26			102
+#define QCOM_RPM_PM8921_L27			103
+#define QCOM_RPM_PM8921_L28			104
+#define QCOM_RPM_PM8921_L29			105
+#define QCOM_RPM_PM8921_LVS1			106
+#define QCOM_RPM_PM8921_LVS2			107
+#define QCOM_RPM_PM8921_LVS3			108
+#define QCOM_RPM_PM8921_LVS4			109
+#define QCOM_RPM_PM8921_LVS5			110
+#define QCOM_RPM_PM8921_LVS6			111
+#define QCOM_RPM_PM8921_LVS7			112
+#define QCOM_RPM_PM8921_MVS			113
+#define QCOM_RPM_PM8921_NCP			114
+#define QCOM_RPM_PM8921_S1			115
+#define QCOM_RPM_PM8921_S2			116
+#define QCOM_RPM_PM8921_S3			117
+#define QCOM_RPM_PM8921_S4			118
+#define QCOM_RPM_PM8921_S5			119
+#define QCOM_RPM_PM8921_S6			120
+#define QCOM_RPM_PM8921_S7			121
+#define QCOM_RPM_PM8921_S8			122
+#define QCOM_RPM_PXO_CLK			123
+#define QCOM_RPM_QDSS_CLK			124
+#define QCOM_RPM_SFPB_CLK			125
+#define QCOM_RPM_SMI_CLK			126
+#define QCOM_RPM_SYS_FABRIC_ARB			127
+#define QCOM_RPM_SYS_FABRIC_CLK			128
+#define QCOM_RPM_SYS_FABRIC_HALT		129
+#define QCOM_RPM_SYS_FABRIC_IOCTL		130
+#define QCOM_RPM_SYS_FABRIC_MODE		131
+#define QCOM_RPM_USB_OTG_SWITCH			132
+#define QCOM_RPM_VDDMIN_GPIO			133
+
+#endif
-- 
1.8.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


