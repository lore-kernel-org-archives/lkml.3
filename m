Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaBJHuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:50:21 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:23640 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbaBJHuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:50:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bize0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <Guangyu.Chen@freescale.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl-esai: fix ESAI TDM slot setting
Date: Mon, 10 Feb 2014 14:47:17 +0800
Message-ID: <1392014837-22308-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_esai.c | 4 ++--
 sound/soc/fsl/fsl_esai.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index d0c72ed..c84026c 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -326,7 +326,7 @@ static int fsl_esai_set_dai_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask,
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_TSMA,
 			   ESAI_xSMA_xS_MASK, ESAI_xSMA_xS(tx_mask));
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_TSMB,
-			   ESAI_xSMA_xS_MASK, ESAI_xSMB_xS(tx_mask));
+			   ESAI_xSMB_xS_MASK, ESAI_xSMB_xS(tx_mask));
 
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_RCCR,
 			   ESAI_xCCR_xDC_MASK, ESAI_xCCR_xDC(slots));
@@ -334,7 +334,7 @@ static int fsl_esai_set_dai_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask,
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_RSMA,
 			   ESAI_xSMA_xS_MASK, ESAI_xSMA_xS(rx_mask));
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_RSMB,
-			   ESAI_xSMA_xS_MASK, ESAI_xSMB_xS(rx_mask));
+			   ESAI_xSMB_xS_MASK, ESAI_xSMB_xS(rx_mask));
 
 	esai_priv->slot_width = slot_width;
 
diff --git a/sound/soc/fsl/fsl_esai.h b/sound/soc/fsl/fsl_esai.h
index 9c9f957..75e1403 100644
--- a/sound/soc/fsl/fsl_esai.h
+++ b/sound/soc/fsl/fsl_esai.h
@@ -322,7 +322,7 @@
 #define ESAI_xSMB_xS_SHIFT	0
 #define ESAI_xSMB_xS_WIDTH	16
 #define ESAI_xSMB_xS_MASK	(((1 << ESAI_xSMB_xS_WIDTH) - 1) << ESAI_xSMB_xS_SHIFT)
-#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) & ESAI_xSMA_xS_MASK)
+#define ESAI_xSMB_xS(v)		(((v) >> ESAI_xSMA_xS_WIDTH) & ESAI_xSMB_xS_MASK)
 
 /* Port C Direction Register -- REG_ESAI_PRRC 0xF8 */
 #define ESAI_PRRC_PDC_SHIFT	0
-- 
1.8.4


