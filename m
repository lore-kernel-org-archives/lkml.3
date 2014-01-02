Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbaABDpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:45:04 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:49528
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbaABDpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:45:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(zz78fbmzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2] ASoC: soc-core: add snd_soc_of_parse_master_clkdir() for dt
Date: Thu, 2 Jan 2014 10:48:25 +0800
Message-ID: <1388630905-1321-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds snd_soc_of_parse_master_clkdir() and supports below
style on dt:

master-clkdir-out;

If this property is absent 0 will be returned, 1 otherwise.
0 : SND_SOC_CLOCK_IN
1 : SND_SOC_CLOCK_OUT

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  |  1 +
 sound/soc/soc-core.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 5a049d9..690f4f6 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1170,6 +1170,7 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
+unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix);
 int snd_soc_of_get_dai_name(struct device_node *of_node,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index be88df5..f155207 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4472,6 +4472,17 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_routing);
 
+unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np)
+{
+	/*
+	 * check "master-clkdir-out"
+	 * false means SND_SOC_CLOCK_IN
+	 * true means SND_SOC_CLOCK_OUT
+	 */
+	return !!of_property_read_bool(np, "master-clkdir-out");
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_master_clkdir);
+
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix)
 {
-- 
1.8.4


