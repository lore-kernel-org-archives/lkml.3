Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaBZFLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:11:00 -0500
Received: from [207.46.163.28] ([207.46.163.28]:6467 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbaBZFK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:10:56 -0500
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
Subject: [PATCH 10/10] ASoC: fsl: wm1133-ev1: Use snd_soc_dai_set_tdm_slot_xlate()
Date: Wed, 26 Feb 2014 11:59:35 +0800
Message-ID: <1393387175-15539-11-git-send-email-Li.Xiubo@freescale.com>
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
 sound/soc/fsl/wm1133-ev1.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/sound/soc/fsl/wm1133-ev1.c b/sound/soc/fsl/wm1133-ev1.c
index fce6325..4519b08 100644
--- a/sound/soc/fsl/wm1133-ev1.c
+++ b/sound/soc/fsl/wm1133-ev1.c
@@ -114,16 +114,7 @@ static int wm1133_ev1_hw_params(struct snd_pcm_substream *substream,
 	snd_soc_dai_set_fmt(cpu_dai, dai_format);
 
 	/* TODO: The SSI driver should figure this out for us */
-	switch (channels) {
-	case 2:
-		snd_soc_dai_set_tdm_slot(cpu_dai, 0xffffffc, 0xffffffc, 2, 0);
-		break;
-	case 1:
-		snd_soc_dai_set_tdm_slot(cpu_dai, 0xffffffe, 0xffffffe, 1, 0);
-		break;
-	default:
-		return -EINVAL;
-	}
+	snd_soc_dai_set_tdm_slot_xlate(cpu_dai, channels, 0);
 
 	/* set MCLK as the codec system clock for DAC and ADC */
 	snd_soc_dai_set_sysclk(codec_dai, WM8350_MCLK_SEL_PLL_MCLK,
-- 
1.8.4


