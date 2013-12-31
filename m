Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab3LaJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:05:42 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:12233
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027Ab3LaJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:05:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(zz78fbmzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: add snd_soc_of_parse_master_clkdir() for dt
Date: Tue, 31 Dec 2013 16:10:44 +0800
Message-ID: <1388477444-18745-1-git-send-email-Li.Xiubo@freescale.com>
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

[prefix]master-clkdir;

If this property is absent 0 will be returned, 1 otherwise.
0 : SND_SOC_CLOCK_IN
1 : SND_SOC_CLOCK_OUT

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---

I'm not very sure whether this patch is need for dt.

For the CPU and CODEC devices' sysclk directions maybe different of
the same DAI link.



 include/sound/soc.h  |  2 ++
 sound/soc/soc-core.c | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 5a049d9..1d6396a 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1170,6 +1170,8 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
+unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np,
+					    const char *prefix);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix);
 int snd_soc_of_get_dai_name(struct device_node *of_node,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index be88df5..faf102f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4472,6 +4472,25 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_routing);
 
+unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np,
+					    const char *prefix)
+{
+	char prop[128];
+
+	if (!prefix)
+		prefix = "";
+
+	/*
+	 * check "[prefix]master-clkdir"
+	 * true means SND_SOC_CLOCK_OUT
+	 * false means SND_SOC_CLOCK_IN
+	 */
+	snprintf(prop, sizeof(prop), "%smaster-clkdir", prefix);
+
+	return !!of_property_read_bool(np, prop);
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_master_clkdir);
+
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix)
 {
-- 
1.8.4


