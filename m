Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaDWAah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:30:37 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15140 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaDWAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:30:33 -0400
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Josh Cartwright <joshc@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 2/2] mfd: pm8x41: document device tree bindings
Date: Tue, 22 Apr 2014 17:31:50 -0700
Message-ID: <1398213110-28135-2-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Cartwright <joshc@codeaurora.org>

Document the bindings used to describe the Qualcomm 8x41 PMICs.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 Documentation/devicetree/bindings/mfd/pm8x41.txt | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/pm8x41.txt

diff --git a/Documentation/devicetree/bindings/mfd/pm8x41.txt b/Documentation/devicetree/bindings/mfd/pm8x41.txt
new file mode 100644
index 0000000..b865a4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/pm8x41.txt
@@ -0,0 +1,34 @@
+Qualcomm PM8841 and PM8941 PMIC multi-function device bindings
+
+The PM8x41 PMICs are used with the Qualcomm Snapdragon 800 series SoCs, and are
+interfaced to the chip via the SPMI (System Power Management Interface) bus.
+Support for multiple independent functions are implemented by splitting the
+16-bit SPMI slave address space into 256 smaller fixed-size regions, 256 bytes
+each.  A function can consume one or more of these fixed-size register regions.
+
+Required properties:
+- compatible: Must be one of:
+     "qcom,pm8841"
+     "qcom,pm8941"
+- reg: Specifies the SPMI USID slave address for this device;
+	See bindings/spmi/spmi.txt
+- #address-cells = <1>
+- #size-cells = <0>
+
+Each child node represents a function of the PM8x41.  Each child 'reg' entry
+describes an offset within the USID slave address where the region starts.
+
+Example:
+
+pm8941@0 {
+	compatible = "qcom,pm8941";
+	reg = <0x0 SPMI_USID>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	rtc@6000 {
+		compatible = "...";
+		reg = <0x6000 0x6100>;
+	};
+};
-- 
1.8.1.5

