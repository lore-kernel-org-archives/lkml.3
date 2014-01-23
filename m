Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaAWGCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:02:06 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26688
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090AbaAWGCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:02:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097h84d07hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>
CC: <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH Resend 4/8] ASoC: simple-card: Add snd_card's name parsing from DT node support
Date: Thu, 23 Jan 2014 13:02:46 +0800
Message-ID: <1390453370-29194-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the DT is used and the CPU DAI device has only one DAI, the card
name will be like :

ALSA device list:
0: 40031000.sai-sgtl5000

And this name maybe a little ugly to some customers, so here the
card name parsing from DT node is supported.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index f38e56e..546b93d 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -140,6 +140,9 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	char *name;
 	int ret;
 
+	/* parsing the card name from DT */
+	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
+
 	/* get CPU/CODEC common format via simple-audio-card,format */
 	priv->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
 		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
@@ -184,7 +187,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			    GFP_KERNEL);
 	sprintf(name, "%s-%s", dai_link->cpu_dai_name,
 				dai_link->codec_dai_name);
-	priv->snd_card.name = name;
+	if (!priv->snd_card.name)
+		priv->snd_card.name = name;
 	dai_link->name = dai_link->stream_name = name;
 
 	/* simple-card assumes platform == cpu */
-- 
1.8.4


