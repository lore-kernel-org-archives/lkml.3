Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3I3GWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:22:47 -0400
Received: from [207.46.163.26] ([207.46.163.26]:19344 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753128Ab3I3GWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:22:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCHv5 4/4] Documentation: Add device tree bindings for Freescale FTM PWM.
Date: Mon, 30 Sep 2013 14:13:31 +0800
Message-ID: <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
References: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Document for Freescale FTM PWM driver under
Documentation/devicetree/bindings/pwm/.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
new file mode 100644
index 0000000..2c6969a
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
@@ -0,0 +1,33 @@
+Freescale FTM PWM controller
+
+Required properties:
+- compatible: Should be "fsl,vf610-ftm-pwm"
+- reg: Physical base address and length of the controller's registers
+- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
+  the cells format.
+- clock-names : Includes the following module clock source entries:
+    "ftm0" (system clock),
+    "ftm0_fix_sel" (fixed frequency clock),
+    "ftm0_ext_sel" (external clock)
+- clocks : Must contain a clock specifier for each entry in clock-names.
+- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
+  entries in clock-names.
+- pinctrl-names: must contain a "default" entry.
+- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
+  See ../pinctrl/pinctrl-bindings.txt for details of the property values.
+
+
+Example:
+
+pwm0: pwm@40038000 {
+		compatible = "fsl,vf610-ftm-pwm";
+		reg = <0x40038000 0x1000>;
+		#pwm-cells = <3>;
+		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
+		clocks = <&clks VF610_CLK_FTM0>,
+			<&clks VF610_CLK_FTM0_FIX_SEL>,
+			<&clks VF610_CLK_FTM0_EXT_SEL>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pwm0_1>;
+		fsl,pwm-counter-clk = "ftm0_ext_sel";
+};
-- 
1.8.0


