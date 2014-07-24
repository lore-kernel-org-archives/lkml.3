Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaGXMqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:46:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54549 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbaGXMqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:46:45 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 2/4] mfd: pm8xxx-spmi: document DT bindings for Qualcomm SPMI PMICs
Date: Thu, 24 Jul 2014 15:45:19 +0300
Message-Id: <1406205921-7452-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document DT bindings used to describe the Qualcomm SPMI PMICs.
Currently the SPMI PMICs supported are pm8941, pm8841 and pma8084.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt   |   49 ++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt

diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt
new file mode 100644
index 0000000..2b7f5b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt
@@ -0,0 +1,49 @@
+          Qualcomm PM8XXX SPMI PMICs multi-function device bindings
+
+The Qualcomm PM8XXX series presently includes PM8941, PM8841 and PMA8084
+PMICs.  These PMICs use a QPNP scheme through SPMI interface.
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
+- compatible:      Should contain one of:
+                     "qcom,pm8941"
+                     "qcom,pm8841"
+                     "qcom,pma8084"
+- reg:             Specifies the SPMI USID slave address for this device.
+                   For more information see:
+                   Documentation/devicetree/bindings/spmi/spmi.txt
+
+Required properties for peripheral child nodes:
+- compatible:      Should contain "qcom,pm8xxx-xxx", where "xxx" is
+                   peripheral name. The "pm8xxx" can be any of supported PMICs,
+                   see example below.
+
+Optional properties for peripheral child nodes:
+- interrupts:      Interrupts are specified as a 4-tuple. For more information
+                   see:
+                   Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
+- interrupt-names: Corresponding interrupt name to the interrupts property
+
+Each child node represents a function of the PMIC.
+
+Example:
+
+	pm8941@0 {
+		compatible = "qcom,pm8941";
+		reg = <0x0 SPMI_USID>;
+
+		rtc {
+			compatible = "qcom,pm8941-rtc";
+			interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "alarm";
+		};
+	};
-- 
1.7.0.4

