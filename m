Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3JYUZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:25:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38162 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3JYUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:25:03 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/2] dmaengine: msm_bam_dma: Add device tree binding
Date: Fri, 25 Oct 2013 15:24:03 -0500
Message-Id: <1382732643-8184-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
References: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree probe support for the MSM BAM DMA driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/dma/msm_bam_dma.txt        |   49 ++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/msm_bam_dma.txt

diff --git a/Documentation/devicetree/bindings/dma/msm_bam_dma.txt b/Documentation/devicetree/bindings/dma/msm_bam_dma.txt
new file mode 100644
index 0000000..fe3ed8f
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/msm_bam_dma.txt
@@ -0,0 +1,49 @@
+MSM BAM DMA controller
+
+Required properties:
+- compatible: Should be "qcom,bam"
+- reg: Address range for DMA registers
+- interrupts: single interrupt for this controller
+- #dma-cells: must be <3>
+- clocks: required clock
+- clock-names: name of clock
+
+Example:
+
+	dma0: dma@f9984000 = {
+		compatible = "qcom,bam";
+		reg = <0xf9984000 0x15000>;
+		interrupts = <0 94 0>;
+		clocks = <&bam_dma_ahb_cxc>;
+		clock-names = "bam_clk";
+		#dma-cells = <3>;
+	};
+
+Client:
+Required properties:
+- dmas: List of dma channel requests
+- dma-names: Names of aforementioned requested channels
+
+Clients must use the format described in the dma.txt file, using a four cell
+specifier for each channel.
+
+The four cells in order are:
+  1. A phandle pointing to the DMA controller
+  2. The channel number
+  3. The execution environment value for this channel.
+  4. Direction of the fixed unidirectional channel
+     0 - Memory to Device
+     1 - Device to Memory
+
+Example:
+	serial@f991e000 {
+		compatible = "qcom,msm-uart";
+		reg = <0xf991e000 0x1000>
+			<0xf9944000 0x19000>;
+		interrupts = <0 108 0>;
+		clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
+		clock-names = "gsbi_uart_clk", "gsbi_pclk";
+
+		dmas = <&dma0 0 0 1>, <&dma0 1 0 0>;
+		dma-names = "rx", "tx";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

