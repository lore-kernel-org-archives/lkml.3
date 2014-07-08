Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaGHP4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:56:03 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60205 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaGHP4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:56:00 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 2/3] mfd: qpnp-spmi: document DT bindings for Qualcomm QPNP PMICs
Date: Tue,  8 Jul 2014 18:54:28 +0300
Message-Id: <1404834869-23049-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
References: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan T. Ivanov <iivanov@mm-sol.com>

Document DT bindings used to describe the Qualcomm QPNP PMICs.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/qpnp/qcom,qpnp-spmi.txt    |   53 ++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/qpnp/qcom,qpnp-spmi.txt

diff --git a/Documentation/devicetree/bindings/qpnp/qcom,qpnp-spmi.txt b/Documentation/devicetree/bindings/qpnp/qcom,qpnp-spmi.txt
new file mode 100644
index 0000000..24cde34
--- /dev/null
+++ b/Documentation/devicetree/bindings/qpnp/qcom,qpnp-spmi.txt
@@ -0,0 +1,53 @@
+Qualcomm QPNP partitioned PMIC multi-function device bindings
+
+QPNP is effectively a partitioning scheme for dividing the SPMI extended
+register space up into logical pieces, and set of fixed register
+locations/definitions within these regions, with some of these regions
+specifically used for interrupt handling.
+
+The QPNP PMICs are used with the Qualcomm Snapdragon series SoCs, and are
+interfaced to the chip via the SPMI (System Power Management Interface) bus.
+Support for multiple independent functions are implemented by splitting the
+16-bit SPMI slave address space into 256 smaller fixed-size regions, 256 bytes
+each. A function can consume one or more of these fixed-size register regions.
+
+Required properties:
+- compatible:      Should contain "qcom,qpnp-spmi"
+- reg:             Specifies the SPMI USID slave address for this device.
+                   For more information see:
+                   Documentation/devicetree/bindings/spmi/spmi.txt
+- #address-cells:  Defines address cells for peripheral nodes - should be 1
+- #size-cells:     Defines size cells for peripheral nodes - should be 0
+
+Required properties for peripheral child nodes:
+- compatible:      Should constain "qcom,qpnp-xxx"
+- reg:             One or more 16bits peripheral address(es)
+
+Optional properties for peripheral child nodes:
+- reg-names:       Shall be a string describing the reg resource.
+- interrupts:      Interrupts are specified as a 4-tuple. For more information
+                   see:
+                   Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
+- interrupt-names: Corresponding interrupt name to the interrupts property
+
+Each child node represents a function of the QPNP.  Each child 'reg' entry
+describes a QPNP peripheral address within the USID slave address space where
+the region starts.
+
+Example:
+
+	pm8941@0 {
+		compatible = "qcom,qpnp-spmi";
+		reg = <0x0 SPMI_USID>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		rtc@6000 {
+			compatible = "qcom,qpnp-rtc";
+			reg = <0x6000 0x6100>;
+			reg-names = "rtc", "alarm";
+			interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
+		};
+	};
+
-- 
1.7.0.4

