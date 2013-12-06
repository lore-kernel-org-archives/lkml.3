Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3LFJrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:47:51 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:15029
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab3LFJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:47:45 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ASoC: fsl: imx-wm8962: Don't update bias_level in machine driver
Date: Fri, 6 Dec 2013 17:47:42 +0800
Message-ID: <68a5b5c0d53260f190b58daf3e3a0b492148ed62.1386322845.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1386322845.git.b42378@freescale.com>
References: <cover.1386322845.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we update it here, the set_bias_level() of Codec driver won't be normally
called and we will then miss some essential procedures in set_bias_level() of
the Codec driver. Thus drop it.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 sound/soc/fsl/imx-wm8962.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/fsl/imx-wm8962.c b/sound/soc/fsl/imx-wm8962.c
index 61e4885..3fd76bc 100644
--- a/sound/soc/fsl/imx-wm8962.c
+++ b/sound/soc/fsl/imx-wm8962.c
@@ -130,8 +130,6 @@ static int imx_wm8962_set_bias_level(struct snd_soc_card *card,
 		break;
 	}
 
-	dapm->bias_level = level;
-
 	return 0;
 }
 
-- 
1.8.4


