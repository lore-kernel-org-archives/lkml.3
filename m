Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaA1G21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:28:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58026 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaA1G2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:28:20 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Date: Tue, 28 Jan 2014 00:27:51 -0600
Message-Id: <1390890471-14882-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390890471-14882-1-git-send-email-agross@codeaurora.org>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding support for the QCOM BAM DMA driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |   52 ++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
new file mode 100644
index 0000000..53fd10a
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -0,0 +1,52 @@
+QCOM BAM DMA controller
+
+Required properties:
+- compatible:	Must be "qcom,bam-v1.4.0" for MSM8974 V1
+		Must be "qcom,bam-v1.4.1" for MSM8974 V2
+- reg: Address range for DMA registers
+- interrupts: single interrupt for this controller
+- #dma-cells: must be <2>
+- clocks: required clock
+- clock-names: name of clock
+- qcom,ee : indicates the active Execution Environment identifier (0-7)
+
+Example:
+
+	uart-bam: dma@f9984000 = {
+		compatible = "qcom,bam-v1.4.1";
+		reg = <0xf9984000 0x15000>;
+		interrupts = <0 94 0>;
+		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
+		clock-names = "bam_clk";
+		#dma-cells = <2>;
+		qcom,ee = <0>;
+	};
+
+Client:
+Required properties:
+- dmas: List of dma channel requests
+- dma-names: Names of aforementioned requested channels
+
+Clients must use the format described in the dma.txt file, using a three cell
+specifier for each channel.
+
+The three cells in order are:
+  1. A phandle pointing to the DMA controller
+  2. The channel number
+  3. Direction of the fixed unidirectional channel
+     0 - Memory to Device
+     1 - Device to Memory
+     2 - Device to Device
+
+Example:
+	serial@f991e000 {
+		compatible = "qcom,msm-uart";
+		reg = <0xf991e000 0x1000>
+			<0xf9944000 0x19000>;
+		interrupts = <0 108 0>;
+		clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
+		clock-names = "core", "iface";
+
+		dmas = <&uart-bam 0 1>, <&uart-bam 1 0>;
+		dma-names = "rx", "tx";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

