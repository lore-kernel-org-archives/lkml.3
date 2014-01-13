Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaAMGvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 01:51:52 -0500
Received: from [207.46.163.26] ([207.46.163.26]:44716 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbaAMGvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 01:51:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 3/6] ASoC: simple-card: simple audio card widgets getting
Date: Mon, 13 Jan 2014 13:53:55 +0800
Message-ID: <1389592438-13761-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index b7dc63e..dbd93cc 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -125,6 +125,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct device_node **of_codec,
 				     struct device_node **of_platform)
 {
+	struct snd_soc_widgets *wdg;
 	struct device_node *np;
 	char *name;
 	int ret;
@@ -133,6 +134,14 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
 		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
 
+	wdg = snd_soc_get_widgets(node);
+	if (!IS_ERR_OR_NULL(wdg)) {
+		info->snd_card.dapm_widgets = wdg->widgets;
+		info->snd_card.num_dapm_widgets = wdg->cnt;
+	} else if (IS_ERR(wdg)) {
+		return PTR_ERR(wdg);
+	}
+
 	/* DAPM routes */
 	if (of_property_read_bool(node, "simple-audio-card,routing")) {
 		ret = snd_soc_of_parse_audio_routing(&info->snd_card,
-- 
1.8.4


