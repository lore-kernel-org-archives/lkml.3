Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3JQJMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:12:15 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55590 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab3JQJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:12:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
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
Subject: [PATCHv1 8/8] Documentation: Add device tree bindings for Freescale VF610 sound.
Date: Thu, 17 Oct 2013 17:01:17 +0800
Message-ID: <1382000477-17304-9-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the Document for Freescale VF610 sound driver under
Documentation/devicetree/bindings/sound/.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/sound/fsl-sgtl5000.txt     | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt

diff --git a/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt b/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt
new file mode 100644
index 0000000..43e350f
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/fsl-sgtl5000.txt
@@ -0,0 +1,52 @@
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
+  -- SGTL5000 pins:
+     * MIC_IN
+     * LINE_IN
+     * HP_OUT
+     * LINE_OUT
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
1.8.0


