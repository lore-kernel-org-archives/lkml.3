Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3KFKSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:18:30 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41013 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3KFKRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:17:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 08/13] ASoC: generic-dmaengine-pcm: Clear slave_config memory
Date: Wed,  6 Nov 2013 10:16:20 +0000
Message-Id: <1383732985-18928-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently assume that the DMA Slave Config will be fully populated
by the platform, however some DMA Engines make decisions based on zero
(default) flags such as DMA_SLAVE_BUSWIDTH_UNDEFINED and as this is a
static declaration we need to memset it to clear the data area.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index ee07903..6ad4c7a 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -90,6 +90,8 @@ static int dmaengine_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct dma_slave_config slave_config;
 	int ret;
 
+	memset(&slave_config, 0, sizeof(slave_config));
+
 	if (!pcm->config)
 		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
 	else
-- 
1.8.1.2

