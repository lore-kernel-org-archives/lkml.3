Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3KFJy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:54:56 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:65299 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3KFJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:54:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@linaro.org>
Subject: [PATCH 1/2] ASoC: ab8500: Revert "ASoC: ab8500: Explicitly set I/O up"
Date: Wed,  6 Nov 2013 09:54:44 +0000
Message-Id: <1383731685-18441-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 2245e3c31c15c2d2a26926c4b734f4d3a37ae252, as it
is one of two patches which stop audio from working on Snowball.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index a0394a8..ca500fd 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2473,8 +2473,6 @@ static int ab8500_codec_probe(struct snd_soc_codec *codec)
 
 	dev_dbg(dev, "%s: Enter.\n", __func__);
 
-	snd_soc_codec_set_cache_io(codec, 0, 0, SND_SOC_REGMAP);
-
 	/* Setup AB8500 according to board-settings */
 	pdata = dev_get_platdata(dev->parent);
 
-- 
1.8.1.2

