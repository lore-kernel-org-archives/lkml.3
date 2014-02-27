Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaB0P0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:26:55 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:37401 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbaB0P0r (ORCPT
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
Subject: [PATCH v0 08/15] clk: st: Adds clockgen clock binding
Date: Thu, 27 Feb 2014 16:24:21 +0100
Message-Id: <1393514668-17440-9-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
new file mode 100644
index 0000000..81eb385
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clkgen-pll.txt
@@ -0,0 +1,48 @@
+Binding for a ST pll clock driver.
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
+	"st,clkgena-plls-c65"
+	"st,plls-c32-a1x-0",		"st,clkgen-plls-c32"
+	"st,plls-c32-a1x-1",		"st,clkgen-plls-c32"
+	"st,stih415-plls-c32-a9",	"st,clkgen-plls-c32"
+	"st,stih415-plls-c32-ddr",	"st,clkgen-plls-c32"
+	"st,stih416-plls-c32-a9",	"st,clkgen-plls-c32"
+	"st,stih416-plls-c32-ddr",	"st,clkgen-plls-c32"
+
+	"st,stih415-gpu-pll-c32",	"st,clkgengpu-pll-c32"
+	"st,stih416-gpu-pll-c32",	"st,clkgengpu-pll-c32"
+
+
+- #clock-cells : From common clock binding; shall be set to 1.
+
+- clocks : From common clock binding
+
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clockgenA@fee62000 {
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
+	};
-- 
1.9.0

