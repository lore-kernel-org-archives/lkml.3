Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaCKKlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:41:36 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:48868 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbaCKKld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:41:33 -0400
X-Mailbox-Line: From bc0e25f6c042c8b99c8e83c6876ce0c8f7c3ab36 Mon Sep 17 00:00:00 2001
Message-Id: <bc0e25f6c042c8b99c8e83c6876ce0c8f7c3ab36.1394533640.git.moinejf@free.fr>
In-Reply-To: <cover.1394533640.git.moinejf@free.fr>
References: <cover.1394533640.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 11 Mar 2014 10:58:33 +0100
Subject: [PATCH v2 4/4] ASoC: simple-card: Add DT documentation for multi-DAI
 links
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be many couples of CPU/CODEC DAI links.
The example 2 is extracted from the Cubox DT.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/sound/simple-card.txt      | 34 +++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index b30c222..a872e7b 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -26,6 +26,9 @@ Required subnodes:
 - simple-audio-card,cpu			: CPU   sub-node
 - simple-audio-card,codec		: CODEC sub-node
 
+  There may be one or many couples (simple-audio-card,cpu, simple-audio-card,codec)
+  (see example 2).
+
 Required CPU/CODEC subnodes properties:
 
 - sound-dai				: phandle and port of CPU/CODEC
@@ -43,7 +46,7 @@ Optional CPU/CODEC subnodes properties:
 					  clock node (= common clock), or "system-clock-frequency"
 					  (if system doens't support common clock)
 
-Example:
+Example 1:
 
 sound {
 	compatible = "simple-audio-card";
@@ -88,3 +91,32 @@ sh_fsi2: sh_fsi2@ec230000 {
 	interrupt-parent = <&gic>;
 	interrupts = <0 146 0x4>;
 };
+
+Example 2:
+
+sound {
+	compatible = "simple-audio-card";
+	simple-audio-card,name = "Cubox Audio";
+
+	simple-audio-card,cpu@0 {		/* I2S - HDMI */
+		sound-dai = <&audio1 0>;
+		format = "i2s";
+	};
+	simple-audio-card,codec@0 {
+		sound-dai = <&tda998x 0>;
+	};
+
+	simple-audio-card,cpu@1 {		/* S/PDIF - HDMI */
+		sound-dai = <&audio1 1>;
+	};
+	simple-audio-card,codec@1 {
+		sound-dai = <&tda998x 1>;
+	};
+
+	simple-audio-card,cpu@2 {		/* S/PDIF - S/PDIF */
+		sound-dai = <&audio1 1>;
+	};
+	simple-audio-card,codec@2 {
+		sound-dai = <&spdif_codec>;
+	};
+};
-- 
1.9.0

