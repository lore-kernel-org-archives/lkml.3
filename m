Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbbAUTdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:33:05 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:51517 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbbAUTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:32:53 -0500
X-Mailbox-Line: From 963571538ba210b4f2099949e03943ae1e9a8541 Mon Sep 17 00:00:00 2001
Message-Id: <963571538ba210b4f2099949e03943ae1e9a8541.1421868426.git.moinejf@free.fr>
In-Reply-To: <cover.1421868426.git.moinejf@free.fr>
References: <cover.1421868426.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 21 Jan 2015 20:10:17 +0100
Subject: [PATCH v2 2/3] Documentation: of: Document audio graph bindings
To: Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a document describing common OF bindings for audio devices.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/sound/audio-interfaces.txt | 101 +++++++++++++++++++++
 1 file changed, 101 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/audio-interfaces.txt

diff --git a/Documentation/devicetree/bindings/sound/audio-interfaces.txt b/Documentation/devicetree/bindings/sound/audio-interfaces.txt
new file mode 100644
index 0000000..4eddb3f
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/audio-interfaces.txt
@@ -0,0 +1,101 @@
+Common bindings for audio device graphs
+
+The graph of the audio ports follows the common binding for device graphs
+defined in Documentation/devicetree/bindings/graph.txt.
+
+Here are described only the audio specific properties.
+
+Port required properties:
+
+- port-type: "i2s" or "spdif"
+
+Port optional property:
+
+- reg: numeric value which defines how the port is wired to the device.
+	This value depends on the device. Usually, it is the content
+	of the device register which controls the audio pins.
+
+Port required nodes:
+
+- at least one 'endpoint' node must be specified.
+
+
+Example:
+
+The board contains an audio controller with two outputs:
+- the S/PDIF output is connected to two devices:
+	- a S/PDIF optical output
+	- a HDMI transmitter.
+- the I2S output is connected to an other audio input of the HDMI transmitter.
+
+	/* audio controller */
+	&audio1 {
+		status = "okay";
+		...
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* S/PDIF output */
+		port@0 {
+			port-type = "spdif";
+			audio1_spdif0: endpoint@0 {
+				remote-endpoint = <&spdif_out>;
+			};
+			audio1_spdif1: endpoint@1 {
+				remote-endpoint = <&tda998x_spdif>;
+			};
+		};
+
+		/* I2S output */
+		port@1 {
+			port-type = "i2s";
+			audio1_i2s: endpoint {
+				remote-endpoint = <&tda998x_i2s>;
+			};
+		};
+	};
+
+	/* optical output */
+	spdif_codec: spdif-codec {
+		...
+		port {
+			port-type = "spdif";
+			spdif_out: endpoint {
+				remote-endpoint = <&audio1_spdif0>;
+			};
+		};
+	};
+
+	/* HDMI transmitter */
+	hdmi: hdmi-encoder {
+		...
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* video input */
+		port@230145 {
+			port-type = "rgb";
+			reg = <0x230145>;
+			hdmi_0: endpoint {
+				remote-endpoint = <&lcd0_0>;
+			};
+		};
+
+		/* audio input I2S on AP1 */
+		port@3 {
+			port-type = "i2s";
+			reg = <0x03>;
+			tda998x_i2s: endpoint {
+				remote-endpoint = <&audio1_i2s>;
+			};
+		};
+
+		/* audio input S/PDIF on AP2 */
+		port@4 {
+			port-type = "spdif";
+			reg = <0x04>;
+			tda998x_spdif: endpoint {
+				remote-endpoint = <&audio1_spdif1>;
+			};
+		};
+	};
-- 
2.1.4

