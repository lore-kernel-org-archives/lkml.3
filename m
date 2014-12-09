Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaLIUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:21:52 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:50112 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaLIUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:21:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, broonie@kernel.org,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v4 2/2] spi: st: Provide Device Tree binding documentation
Date: Tue,  9 Dec 2014 20:21:31 +0000
Message-Id: <1418156491-26613-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418156491-26613-1-git-send-email-lee.jones@linaro.org>
References: <1418156491-26613-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT documentation for the SPI portion of ST's SSC device.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/spi/spi-st.txt | 40 ++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-st.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-st.txt b/Documentation/devicetree/bindings/spi/spi-st.txt
new file mode 100644
index 0000000..fe54959
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-st.txt
@@ -0,0 +1,40 @@
+STMicroelectronics SSC (SPI) Controller
+---------------------------------------
+
+Required properties:
+- compatible	: "st,comms-ssc4-spi"
+- reg		: Offset and length of the device's register set
+- interrupts	: The interrupt specifier
+- clock-names	: Must contain "ssc"
+- clocks	: Must contain an entry for each name in clock-names
+		    See ../clk/*
+- pinctrl-names	: Uses "default", can use "sleep" if provided
+		    See ../pinctrl/pinctrl-binding.txt
+
+Optional properties:
+- cs-gpios	: List of GPIO chip selects
+		    See ../spi/spi-bus.txt
+
+Child nodes represent devices on the SPI bus
+  See ../spi/spi-bus.txt
+
+Example:
+	spi@9840000 {
+		compatible	= "st,comms-ssc4-spi";
+		reg		= <0x9840000 0x110>;
+		interrupts	= <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+		clocks		= <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+		clock-names	= "ssc";
+		pinctrl-0	= <&pinctrl_spi0_default>;
+		pinctrl-names	= "default";
+		cs-gpios	= <&pio17 5 0>;
+		#address-cells	= <1>;
+		#size-cells	= <0>;
+
+		st95hf@0{
+			compatible		= "st,st95hf";
+			reg			= <0>;
+			spi-max-frequency	= <1000000>;
+			interrupts		= <2 IRQ_TYPE_EDGE_FALLING>;
+		};
+	};
-- 
1.9.1

