Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3KAHt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:49:29 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:46571
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488Ab3KAHtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:49:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCHv2 4/8] Documentation: Add device tree bindings for Freescale SAI.
Date: Fri, 1 Nov 2013 15:04:51 +0800
Message-ID: <1383289495-24523-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
References: <1383289495-24523-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Document for Freescale SAI driver under
Documentation/devicetree/bindings/sound/.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/sound/fsl-sai.txt          | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl-sai.txt

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
new file mode 100644
index 0000000..267afbd
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -0,0 +1,32 @@
+Freescale Synchronous Audio Interface (SAI).
+
+The SAI is based on I2S module that used communicating with audio codecs,
+which provides a synchronous audio interface that supports fullduplex
+serial interfaces with frame synchronization such as I2S, AC97, TDM, and
+codec/DSP interfaces.
+
+
+Required properties:
+- compatible: Compatible list, contains "fsl,vf610-sai".
+- reg: Offset and length of the register set for the device.
+- clocks: Must contain an entry for each entry in clock-names.
+- clock-names : Must include the "sai" entry.
+- dmas : Generic dma devicetree binding as described in
+  Documentation/devicetree/bindings/dma/dma.txt.
+- dma-names : Two dmas have to be defined, "tx" and "rx".
+- pinctrl-names: Must contain a "default" entry.
+- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
+  See ../pinctrl/pinctrl-bindings.txt for details of the property values.
+
+Example:
+sai2: sai@40031000 {
+	      compatible = "fsl,vf610-sai";
+	      reg = <0x40031000 0x1000>;
+	      pinctrl-names = "default";
+	      pinctrl-0 = <&pinctrl_sai2_1>;
+	      clocks = <&clks VF610_CLK_SAI2>;
+	      clock-names = "sai";
+	      dma-names = "tx", "rx";
+	      dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
+		   <&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
+};
-- 
1.8.4


