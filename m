Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaB0P3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:29:45 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:58215 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbaB0P0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:26:47 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH v0 07/15] clk: st: Adds divmux and prediv clock binding
Date: Thu, 27 Feb 2014 16:24:20 +0100
Message-Id: <1393514668-17440-8-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 .../bindings/clock/st/st,clkgen-divmux.txt         | 49 +++++++++++++
 .../bindings/clock/st/st,clkgen-prediv.txt         | 36 ++++++++++
 .../devicetree/bindings/clock/st/st,clkgen.txt     | 83 ++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
new file mode 100644
index 0000000..ae56315
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-divmux.txt
@@ -0,0 +1,49 @@
+Binding for a ST divider and multiplexer clock driver.
+
+This binding uses the common clock binding[1].
+Base address is located to the parent node. See clock binding[2]
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[2] Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+
+Required properties:
+
+- compatible : shall be:
+	"st,clkgena-divmux-c65-hs",	"st,clkgena-divmux"
+	"st,clkgena-divmux-c65-ls",	"st,clkgena-divmux"
+	"st,clkgena-divmux-c32-odf0",	"st,clkgena-divmux"
+	"st,clkgena-divmux-c32-odf1",	"st,clkgena-divmux"
+	"st,clkgena-divmux-c32-odf2",	"st,clkgena-divmux"
+	"st,clkgena-divmux-c32-odf3",	"st,clkgena-divmux"
+
+- #clock-cells : From common clock binding; shall be set to 1.
+
+- clocks : From common clock binding
+
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clockgenA@fd345000 {
+		reg = <0xfd345000 0xb50>;
+
+		CLK_M_A1_DIV1: CLK_M_A1_DIV1 {
+			#clock-cells = <1>;
+			compatible = "st,clkgena-divmux-c32-odf1",
+				     "st,clkgena-divmux";
+
+			clocks = <&CLK_M_A1_OSC_PREDIV>,
+				 <&CLK_M_A1_PLL0 1>, /* PLL0 PHI1 */
+				 <&CLK_M_A1_PLL1 1>; /* PLL1 PHI1 */
+
+			clock-output-names = "CLK_M_RX_ICN_TS",
+					     "CLK_M_RX_ICN_VDP_0",
+					     "", /* Unused */
+					     "CLK_M_PRV_T1_BUS",
+					     "CLK_M_ICN_REG_12",
+					     "CLK_M_ICN_REG_10",
+					     "", /* Unused */
+					     "CLK_M_ICN_ST231";
+		};
+	};
+
diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
new file mode 100644
index 0000000..566c9d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-prediv.txt
@@ -0,0 +1,36 @@
+Binding for a ST pre-divider clock driver.
+
+This binding uses the common clock binding[1].
+Base address is located to the parent node. See clock binding[2]
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[2] Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+
+Required properties:
+
+- compatible : shall be:
+	"st,clkgena-prediv-c65",	"st,clkgena-prediv"
+	"st,clkgena-prediv-c32",	"st,clkgena-prediv"
+
+- #clock-cells : From common clock binding; shall be set to 0.
+
+- clocks : From common clock binding
+
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clockgenA@fd345000 {
+		reg = <0xfd345000 0xb50>;
+
+		CLK_M_A2_OSC_PREDIV: CLK_M_A2_OSC_PREDIV {
+			#clock-cells = <0>;
+			compatible = "st,clkgena-prediv-c32",
+				     "st,clkgena-prediv";
+
+			clocks = <&CLK_SYSIN>;
+
+			clock-output-names = "CLK_M_A2_OSC_PREDIV";
+		};
+	};
+
diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
new file mode 100644
index 0000000..49ec5ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
@@ -0,0 +1,83 @@
+Binding for a Clockgen hardware block found on
+certain STMicroelectronics consumer electronics SoC devices.
+
+A Clockgen node can contain pll, diviser or multiplexer nodes.
+
+We will find only the base address of the Clockgen, this base
+address is common of all subnode.
+
+	clockgen_node {
+		reg = <>;
+
+		pll_node {
+			...
+		};
+
+		prediv_node {
+			...
+		};
+
+		divmux_node {
+			...
+		};
+
+		quadfs_node {
+			...
+		};
+		...
+	};
+
+This binding uses the common clock binding[1].
+Each subnode should use the binding discribe in [2]..[4]
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[2] Documentation/devicetree/bindings/clock/st,quadfs.txt
+[3] Documentation/devicetree/bindings/clock/st,quadfs.txt
+[4] Documentation/devicetree/bindings/clock/st,quadfs.txt
+
+Required properties:
+- reg : A Base address and length of the register set.
+
+Example:
+
+	clockgenA@fee62000 {
+
+		reg = <0xfee62000 0xb48>;
+
+		CLK_S_A0_PLL: CLK_S_A0_PLL {
+			#clock-cells = <1>;
+			compatible = "st,clkgena-plls-c65";
+
+			clocks = <&CLK_SYSIN>;
+
+			clock-output-names = "CLK_S_A0_PLL0_HS",
+					     "CLK_S_A0_PLL0_LS",
+					     "CLK_S_A0_PLL1";
+		};
+
+		CLK_S_A0_OSC_PREDIV: CLK_S_A0_OSC_PREDIV {
+			#clock-cells = <0>;
+			compatible = "st,clkgena-prediv-c65",
+				     "st,clkgena-prediv";
+
+			clocks = <&CLK_SYSIN>;
+
+			clock-output-names = "CLK_S_A0_OSC_PREDIV";
+		};
+
+		CLK_S_A0_HS: CLK_S_A0_HS {
+			#clock-cells = <1>;
+			compatible = "st,clkgena-divmux-c65-hs",
+				     "st,clkgena-divmux";
+
+			clocks = <&CLK_S_A0_OSC_PREDIV>,
+				 <&CLK_S_A0_PLL 0>, /* PLL0 HS */
+				 <&CLK_S_A0_PLL 2>; /* PLL1 */
+
+			clock-output-names = "CLK_S_FDMA_0",
+					     "CLK_S_FDMA_1",
+					     ""; /* CLK_S_JIT_SENSE */
+					     /* Fourth output unused */
+		};
+	};
+
-- 
1.9.0

