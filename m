Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162309Ab3LFXST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162243Ab3LFXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 117/152] ASoC: blackfin: Fix missing break
Date: Fri,  6 Dec 2013 15:10:41 -0800
Message-Id: <1386371476-2477-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit afed4dbe3a043dbd833a53b6b4951e155708afd2 upstream.

Fixes: 4b2ffc205cb9 ('ASoC: Blackfin I2S: add 8-bit sample support')
Reported-by: David Binderman
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/blackfin/bf5xx-i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/blackfin/bf5xx-i2s.c b/sound/soc/blackfin/bf5xx-i2s.c
index 168d88b..822bb97 100644
--- a/sound/soc/blackfin/bf5xx-i2s.c
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -111,6 +111,7 @@ static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
 		bf5xx_i2s->tcr2 |= 7;
 		bf5xx_i2s->rcr2 |= 7;
 		sport_handle->wdsize = 1;
+		break;
 	case SNDRV_PCM_FORMAT_S16_LE:
 		bf5xx_i2s->tcr2 |= 15;
 		bf5xx_i2s->rcr2 |= 15;
-- 
1.8.3.2

