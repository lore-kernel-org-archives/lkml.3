Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaB0PtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:24 -0500
Received: from eu1sys200aog124.obsmtp.com ([207.126.144.157]:35897 "EHLO
	eu1sys200aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbaB0PtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:17 -0500
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 10:49:16 EST
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH v0 09/15] clk: st: Adds clockgen-vcc and clockgen-mux clock binding
Date: Thu, 27 Feb 2014 16:24:22 +0100
Message-Id: <1393514668-17440-10-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 .../devicetree/bindings/clock/st/st,clkgen-mux.txt | 36 +++++++++++++++
 .../devicetree/bindings/clock/st/st,clkgen-vcc.txt | 53 ++++++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
new file mode 100644
index 0000000..943e080
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-mux.txt
@@ -0,0 +1,36 @@
+Binding for a ST multiplexed clock driver.
+
+This binding supports only simple indexed multiplexers, it does not
+support table based parent index to hardware value translations.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+
+- compatible : shall be:
+	"st,stih416-clkgenc-vcc-hd",	"st,clkgen-mux"
+	"st,stih416-clkgenf-vcc-fvdp",	"st,clkgen-mux"
+	"st,stih416-clkgenf-vcc-hva", 	"st,clkgen-mux"
+	"st,stih416-clkgenf-vcc-hd",	"st,clkgen-mux"
+	"st,stih416-clkgenf-vcc-sd",	"st,clkgen-mux"
+	"st,stih415-clkgen-a9-mux",	"st,clkgen-mux"
+	"st,stih416-clkgen-a9-mux",	"st,clkgen-mux"
+
+
+- #clock-cells : from common clock binding; shall be set to 0.
+
+- reg : A Base address and length of the register set.
+
+- clocks : from common clock binding
+
+Example:
+
+	CLK_M_HVA: CLK_M_HVA {
+		#clock-cells = <0>;
+		compatible = "st,stih416-clkgenf-vcc-hva", "st,clkgen-mux";
+		reg = <0xfd690868 4>;
+
+		clocks = <&CLOCKGEN_F 1>, <&CLK_M_A1_DIV0 3>;
+	};
diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
new file mode 100644
index 0000000..4e3ff28
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-vcc.txt
@@ -0,0 +1,53 @@
+Binding for a type of STMicroelectronics clock crossbar (VCC).
+
+The crossbar can take up to 4 input clocks and control up to 16
+output clocks. Not all inputs or outputs have to be in use in a
+particular instantiation. Each output can be individually enabled,
+select any of the input clocks and apply a divide (by 1,2,4 or 8) to
+that selected clock.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+
+- compatible : shall be:
+	"st,stih416-clkgenc",		"st,vcc"
+	"st,stih416-clkgenf",		"st,vcc"
+
+- #clock-cells : from common clock binding; shall be set to 1.
+
+- reg : A Base address and length of the register set.
+
+- clocks : from common clock binding
+
+- clock-output-names : From common clock binding. The block has 16
+                       clock outputs but not all of them in a specific instance
+                       have to be used in the SoC. If a clock name is left as
+                       an empty string then no clock will be created for the
+                       output associated with that string index. If fewer than
+                       16 strings are provided then no clocks will be created
+                       for the remaining outputs.
+
+Example:
+
+	CLOCKGEN_C_VCC: CLOCKGEN_C_VCC {
+		#clock-cells = <1>;
+		compatible = "st,stih416-clkgenc", "st,clkgen-vcc";
+		reg = <0xfe8308ac 12>;
+
+		clocks = <&CLK_S_VCC_HD>, <&CLOCKGEN_C 1>,
+			<&CLK_S_TMDS_FROMPHY>, <&CLOCKGEN_C 2>;
+
+		clock-output-names  =
+			"CLK_S_PIX_HDMI",  "CLK_S_PIX_DVO",
+			"CLK_S_OUT_DVO",   "CLK_S_PIX_HD",
+			"CLK_S_HDDAC",     "CLK_S_DENC",
+			"CLK_S_SDDAC",     "CLK_S_PIX_MAIN",
+			"CLK_S_PIX_AUX",   "CLK_S_STFE_FRC_0",
+			"CLK_S_REF_MCRU",  "CLK_S_SLAVE_MCRU",
+			"CLK_S_TMDS_HDMI", "CLK_S_HDMI_REJECT_PLL",
+			"CLK_S_THSENS";
+	};
+
-- 
1.9.0

