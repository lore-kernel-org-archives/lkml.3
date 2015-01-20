Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbbATTog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:44:36 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:24853 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbbATTod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:44:33 -0500
X-Mailbox-Line: From e0d835bcc282db36d7dcd2e5aab41356f194ed73 Mon Sep 17 00:00:00 2001
Message-Id: <e0d835bcc282db36d7dcd2e5aab41356f194ed73.1421782533.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 19:47:34 +0100
Subject: [PATCH v10 8/9] ASoC: core: export snd_soc_get_dai_name
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_get_dai_name() may be used to define a sound card with
a different syntax from the one of the simple-card.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/soc.h  | 2 ++
 sound/soc/soc-core.c | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index edd4a0a..7e783d6 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1502,6 +1502,8 @@ int snd_soc_of_get_dai_name(struct device_node *of_node,
 int snd_soc_of_get_dai_link_codecs(struct device *dev,
 				   struct device_node *of_node,
 				   struct snd_soc_dai_link *dai_link);
+int snd_soc_get_dai_name(struct of_phandle_args *args,
+			 const char **dai_name);
 
 #include <sound/soc-dai.h>
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index ededb97..6a782ca 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3418,8 +3418,8 @@ unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_daifmt);
 
-static int snd_soc_get_dai_name(struct of_phandle_args *args,
-				const char **dai_name)
+int snd_soc_get_dai_name(struct of_phandle_args *args,
+			 const char **dai_name)
 {
 	struct snd_soc_component *pos;
 	int ret = -EPROBE_DEFER;
@@ -3465,6 +3465,7 @@ static int snd_soc_get_dai_name(struct of_phandle_args *args,
 	mutex_unlock(&client_mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(snd_soc_get_dai_name);
 
 int snd_soc_of_get_dai_name(struct device_node *of_node,
 			    const char **dai_name)
-- 
2.1.4

