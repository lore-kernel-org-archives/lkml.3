Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3J1TOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:14:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45230 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab3J1TOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:10 -0400
Message-Id: <88997d3863f72f8553fcaf66cf67fbf3289df04f.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <cover.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:12:35 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 09/10] mfd: pm8x41: document device tree bindings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings used to describe the Qualcomm 8x41 PMICs.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/pm8x41.txt | 33 ++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/pm8x41.txt

diff --git a/Documentation/devicetree/bindings/mfd/pm8x41.txt b/Documentation/devicetree/bindings/mfd/pm8x41.txt
new file mode 100644
index 0000000..6afd4ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/pm8x41.txt
@@ -0,0 +1,33 @@
+Qualcomm PM8841 and PM8941 PMIC multi-function devices
+
+The PM8x41 PMICs are used with the Qualcomm Snapdragon 800 series SoCs, and are
+interfaced to the chip via the SPMI (System Power Management Interface) bus.
+Support for  multiple independent functions are implemented by splitting the
+16-bit SPMI slave address space into 256 smaller fixed-size regions, 256 bytes
+each.  A function can consume one or more of these fixed-size register regions.
+
+Required properties:
+- compatible: Must be one of:
+     "qcom,pm8841"
+     "qcom,pm8941"
+- reg: Specifies the SPMI USID slave address for this device
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
+	reg = <0x0>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	rtc {
+		compatible = "qcom,pm8941-rtc";
+		reg = <0x6000 0x6100>;
+	};
+}
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


