Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaB0Kzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:55:43 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17610
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbaB0Kzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:55:41 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/3] ASoC: io: Clean up snd_soc_codec_set_cache_io()
Date: Thu, 27 Feb 2014 17:49:51 +0800
Message-ID: <1393494593-26310-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all users have been converted to regmap and the config.reg_bits
and config.val_bits can be setted by each user through regmap core API.
So these two params are redundant here.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/sound/soc/soc-io.c b/sound/soc/soc-io.c
index add99e2..18353f1 100644
--- a/sound/soc/soc-io.c
+++ b/sound/soc/soc-io.c
@@ -88,16 +88,11 @@ int snd_soc_codec_set_cache_io(struct snd_soc_codec *codec,
 			       int addr_bits, int data_bits,
 			       enum snd_soc_control_type control)
 {
-	struct regmap_config config;
 	int ret;
 
-	memset(&config, 0, sizeof(config));
 	codec->write = hw_write;
 	codec->read = hw_read;
 
-	config.reg_bits = addr_bits;
-	config.val_bits = data_bits;
-
 	switch (control) {
 	case SND_SOC_REGMAP:
 		/* Device has made its own regmap arrangements */
-- 
1.8.4


