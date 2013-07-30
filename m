Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3G3JoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:44:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3G3Jda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chih-Chung Chang <chihchung@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 071/106] ASoC: max98088 - fix element type of the register cache.
Date: Tue, 30 Jul 2013 10:31:30 +0100
Message-Id: <1375176725-5825-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Chung Chang <chihchung@chromium.org>

commit cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2 upstream.

The registers of max98088 are 8 bits, not 16 bits. This bug causes the
contents of registers to be overwritten with bad values when the codec
is suspended and then resumed.

Signed-off-by: Chih-Chung Chang <chihchung@chromium.org>
Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98088.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 4790568..8df4597 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1594,7 +1594,7 @@ static int max98088_dai2_digital_mute(struct snd_soc_dai *codec_dai, int mute)
 
 static void max98088_sync_cache(struct snd_soc_codec *codec)
 {
-       u16 *reg_cache = codec->reg_cache;
+       u8 *reg_cache = codec->reg_cache;
        int i;
 
        if (!codec->cache_sync)
-- 
1.8.3.2

