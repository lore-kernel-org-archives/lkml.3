Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaF0N0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:26:40 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34844 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaF0N0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:34 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 04/14] clk: st: Adds Flexgen clock binding
Date: Fri, 27 Jun 2014 15:25:01 +0200
Message-Id: <1403875511-7710-5-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Flexgen structure is composed by:
- a clock cross bar (represented by a mux element)
- a pre and final dividers (represented by a divider and gate elements)

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/clock/st/st,clkgen.txt     |  5 +++
 .../devicetree/bindings/clock/st/st,flexgen.txt    | 48 ++++++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
index 427bad8..78978f1 100644
--- a/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen.txt
@@ -32,6 +32,10 @@ address is common of all subnode.
 		vcc_node {
 			...
 		};
+
+		flexgen_node {
+			...
+		};
 		...
 	};
 
@@ -45,6 +49,7 @@ Each subnode should use the binding discribe in [2]..[7]
 [5] Documentation/devicetree/bindings/clock/st,clkgen-prediv.txt
 [6] Documentation/devicetree/bindings/clock/st,vcc.txt
 [7] Documentation/devicetree/bindings/clock/st,quadfs.txt
+[8] Documentation/devicetree/bindings/clock/st,flexgen.txt
 
 
 Required properties:
diff --git a/Documentation/devicetree/bindings/clock/st/st,flexgen.txt b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
new file mode 100644
index 0000000..f2d4333
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,flexgen.txt
@@ -0,0 +1,48 @@
+Binding for a type of flexgen structure found on certain
+STMicroelectronics consumer electronics SoC devices
+
+This structure includes:
+- a clock cross bar (represented by a mux element)
+- a pre and final dividers (represented by a divider and gate elements)
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be:
+  "st,flexgen"
+
+- #clock-cells : from common clock binding; shall be set to 1.
+
+- clocks : from common clock binding
+
+- clock-output-names : From common clock binding. The block has 4
+                       clock outputs but not all of them in a specific instance
+                       have to be used in the SoC. If a clock name is left as
+                       an empty string then no clock will be created for the
+                       output associated with that string index. If fewer than
+                       4 strings are provided then no clocks will be created
+                       for the remaining outputs.
+
+Example:
+
+	clockgen-d2@x9106000 {
+		compatible = "st,clkgen-c32";
+		reg = <0x9106000 0x1000>;
+
+		clk_s_d2_flexgen: clk-s-d2-flexgen {
+			compatible = "st,flexgen";
+
+			#clock-cells = <1>;
+			clocks = <&clk_s_d2_quadfs 0>,
+				 <&clk_s_d2_quadfs 1>,
+				 <&clk_s_d2_quadfs 2>,
+				 <&clk_s_d2_quadfs 3>;
+
+			clock-output-names = "clk-pix-main-disp",
+					     "clk-pix-pip",
+					     "clk-pix-gdp1",
+					     "clk-pix-gdp2";
+		};
+	};
-- 
1.9.1

