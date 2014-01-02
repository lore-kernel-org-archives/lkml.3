Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaABIaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:30:19 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:28347
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaABIaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:30:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zz853kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: soc-core: add snd_soc_of_parse_sysclk_id() for dt
Date: Thu, 2 Jan 2014 15:34:17 +0800
Message-ID: <1388648057-28373-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds snd_soc_of_parse_sysclk_id() and supports below
style on dt:

sysclk-id = <XXX>;

It's an optional property, If this property is absent the defualt
vaule 0 will be returned.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/soc.h  |  1 +
 sound/soc/soc-core.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 5a049d9..86ac72f 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1170,6 +1170,7 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname);
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
+unsigned int snd_soc_of_parse_sysclk_id(struct device_node *np);
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix);
 int snd_soc_of_get_dai_name(struct device_node *of_node,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index be88df5..572d95d 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4472,6 +4472,22 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_routing);
 
+unsigned int snd_soc_of_parse_sysclk_id(struct device_node *np)
+{
+	u32 id;
+
+	/*
+	 * check "sysclk-id = <XX>"
+	 * it is an optional property
+	 * 0 will be returned if absent
+	 */
+	if (of_property_read_u32(np, "sysclk-id", &id))
+		id = 0;
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(snd_soc_of_parse_sysclk_id);
+
 unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 				     const char *prefix)
 {
-- 
1.8.4


