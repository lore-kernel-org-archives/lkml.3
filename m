Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaAPE6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:58:25 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:21548
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaAPE6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:58:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097h84d07hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: simple-card: Add snd_card's name parsing from DT node support
Date: Thu, 16 Jan 2014 12:00:01 +0800
Message-ID: <1389844801-29309-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
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
 sound/soc/generic/simple-card   | 0
 sound/soc/generic/simple-card.  | 0
 sound/soc/generic/simple-card.c | 7 ++++++-
 3 files changed, 6 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/generic/simple-card
 create mode 100644 sound/soc/generic/simple-card.

diff --git a/sound/soc/generic/simple-card b/sound/soc/generic/simple-card
new file mode 100644
index 0000000..e69de29
diff --git a/sound/soc/generic/simple-card. b/sound/soc/generic/simple-card.
new file mode 100644
index 0000000..e69de29
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 0e2fbdd..b40b57c 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -143,6 +143,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			return ret;
 	}
 
+	/* parsing the card name from DT */
+	snd_soc_of_parse_card_name(&info->snd_card,
+					"simple-audio-card,name");
+
 	/* CPU sub-node */
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
@@ -257,7 +261,8 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	/*
 	 * init snd_soc_card
 	 */
-	cinfo->snd_card.name		= cinfo->card;
+	if (!cinfo->snd_card.name)
+		cinfo->snd_card.name = cinfo->card;
 	cinfo->snd_card.owner		= THIS_MODULE;
 	cinfo->snd_card.dai_link	= &cinfo->snd_link;
 	cinfo->snd_card.num_links	= 1;
-- 
1.8.4


