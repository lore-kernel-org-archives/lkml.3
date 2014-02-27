Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaB0Kpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:45:44 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29589 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbaB0Kpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:45:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>
CC: <linux-pwm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv10 4/4] Documentation: Add device tree bindings for Freescale FTM PWM.
Date: Thu, 27 Feb 2014 17:39:52 +0800
Message-ID: <1393493992-26073-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393493992-26073-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393493992-26073-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the binding documentation for Freescale FlexTimer Module
(FTM) PWM driver under Documentation/devicetree/bindings/pwm/.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Yuan Yao <yao.yuan@freescale.com>
Acked-by: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
new file mode 100644
index 0000000..81f400d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
@@ -0,0 +1,35 @@
+Freescale FlexTimer Module (FTM) PWM controller
+
+Required properties:
+- compatible: Should be "fsl,vf610-ftm-pwm".
+- reg: Physical base address and length of the controller's registers
+- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
+  the cells format.
+- clock-names : Should include the following module clock source entries:
+    "ftm_sys" (module clock, also can be used as counter clock),
+    "ftm_ext" (external counter clock),
+    "ftm_fix" (fixed counter clock),
+    "ftm_cnt_clk_en" (external and fixed counter clock enable/disable).
+- clocks : Must contain a phandle and clock specifier for each entry in
+  clock-names, please see clock/clock-bindings.txt for details of the property
+  values.
+- pinctrl-names: Must contain a "default" entry.
+- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
+  See pinctrl/pinctrl-bindings.txt for details of the property values.
+
+
+Example:
+
+pwm0: pwm@40038000 {
+		compatible = "fsl,vf610-ftm-pwm";
+		reg = <0x40038000 0x1000>;
+		#pwm-cells = <3>;
+		clock-names = "ftm_sys", "ftm_ext",
+				"ftm_fix", "ftm_cnt_clk_en";
+		clocks = <&clks VF610_CLK_FTM0>,
+			<&clks VF610_CLK_FTM0_EXT_SEL>,
+			<&clks VF610_CLK_FTM0_FIX_SEL>,
+			<&clks VF610_CLK_FTM0_EXT_FIX_EN>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pwm0_1>;
+};
-- 
1.8.4


