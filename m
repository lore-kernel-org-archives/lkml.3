Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3LQERl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:17:41 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:40727
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab3LQERh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:17:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <timur@tabi.org>,
        <perex@perex.cz>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>
Subject: [PATCHv3 7/7] Documentation: Add device tree bindings for Freescale VF610 sound.
Date: Tue, 17 Dec 2013 11:24:44 +0800
Message-ID: <1387250684-23406-8-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
References: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Document for Freescale VF610 sound driver under
Documentation/devicetree/bindings/sound/.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../bindings/sound/vf610-audio-sgt15000.txt        | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/vf610-audio-sgt15000.txt

diff --git a/Documentation/devicetree/bindings/sound/vf610-audio-sgt15000.txt b/Documentation/devicetree/bindings/sound/vf610-audio-sgt15000.txt
new file mode 100644
index 0000000..76ff838
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/vf610-audio-sgt15000.txt
@@ -0,0 +1,46 @@
+Freescale VF610 audio complex with SGTL5000 codec
+
+Required properties:
+- compatible: "fsl,vf610-sgtl5000"
+- model: The user-visible name of this sound complex.
+- saif-controllers: The phandle list of the SAI controller.
+- audio-codec: The phandle of the SGTL5000 audio codec.
+- audio-routing : A list of the connections between audio components.
+  Each entry is a pair of strings, the first being the connection's sink,
+  the second being the connection's source. Valid names could be power
+  supplies, SGTL5000 pins, and the jacks on the board:
+
+  -- Power supplies:
+     * Mic Bias
+
+  -- Board connectors:
+     * Mic Jack
+     * Line In Jack
+     * Headphone Jack
+     * Line Out Jack
+     * Ext Spk
+
+Example:
+
+sound {
+	compatible = "fsl,vf610-sgtl5000";
+	model = "vf610-sgtl5000";
+	saif-controller = <&sai2>;
+	audio-codec = <&codec>;
+	audio-routing =
+		"MIC_IN", "Mic Jack",
+		"Mic Jack", "Mic Bias",
+		"LINE_IN", "Line In Jack",
+		"Headphone Jack", "HP_OUT",
+		"Ext Spk", "LINE_OUT";
+};
+
+&i2c0 {
+	...
+
+	codec: sgtl5000@0a {
+	       compatible = "fsl,sgtl5000";
+	       reg = <0x0a>;
+	       clocks = <&clks VF610_CLK_SAI2>;
+       };
+};
-- 
1.8.4


