Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaBZFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:09:59 -0500
Received: from [216.32.181.183] ([216.32.181.183]:9098 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbaBZFJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:09:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <timur@tabi.org>, <tiwai@suse.de>, <lars@metafoo.de>,
        <Guangyu.Chen@freescale.com>, <fabio.estevam@freescale.com>,
        <shawn.guo@linaro.org>, <denis@eukrea.com>, <mpa@pengutronix.de>,
        <s.hauer@pengutronix.de>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 06/10] ASoC: simple-card: Use snd_soc_dai_set_tdm_slot_xlate()
Date: Wed, 26 Feb 2014 11:59:31 +0800
Message-ID: <1393387175-15539-7-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_dai_set_tdm_slot_xlate instead of snd_soc_dai_set_tdm_slot.

This will use the DAI driver specified .of_xlate_tdm_slot_mask to generate
the TDM slot TX/RX mask, or the default snd_soc_of_xlate_tdm_slot_mask will
be used instead if it's absent.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index bdd176d..22efa83 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -48,11 +48,10 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 	}
 
 	if (set->slots) {
-		ret = snd_soc_dai_set_tdm_slot(dai, 0, 0,
-						set->slots,
-						set->slot_width);
+		ret = snd_soc_dai_set_tdm_slot_xlate(dai, set->slots,
+						     set->slot_width);
 		if (ret && ret != -ENOTSUPP) {
-			dev_err(dai->dev, "simple-card: set_tdm_slot error\n");
+			dev_err(dai->dev, "simple-card: set_tdm_slot_xlate error\n");
 			goto err;
 		}
 	}
-- 
1.8.4


