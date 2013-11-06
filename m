Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3KFKRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:17:08 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61762 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab3KFKRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 09/13] ASoC: Ux500: Match platform by device node when booting Device Tree
Date: Wed,  6 Nov 2013 10:16:21 +0000
Message-Id: <1383732985-18928-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting closer to fully enabling the Ux500 ASoC driver for Device
Tree. When we switch over from using AUXDATA we'll need to match platform
by only Device Tree nodes. In this patch we NULL out the platform_name,
and supply nodes for each platform device.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 178d1ba..4dc7b81 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -90,7 +90,9 @@ static int mop500_of_probe(struct platform_device *pdev,
 
 	for (i = 0; i < 2; i++) {
 		mop500_dai_links[i].cpu_of_node = msp_np[i];
+		mop500_dai_links[i].platform_of_node = msp_np[i];
 		mop500_dai_links[i].cpu_dai_name = NULL;
+		mop500_dai_links[i].platform_name = NULL;
 		mop500_dai_links[i].codec_of_node = codec_np;
 		mop500_dai_links[i].codec_name = NULL;
 	}
-- 
1.8.1.2

