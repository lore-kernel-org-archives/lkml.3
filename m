Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaAWGLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:11:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:11473 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbaAWGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:11:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>
CC: <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 5/8] ASoC: core: set_tdm_slot() will return -ENOTSUPP if no operation provided
Date: Thu, 23 Jan 2014 13:02:47 +0800
Message-ID: <1390453370-29194-6-git-send-email-Li.Xiubo@freescale.com>
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

Make it easier for generic code to work with set_tdm_slot() by distinguishing
between the operation not being supported and an error as is done.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index fe1df50..393ff06 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3626,7 +3626,7 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 		return dai->driver->ops->set_tdm_slot(dai, tx_mask, rx_mask,
 				slots, slot_width);
 	else
-		return -EINVAL;
+		return -ENOTSUPP;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dai_set_tdm_slot);
 
-- 
1.8.4


