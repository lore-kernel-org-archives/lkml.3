Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaFDQbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:31:14 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35447 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaFDQbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:31:12 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chris@printf.net, ulf.hansson@linaro.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH v3 02/10] mmc: sdhci-st: ST Microelectronics SDHCI binding documentation.
Date: Wed,  4 Jun 2014 17:30:16 +0100
Message-Id: <1401899424-1365-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree binding documentation for the ST
SDHCI driver. It documents the differences between the core properties
described by mmc.txt and the properties used by the sdhci-st driver.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 Documentation/devicetree/bindings/mmc/sdhci-st.txt | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-st.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-st.txt b/Documentation/devicetree/bindings/mmc/sdhci-st.txt
new file mode 100644
index 0000000..7527db4
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-st.txt
@@ -0,0 +1,33 @@
+* STMicroelectronics sdhci-st MMC/SD controller
+
+This file documents the differences between the core properties in
+Documentation/devicetree/bindings/mmc/mmc.txt and the properties
+used by the sdhci-st driver.
+
+Required properties:
+- compatible :  Must be "st,sdhci"
+- clock-names : Should be "mmc"
+                See: Documentation/devicetree/bindings/resource-names.txt
+- clocks :      Phandle of the clock used by the sdhci controler
+                See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Optional properties:
+- non-removable: non-removable slot
+                 See: Documentation/devicetree/bindings/mmc/mmc.txt
+- bus-width: Number of data lines
+                 See: Documentation/devicetree/bindings/mmc/mmc.txt
+
+Example:
+
+mmc0: sdhci@fe81e000 {
+	compatible	= "st,sdhci";
+	status		= "disabled";
+	reg		= <0xfe81e000 0x1000>;
+	interrupts	= <GIC_SPI 127 IRQ_TYPE_NONE>;
+	interrupt-names	= "mmcirq";
+	pinctrl-names	= "default";
+	pinctrl-0	= <&pinctrl_mmc0>;
+	clock-names	= "mmc";
+	clocks		= <&clk_s_a1_ls 1>;
+	bus-width       = <8>
+};
-- 
1.9.1

