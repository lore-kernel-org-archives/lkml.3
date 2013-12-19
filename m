Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3LSQEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:04:05 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40635 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3LSPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:55:35 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, broonie@kernel.org, alsa-devel@alsa-project.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/11] ASoC: Ux500: Match platform by device node when booting Device Tree
Date: Thu, 19 Dec 2013 15:55:01 +0000
Message-Id: <1387468508-12286-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting closer to fully enabling the Ux500 ASoC driver for Device
Tree. When we switch over from using AUXDATA we'll need to match platform
by only Device Tree nodes. In this patch we NULL out the platform_name,
and supply nodes for each platform device.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 178d1ba..b3b66aa 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -91,6 +91,8 @@ static int mop500_of_probe(struct platform_device *pdev,
 	for (i = 0; i < 2; i++) {
 		mop500_dai_links[i].cpu_of_node = msp_np[i];
 		mop500_dai_links[i].cpu_dai_name = NULL;
+		mop500_dai_links[i].platform_of_node = msp_np[i];
+		mop500_dai_links[i].platform_name = NULL;
 		mop500_dai_links[i].codec_of_node = codec_np;
 		mop500_dai_links[i].codec_name = NULL;
 	}
-- 
1.8.3.2

