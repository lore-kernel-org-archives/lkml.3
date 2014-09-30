Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaI3AfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:35:00 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10903 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbaI3Ae5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:34:57 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 3/7] mfd: devicetree: bindings: Add Qualcomm SMD based RPM DT binding
Date: Mon, 29 Sep 2014 17:34:47 -0700
Message-ID: <1412037291-16880-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the Qualcomm Resource Power Manager (RPM)
using shared memory (Qualcomm SMD) as transport mechanism. This is found
in 8974 and newer based devices.

The binding currently describes the rpm itself and the regulator
subnodes.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Note that this patch extends the rpm dt-bindings header from [1].

[1] https://lkml.org/lkml/2014/9/22/733

 .../devicetree/bindings/mfd/qcom-rpm-smd.txt       |  122 ++++++++++++++++++++
 include/dt-bindings/mfd/qcom-rpm.h                 |   36 ++++++
 2 files changed, 158 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt

diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
new file mode 100644
index 0000000..a846101
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
@@ -0,0 +1,122 @@
+Qualcomm Resource Power Manager (RPM) over SMD
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
+		    "qcom,rpm-msm8974"
+
+- qcom,smd-channels:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Shared Memory Channel used for communication with the RPM
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
+		    "qcom,rpm-pm8841-smps"
+		    "qcom,rpm-pm8941-smps"
+
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
+		    must be one of:
+		    QCOM_RPM_PM8841_SMPS1 - QCOM_RPM_PM8841_SMPS4,
+		    QCOM_RPM_PM8941_SMPS1 - QCOM_RPM_PM8941_SMPS3
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
+		    "qcom,rpm-pm8941-ldo"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/mfd/qcom-rpm.h>
+		    must be one of:
+		    QCOM_RPM_PM8941_LDO1 - QCOM_RPM_PM8941_LDO24
+
+Standard regulator bindings are used inside switch low-dropout regulator
+subnodes.  Check Documentation/devicetree/bindings/regulator/regulator.txt for
+more details.
+
+== Switch
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,rpm-pm8941-switch"
+
+- reg:
+	Usage: required
+	Value type: <u32>
+	Definition: resource as defined in <dt-bindings/mfd/qcom/qcom-rpm.h>
+		    must be one of:
+		    QCOM_RPM_PM8941_LVS1 - QCOM_RPM_PM8941_LVS3,
+		    QCOM_RPM_PM8941_MVS1 - QCOM_RPM_PM8941_MVS2
+
+Standard regulator bindings are used inside switch regulator subnodes.  Check
+Documentation/devicetree/bindings/regulator/regulator.txt for more details.
+
+= EXAMPLE
+
+	#include <dt-bindings/mfd/qcom-rpm.h>
+
+	rpm@108000 {
+		compatible = "qcom,rpm-msm8960";
+		qcom,smd-channels = "rpm_requests";
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pm8941_s1: regulator-s1 {
+			compatible = "qcom,rpm-pm8941-smps";
+			reg = <QCOM_RPM_PM8941_SMPS1>;
+
+			regulator-min-microvolt = <1300000>;
+			regulator-max-microvolt = <1300000>;
+		};
+
+		pm8941_l3: pm8941-l3 {
+			compatible = "qcom,rpm-pm8941-ldo";
+			reg = <QCOM_RPM_PM8941_LDO3>;
+
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <1200000>;
+		};
+
+	};
+
diff --git a/include/dt-bindings/mfd/qcom-rpm.h b/include/dt-bindings/mfd/qcom-rpm.h
index 388a6f3..a5c473e 100644
--- a/include/dt-bindings/mfd/qcom-rpm.h
+++ b/include/dt-bindings/mfd/qcom-rpm.h
@@ -141,6 +141,42 @@
 #define QCOM_RPM_SYS_FABRIC_MODE		131
 #define QCOM_RPM_USB_OTG_SWITCH			132
 #define QCOM_RPM_VDDMIN_GPIO			133
+#define QCOM_RPM_PM8841_SMPS1			134
+#define QCOM_RPM_PM8841_SMPS2			135
+#define QCOM_RPM_PM8841_SMPS3			136
+#define QCOM_RPM_PM8841_SMPS4			137
+#define QCOM_RPM_PM8941_SMPS1			138
+#define QCOM_RPM_PM8941_SMPS2			139
+#define QCOM_RPM_PM8941_SMPS3			140
+#define QCOM_RPM_PM8941_LDO1			141
+#define QCOM_RPM_PM8941_LDO2			142
+#define QCOM_RPM_PM8941_LDO3			143
+#define QCOM_RPM_PM8941_LDO4			144
+#define QCOM_RPM_PM8941_LDO5			145
+#define QCOM_RPM_PM8941_LDO6			146
+#define QCOM_RPM_PM8941_LDO7			147
+#define QCOM_RPM_PM8941_LDO8			148
+#define QCOM_RPM_PM8941_LDO9			149
+#define QCOM_RPM_PM8941_LDO10			150
+#define QCOM_RPM_PM8941_LDO11			151
+#define QCOM_RPM_PM8941_LDO12			152
+#define QCOM_RPM_PM8941_LDO13			153
+#define QCOM_RPM_PM8941_LDO14			154
+#define QCOM_RPM_PM8941_LDO15			155
+#define QCOM_RPM_PM8941_LDO16			156
+#define QCOM_RPM_PM8941_LDO17			157
+#define QCOM_RPM_PM8941_LDO18			158
+#define QCOM_RPM_PM8941_LDO19			159
+#define QCOM_RPM_PM8941_LDO20			160
+#define QCOM_RPM_PM8941_LDO21			161
+#define QCOM_RPM_PM8941_LDO22			162
+#define QCOM_RPM_PM8941_LDO23			163
+#define QCOM_RPM_PM8941_LDO24			164
+#define QCOM_RPM_PM8941_LVS1			165
+#define QCOM_RPM_PM8941_LVS2			166
+#define QCOM_RPM_PM8941_LVS3			167
+#define QCOM_RPM_PM8941_MVS1			168
+#define QCOM_RPM_PM8941_MVS2			169
 
 /*
  * Constants used to select force mode for regulators.
-- 
1.7.9.5

