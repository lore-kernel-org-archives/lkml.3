Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBZFK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:10:29 -0500
Received: from [213.199.154.207] ([213.199.154.207]:37508 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbaBZFK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:10:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <timur@tabi.org>, <tiwai@suse.de>, <lars@metafoo.de>,
        <Guangyu.Chen@freescale.com>, <fabio.estevam@freescale.com>,
        <shawn.guo@linaro.org>, <denis@eukrea.com>, <mpa@pengutronix.de>,
        <s.hauer@pengutronix.de>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 08/10] ASoC: blackfin: bf5xx-ad193x: Use snd_soc_dai_set_tdm_slot_xlate()
Date: Wed, 26 Feb 2014 11:59:33 +0800
Message-ID: <1393387175-15539-9-git-send-email-Li.Xiubo@freescale.com>
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
This will use the default snd_soc_of_xlate_tdm_slot_mask to generate
the TDM slot TX/RX mask using the slot parameter.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/blackfin/bf5xx-ad193x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ad193x.c b/sound/soc/blackfin/bf5xx-ad193x.c
index 603ad1f..f622faa 100644
--- a/sound/soc/blackfin/bf5xx-ad193x.c
+++ b/sound/soc/blackfin/bf5xx-ad193x.c
@@ -53,11 +53,11 @@ static int bf5xx_ad193x_link_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 
 	/* set codec DAI slots, 8 channels, all channels are enabled */
-	ret = snd_soc_dai_set_tdm_slot(codec_dai, 0xFF, 0xFF, 8, 32);
+	ret = snd_soc_dai_set_tdm_slot_xlate(codec_dai, 8, 32);
 	if (ret < 0)
 		return ret;
 
-	ret = snd_soc_dai_set_tdm_slot(cpu_dai, 0xFF, 0xFF, 8, 32);
+	ret = snd_soc_dai_set_tdm_slot_xlate(cpu_dai, 8, 32);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.4


