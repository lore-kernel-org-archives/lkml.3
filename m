Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbaCDJcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:32:15 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:1408 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbaCDJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:32:12 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [RFC][PATCH 3/3] ASoC: core: remove the default regmap I/O setting up from soc_probe_codec()
Date: Tue, 4 Mar 2014 16:25:29 +0800
Message-ID: <1393921529-28985-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all the CODEC drivers has using the snd_soc_register_codec()
to set up the CODEC I/O while the CODEC probing, so this could be
removed entirely.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 0fb502f..bc3a930 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1137,16 +1137,6 @@ static int soc_probe_codec(struct snd_soc_card *card,
 
 	codec->dapm.idle_bias_off = driver->idle_bias_off;
 
-	if (!codec->write && dev_get_regmap(codec->dev, NULL)) {
-		/* Set the default I/O up try regmap */
-		ret = snd_soc_codec_set_cache_io(codec, NULL);
-		if (ret < 0) {
-			dev_err(codec->dev,
-				"Failed to set cache I/O: %d\n", ret);
-			goto err_probe;
-		}
-	}
-
 	if (driver->probe) {
 		ret = driver->probe(codec);
 		if (ret < 0) {
-- 
1.8.4


