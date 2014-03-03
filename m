Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaCCGfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:35:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34880 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaCCGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:35:20 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [Patch v8 1/2] dmaengine: qcom_bam_dma: Add device tree binding
Date: Mon,  3 Mar 2014 00:30:44 -0600
Message-Id: <1393828245-18766-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393828245-18766-1-git-send-email-agross@codeaurora.org>
References: <1393828245-18766-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding support for the QCOM BAM DMA driver.

Acked-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
new file mode 100644
index 0000000..d75a9d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -0,0 +1,41 @@
+QCOM BAM DMA controller
+
+Required properties:
+- compatible: must contain "qcom,bam-v1.4.0" for MSM8974
+- reg: Address range for DMA registers
+- interrupts: Should contain the one interrupt shared by all channels
+- #dma-cells: must be <1>, the cell in the dmas property of the client device
+  represents the channel number
+- clocks: required clock
+- clock-names: must contain "bam_clk" entry
+- qcom,ee : indicates the active Execution Environment identifier (0-7) used in
+  the secure world.
+
+Example:
+
+	uart-bam: dma@f9984000 = {
+		compatible = "qcom,bam-v1.4.0";
+		reg = <0xf9984000 0x15000>;
+		interrupts = <0 94 0>;
+		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
+		clock-names = "bam_clk";
+		#dma-cells = <1>;
+		qcom,ee = <0>;
+	};
+
+DMA clients must use the format described in the dma.txt file, using a two cell
+specifier for each channel.
+
+Example:
+	serial@f991e000 {
+		compatible = "qcom,msm-uart";
+		reg = <0xf991e000 0x1000>
+			<0xf9944000 0x19000>;
+		interrupts = <0 108 0>;
+		clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>,
+			<&gcc GCC_BLSP1_AHB_CLK>;
+		clock-names = "core", "iface";
+
+		dmas = <&uart-bam 0>, <&uart-bam 1>;
+		dma-names = "rx", "tx";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

