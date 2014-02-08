Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaBHJGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 04:06:18 -0500
Received: from [65.55.88.13] ([65.55.88.13]:8597 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbaBHJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 04:05:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3 4/4] ASoC: binding: for new properties documenting and usage
Date: Sat, 8 Feb 2014 15:59:55 +0800
Message-ID: <1391846395-10193-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1391846395-10193-1-git-send-email-Li.Xiubo@freescale.com>
References: <1391846395-10193-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add the following three new properties documenting and usage
for simple card:

"simple-audio-card,name",
"simple-audio-card,widgets",

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/simple-card.txt | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index 19c84df..0527358 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -8,9 +8,12 @@ Required properties:
 
 Optional properties:
 
+- simple-audio-card,name		: User specified audio sound card name, one string
+					  property.
 - simple-audio-card,format		: CPU/CODEC common audio format.
 					  "i2s", "right_j", "left_j" , "dsp_a"
 					  "dsp_b", "ac97", "pdm", "msb", "lsb"
+- simple-audio-card,widgets		: Please refer to widgets.txt.
 - simple-audio-card,routing		: A list of the connections between audio components.
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
@@ -42,11 +45,16 @@ Example:
 
 sound {
 	compatible = "simple-audio-card";
+	simple-audio-card,name = "VF610-Tower-Sound-Card";
 	simple-audio-card,format = "left_j";
+	simple-audio-card,widgets =
+		"Microphone", "Microphone Jack",
+		"Headphone", "Headphone Jack",
+		"Speaker", "External Speaker";
 	simple-audio-card,routing =
-		"MIC_IN", "Mic Jack",
+		"MIC_IN", "Microphone Jack",
 		"Headphone Jack", "HP_OUT",
-		"Ext Spk", "LINE_OUT";
+		"External Speaker", "LINE_OUT";
 
 	simple-audio-card,cpu {
 		sound-dai = <&sh_fsi2 0>;
-- 
1.8.4


