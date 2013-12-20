Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3LTHcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:32:10 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:27895
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab3LTHcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:32:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097h84d07hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <kuninori.morimoto.gx@renesas.com>
CC: <fabio.estevam@freescale.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: simple-card: Add cpu_dai and codec_dai names NULL check
Date: Fri, 20 Dec 2013 14:39:50 +0800
Message-ID: <1387521591-15262-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of cpu DAI maybe omitted, and then strlen() will lead
kernel panic.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 3d190d0..1d87db8 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -142,6 +142,9 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (ret < 0)
 		return ret;
 
+	if (!info->cpu_dai.name || !info->codec_dai.name)
+		return -EINVAL;
+
 	/* card name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
 			    strlen(info->cpu_dai.name)   +
-- 
1.8.4


