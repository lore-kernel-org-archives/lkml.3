Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAXIqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:46:11 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:27006
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbaAXIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:46:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <kuninori.morimoto.gx@renesas.com>
CC: <rob@landley.net>, <perex@perex.cz>, <moinejf@free.fr>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 7/7] ASoC: binding: for new properties documenting and usage
Date: Fri, 24 Jan 2014 15:43:06 +0800
Message-ID: <1390549386-4702-8-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390549386-4702-1-git-send-email-Li.Xiubo@freescale.com>
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
	"simple-audio-card,tdm-slot".

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/simple-card.txt | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index 19c84df..dea1229 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -8,13 +8,19 @@ Required properties:
 
 Optional properties:
 
+- simple-audio-card,name		: User specified audio sound card name, one string
+					  property.
 - simple-audio-card,format		: CPU/CODEC common audio format.
 					  "i2s", "right_j", "left_j" , "dsp_a"
 					  "dsp_b", "ac97", "pdm", "msb", "lsb"
+- simple-audio-card,widgets		: A list of the off-CODEC widgets, each entry is a pair
+					  of strings, the first being the template widget name,
+					  the second being the user specified widget name.
 - simple-audio-card,routing		: A list of the connections between audio components.
 					  Each entry is a pair of strings, the first being the
 					  connection's sink, the second being the connection's
 					  source.
+- simple-audio-card,tdm-slot		: The configuration of TDM operation for CPU/CODEC DAI.
 
 Required subnodes:
 
@@ -42,11 +48,18 @@ Example:
 
 sound {
 	compatible = "simple-audio-card";
+	simple-audio-card,name = "VF610-Tower-Sound-Card";
 	simple-audio-card,format = "left_j";
+	simple-audio-card,widgets =
+		"Mic", "Microphone Jack",
+		"Hp", "Headphone Jack",
+		"Spk", "External Speaker";
 	simple-audio-card,routing =
-		"MIC_IN", "Mic Jack",
+		"MIC_IN", "Microphone Jack",
 		"Headphone Jack", "HP_OUT",
-		"Ext Spk", "LINE_OUT";
+		"External Speaker", "LINE_OUT";
+
+	simple-audio-card,tdm-slot = <0xffffffc 0xffffffc 2 0>;
 
 	simple-audio-card,cpu {
 		sound-dai = <&sh_fsi2 0>;
-- 
1.8.4


