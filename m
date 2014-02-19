Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaBUPeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:34:37 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:33317 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaBUPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:34:35 -0500
X-Mailbox-Line: From 41aa7354a6883f31afa60c21c2e14ecbb3bbb7e9 Mon Sep 17 00:00:00 2001
Message-Id: <41aa7354a6883f31afa60c21c2e14ecbb3bbb7e9.1392995566.git.moinejf@free.fr>
In-Reply-To: <cover.1392995566.git.moinejf@free.fr>
References: <cover.1392995566.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 19 Feb 2014 19:07:41 +0100
Subject: [PATCH 2/4] ASoC: simple-card: dynamically allocate the DAI link
 array
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DAI link array is hard-coded as a single CPU / CODEC DAIs link.

This patch allocates this array with the card definition and facilitates
handling more links.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 8809ab4..a75a8bb 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -20,7 +20,6 @@ struct simple_card_data {
 	unsigned int daifmt;
 	struct asoc_simple_dai cpu_dai;
 	struct asoc_simple_dai codec_dai;
-	struct snd_soc_dai_link snd_link;
 };
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
@@ -246,7 +245,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev,
+			sizeof(*priv) + sizeof(*dai_link),
+			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -255,7 +256,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	 */
 	priv->snd_card.owner = THIS_MODULE;
 	priv->snd_card.dev = dev;
-	dai_link = &priv->snd_link;
+	dai_link = (struct snd_soc_dai_link *) (priv + 1);
 	priv->snd_card.dai_link = dai_link;
 	priv->snd_card.num_links = 1;
 
-- 
1.9.0

