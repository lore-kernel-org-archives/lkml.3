Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3IMXXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:23:15 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48710 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3IMXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:23:14 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com, broonie@kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] ASoC: blackfin: Add missing break statement to bf6xx
Date: Sat, 14 Sep 2013 02:20:37 +0300
Message-Id: <1379114437-25090-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNDRV_PCM_FORMAT_S8 isn't supposed to fall through to SNDRV_PCM_FORMAT_S16_LE

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 sound/soc/blackfin/bf6xx-i2s.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/blackfin/bf6xx-i2s.c b/sound/soc/blackfin/bf6xx-i2s.c
index c02405c..5810a06 100644
--- a/sound/soc/blackfin/bf6xx-i2s.c
+++ b/sound/soc/blackfin/bf6xx-i2s.c
@@ -88,6 +88,7 @@ static int bfin_i2s_hw_params(struct snd_pcm_substream *substream,
 	case SNDRV_PCM_FORMAT_S8:
 		param.spctl |= 0x70;
 		sport->wdsize = 1;
+		break;
 	case SNDRV_PCM_FORMAT_S16_LE:
 		param.spctl |= 0xf0;
 		sport->wdsize = 2;
-- 
1.7.9.5

