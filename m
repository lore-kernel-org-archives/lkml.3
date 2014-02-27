Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaB0P3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:29:47 -0500
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:46921 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbaB0P0r (ORCPT
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
Subject: [PATCH v0 10/15] clk: st: Adds quadfs clock binding
Date: Thu, 27 Feb 2014 16:24:23 +0100
Message-Id: <1393514668-17440-11-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 .../devicetree/bindings/clock/st/st,quadfs.txt     | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,quadfs.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,quadfs.txt b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
new file mode 100644
index 0000000..ec86d62
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,quadfs.txt
@@ -0,0 +1,45 @@
+Binding for a type of quad channel digital frequency synthesizer found on
+certain STMicroelectronics consumer electronics SoC devices.
+
+This version contains a programmable PLL which can generate up to 216, 432
+or 660MHz (from a 30MHz oscillator input) as the input to the digital
+synthesizers.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be:
+  "st,stih416-quadfs216",	"st,quadfs"
+  "st,stih416-quadfs432",	"st,quadfs"
+  "st,stih416-quadfs660-E",	"st,quadfs"
+  "st,stih416-quadfs660-F",	"st,quadfs"
+
+- #clock-cells : from common clock binding; shall be set to 1.
+
+- reg : A Base address and length of the register set.
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
+	CLOCKGEN_E: CLOCKGEN_E {
+                #clock-cells = <1>;
+                compatible = "st,stih416-quadfs660-E", "st,quadfs";
+                reg = <0xfd3208bc 0xB0>;
+
+                clocks = <&CLK_SYSIN>;
+                clock-output-names = "CLK_M_PIX_MDTP_0",
+                                        "CLK_M_PIX_MDTP_1",
+                                        "CLK_M_PIX_MDTP_2",
+                                        "CLK_M_MPELPC";
+        };
-- 
1.9.0

