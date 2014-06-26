Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaFZUav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:30:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58860 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaFZUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:30:34 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/2] dmaengine: qcom_adm: Add device tree binding
Date: Thu, 26 Jun 2014 15:30:16 -0500
Message-Id: <1403814616-23917-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403814616-23917-1-git-send-email-agross@codeaurora.org>
References: <1403814616-23917-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding support for the QCOM ADM DMA driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 Documentation/devicetree/bindings/dma/qcom_adm.txt |   60 ++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_adm.txt

diff --git a/Documentation/devicetree/bindings/dma/qcom_adm.txt b/Documentation/devicetree/bindings/dma/qcom_adm.txt
new file mode 100644
index 0000000..7f05cb5
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/qcom_adm.txt
@@ -0,0 +1,60 @@
+QCOM ADM DMA Controller
+
+Required properties:
+- compatible: must contain "qcom,adm" for IPQ/APQ8064 and MSM8960
+- reg: Address range for DMA registers
+- interrupts: Should contain one interrupt shared by all channels
+- #dma-cells: must be <2>.  First cell denotes the channel number.  Second cell
+  denotes CRCI (client rate control interface) flow control assignment.
+- clocks: Should contain the core clock and interface clock.
+- clock-names: Must contain "core" for the core clock and "iface" for the
+  interface clock.
+- resets: Must contain an entry for each entry in reset names.
+- reset-names: Must include the following entries:
+  - clk
+  - c0
+  - c1
+  - c2
+- qcom,ee: indicates the security domain identifier used in the secure world.
+
+Example:
+		adm_dma: dma@18300000 {
+			compatible = "qcom,adm";
+			reg = <0x18300000 0x100000>;
+			interrupts = <0 170 0>;
+			#dma-cells = <2>;
+
+			clocks = <&gcc ADM0_CLK>, <&gcc ADM0_PBUS_CLK>;
+			clock-names = "core", "iface";
+
+			resets = <&gcc ADM0_RESET>,
+				<&gcc ADM0_C0_RESET>,
+				<&gcc ADM0_C1_RESET>,
+				<&gcc ADM0_C2_RESET>;
+			reset-names = "clk", "c0", "c1", "c2";
+			qcom,ee = <0>;
+		};
+
+DMA clients must use the format descripted in the dma.txt file, using a three
+cell specifier for each channel.
+
+Each dmas request consists of 3 cells:
+ 1. phandle pointing to the DMA controller
+ 2. channel number
+ 3. CRCI assignment, if applicable.  If no CRCI flow control is required, use 0.
+
+Example:
+
+	spi4: spi@1a280000 {
+		status = "ok";
+		spi-max-frequency = <50000000>;
+
+		pinctrl-0 = <&spi_pins>;
+		pinctrl-names = "default";
+
+		cs-gpios = <&qcom_pinmux 20 0>;
+
+		dmas = <&adm_dma 6 9>,
+			<&adm_dma 5 10>;
+		dma-names = "rx", "tx";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

