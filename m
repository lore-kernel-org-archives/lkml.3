Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3GBJZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:25:40 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64098 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3GBJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:25:39 -0400
MIME-Version: 1.0
Date: Tue, 2 Jul 2013 17:25:37 +0800
Message-ID: <CAPgLHd8i0kcs5RE2UUPmFS5ueMgRAzofeaAUnGz4WuYFBANeBw@mail.gmail.com>
Subject: [PATCH] ASoC: mop500: add .owner to struct snd_soc_card
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, lee.jones@linaro.org,
        linus.walleij@linaro.org, ola.o.lilja@stericsson.com,
        wfp5p@virginia.edu
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add missing .owner of struct snd_soc_card. This prevents the
module from being removed from underneath its users.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/ux500/mop500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 8f5cd00..178d1ba 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -52,6 +52,7 @@ static struct snd_soc_dai_link mop500_dai_links[] = {
 
 static struct snd_soc_card mop500_card = {
 	.name = "MOP500-card",
+	.owner = THIS_MODULE,
 	.probe = NULL,
 	.dai_link = mop500_dai_links,
 	.num_links = ARRAY_SIZE(mop500_dai_links),

