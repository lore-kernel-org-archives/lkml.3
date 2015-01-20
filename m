Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbbATKQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:16:01 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:60569 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbbATKPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:15:21 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v5 1/2] DT: iio: vadc: document dt binding
Date: Tue, 20 Jan 2015 12:15:21 +0200
Message-Id: <1421748922-8933-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421748922-8933-1-git-send-email-iivanov@mm-sol.com>
References: <1421748922-8933-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanimir Varbanov <svarbanov@mm-sol.com>

Document DT binding for Qualcomm SPMI PMIC voltage ADC
driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt | 129 +++++++++++++++++++++
 include/dt-bindings/iio/qcom,spmi-vadc.h           | 119 +++++++++++++++++++
 2 files changed, 248 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
 create mode 100644 include/dt-bindings/iio/qcom,spmi-vadc.h

diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
new file mode 100644
index 0000000..0fb4613
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
@@ -0,0 +1,129 @@
+Qualcomm's SPMI PMIC voltage ADC
+
+SPMI PMIC voltage ADC (VADC) provides interface to clients to read
+voltage. The VADC is a 15-bit sigma-delta ADC.
+
+VADC node:
+
+- compatible:
+    Usage: required
+    Value type: <string>
+    Definition: Should contain "qcom,spmi-vadc".
+
+- reg:
+    Usage: required
+    Value type: <prop-encoded-array>
+    Definition: VADC base address and length in the SPMI PMIC register map.
+
+- #address-cells:
+    Usage: required
+    Value type: <u32>
+    Definition: Must be one. Child node 'reg' property should define ADC
+            channel number.
+
+- #size-cells:
+    Usage: required
+    Value type: <u32>
+    Definition: Must be zero.
+
+- #io-channel-cells:
+    Usage: required
+    Value type: <u32>
+    Definition: Must be one. For details about IIO bindings see:
+            Documentation/devicetree/bindings/iio/iio-bindings.txt
+
+- interrupts:
+    Usage: optional
+    Value type: <prop-encoded-array>
+    Definition: End of conversion interrupt.
+
+Channel node properties:
+
+- reg:
+    Usage: required
+    Value type: <u32>
+    Definition: ADC channel number.
+            See include/dt-bindings/iio/qcom,spmi-vadc.h
+
+- qcom,decimation:
+    Usage: optional
+    Value type: <u32>
+    Definition: This parameter is used to decrease ADC sampling rate.
+            Quicker measurements can be made by reducing decimation ratio.
+            Valid values are 512, 1024, 2048, 4096.
+            If property is not found, default value of 512 will be used.
+
+- qcom,pre-scaling:
+    Usage: optional
+    Value type: <u32 array>
+    Definition: Used for scaling the channel input signal before the signal is
+            fed to VADC. The configuration for this node is to know the
+            pre-determined ratio and use it for post scaling. Select one from
+            the following options.
+            <1 1>, <1 3>, <1 4>, <1 6>, <1 20>, <1 8>, <10 81>, <1 10>
+            If property is not found default value depending on chip will be used.
+
+- qcom,ratiometric:
+    Usage: optional
+    Value type: <empty>
+    Definition: Channel calibration type. If this property is specified
+            VADC will use the VDD reference (1.8V) and GND for channel
+            calibration. If property is not found, channel will be
+            calibrated with 0.625V and 1.25V reference channels, also
+            known as absolute calibration.
+
+- qcom,hw-settle-time:
+    Usage: optional
+    Value type: <u32>
+    Definition: Time between AMUX getting configured and the ADC starting
+            conversion. Delay = 100us * (value) for value < 11, and
+            2ms * (value - 10) otherwise.
+            Valid values are: 0, 100, 200, 300, 400, 500, 600, 700, 800,
+            900 us and 1, 2, 4, 6, 8, 10 ms
+            If property is not found, channel will use 0us.
+
+- qcom,avg-samples:
+    Usage: optional
+    Value type: <u32>
+    Definition: Number of samples to be used for measurement.
+            Averaging provides the option to obtain a single measurement
+            from the ADC that is an average of multiple samples. The value
+            selected is 2^(value).
+            Valid values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512
+            If property is not found, 1 sample will be used.
+
+NOTE:
+
+Following channels, also known as reference point channels, are used for
+result calibration and their channel configuration nodes should be defined:
+VADC_REF_625MV and/or VADC_SPARE1(based on PMIC version) VADC_REF_1250MV,
+VADC_GND_REF and VADC_VDD_VADC.
+
+Example:
+
+	/* VADC node */
+	pmic_vadc: vadc@3100 {
+		compatible = "qcom,spmi-vadc";
+		reg = <0x3100 0x100>;
+		interrupts = <0x0 0x31 0x0 IRQ_TYPE_EDGE_RISING>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+
+		/* Channel node */
+		usb_id_nopull {
+			reg = <VADC_LR_MUX10_USB_ID>;
+			qcom,decimation = <512>;
+			qcom,ratiometric;
+			qcom,hw-settle-time = <200>;
+			qcom,avg-samples = <1>;
+			qcom,pre-scaling = <1 3>;
+		};
+	};
+
+	/* IIO client node */
+	usb {
+		io-channels = <&pmic_vadc VADC_LR_MUX10_USB_ID>;
+		io-channel-names = "vadc";
+	};
diff --git a/include/dt-bindings/iio/qcom,spmi-vadc.h b/include/dt-bindings/iio/qcom,spmi-vadc.h
new file mode 100644
index 0000000..42121fa
--- /dev/null
+++ b/include/dt-bindings/iio/qcom,spmi-vadc.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_QCOM_SPMI_VADC_H
+#define _DT_BINDINGS_QCOM_SPMI_VADC_H
+
+/* Voltage ADC channels */
+#define VADC_USBIN				0x00
+#define VADC_DCIN				0x01
+#define VADC_VCHG_SNS				0x02
+#define VADC_SPARE1_03				0x03
+#define VADC_USB_ID_MV				0x04
+#define VADC_VCOIN				0x05
+#define VADC_VBAT_SNS				0x06
+#define VADC_VSYS				0x07
+#define VADC_DIE_TEMP				0x08
+#define VADC_REF_625MV				0x09
+#define VADC_REF_1250MV				0x0a
+#define VADC_CHG_TEMP				0x0b
+#define VADC_SPARE1				0x0c
+#define VADC_SPARE2				0x0d
+#define VADC_GND_REF				0x0e
+#define VADC_VDD_VADC				0x0f
+
+#define VADC_P_MUX1_1_1				0x10
+#define VADC_P_MUX2_1_1				0x11
+#define VADC_P_MUX3_1_1				0x12
+#define VADC_P_MUX4_1_1				0x13
+#define VADC_P_MUX5_1_1				0x14
+#define VADC_P_MUX6_1_1				0x15
+#define VADC_P_MUX7_1_1				0x16
+#define VADC_P_MUX8_1_1				0x17
+#define VADC_P_MUX9_1_1				0x18
+#define VADC_P_MUX10_1_1			0x19
+#define VADC_P_MUX11_1_1			0x1a
+#define VADC_P_MUX12_1_1			0x1b
+#define VADC_P_MUX13_1_1			0x1c
+#define VADC_P_MUX14_1_1			0x1d
+#define VADC_P_MUX15_1_1			0x1e
+#define VADC_P_MUX16_1_1			0x1f
+
+#define VADC_P_MUX1_1_3				0x20
+#define VADC_P_MUX2_1_3				0x21
+#define VADC_P_MUX3_1_3				0x22
+#define VADC_P_MUX4_1_3				0x23
+#define VADC_P_MUX5_1_3				0x24
+#define VADC_P_MUX6_1_3				0x25
+#define VADC_P_MUX7_1_3				0x26
+#define VADC_P_MUX8_1_3				0x27
+#define VADC_P_MUX9_1_3				0x28
+#define VADC_P_MUX10_1_3			0x29
+#define VADC_P_MUX11_1_3			0x2a
+#define VADC_P_MUX12_1_3			0x2b
+#define VADC_P_MUX13_1_3			0x2c
+#define VADC_P_MUX14_1_3			0x2d
+#define VADC_P_MUX15_1_3			0x2e
+#define VADC_P_MUX16_1_3			0x2f
+
+#define VADC_LR_MUX1_BAT_THERM			0x30
+#define VADC_LR_MUX2_BAT_ID			0x31
+#define VADC_LR_MUX3_XO_THERM			0x32
+#define VADC_LR_MUX4_AMUX_THM1			0x33
+#define VADC_LR_MUX5_AMUX_THM2			0x34
+#define VADC_LR_MUX6_AMUX_THM3			0x35
+#define VADC_LR_MUX7_HW_ID			0x36
+#define VADC_LR_MUX8_AMUX_THM4			0x37
+#define VADC_LR_MUX9_AMUX_THM5			0x38
+#define VADC_LR_MUX10_USB_ID			0x39
+#define VADC_AMUX_PU1				0x3a
+#define VADC_AMUX_PU2				0x3b
+#define VADC_LR_MUX3_BUF_XO_THERM		0x3c
+
+#define VADC_LR_MUX1_PU1_BAT_THERM		0x70
+#define VADC_LR_MUX2_PU1_BAT_ID			0x71
+#define VADC_LR_MUX3_PU1_XO_THERM		0x72
+#define VADC_LR_MUX4_PU1_AMUX_THM1		0x73
+#define VADC_LR_MUX5_PU1_AMUX_THM2		0x74
+#define VADC_LR_MUX6_PU1_AMUX_THM3		0x75
+#define VADC_LR_MUX7_PU1_AMUX_HW_ID		0x76
+#define VADC_LR_MUX8_PU1_AMUX_THM4		0x77
+#define VADC_LR_MUX9_PU1_AMUX_THM5		0x78
+#define VADC_LR_MUX10_PU1_AMUX_USB_ID		0x79
+#define VADC_LR_MUX3_BUF_PU1_XO_THERM		0x7c
+
+#define VADC_LR_MUX1_PU2_BAT_THERM		0xb0
+#define VADC_LR_MUX2_PU2_BAT_ID			0xb1
+#define VADC_LR_MUX3_PU2_XO_THERM		0xb2
+#define VADC_LR_MUX4_PU2_AMUX_THM1		0xb3
+#define VADC_LR_MUX5_PU2_AMUX_THM2		0xb4
+#define VADC_LR_MUX6_PU2_AMUX_THM3		0xb5
+#define VADC_LR_MUX7_PU2_AMUX_HW_ID		0xb6
+#define VADC_LR_MUX8_PU2_AMUX_THM4		0xb7
+#define VADC_LR_MUX9_PU2_AMUX_THM5		0xb8
+#define VADC_LR_MUX10_PU2_AMUX_USB_ID		0xb9
+#define VADC_LR_MUX3_BUF_PU2_XO_THERM		0xbc
+
+#define VADC_LR_MUX1_PU1_PU2_BAT_THERM		0xf0
+#define VADC_LR_MUX2_PU1_PU2_BAT_ID		0xf1
+#define VADC_LR_MUX3_PU1_PU2_XO_THERM		0xf2
+#define VADC_LR_MUX4_PU1_PU2_AMUX_THM1		0xf3
+#define VADC_LR_MUX5_PU1_PU2_AMUX_THM2		0xf4
+#define VADC_LR_MUX6_PU1_PU2_AMUX_THM3		0xf5
+#define VADC_LR_MUX7_PU1_PU2_AMUX_HW_ID		0xf6
+#define VADC_LR_MUX8_PU1_PU2_AMUX_THM4		0xf7
+#define VADC_LR_MUX9_PU1_PU2_AMUX_THM5		0xf8
+#define VADC_LR_MUX10_PU1_PU2_AMUX_USB_ID	0xf9
+#define VADC_LR_MUX3_BUF_PU1_PU2_XO_THERM	0xfc
+
+#endif /* _DT_BINDINGS_QCOM_SPMI_VADC_H */
--
1.9.1

